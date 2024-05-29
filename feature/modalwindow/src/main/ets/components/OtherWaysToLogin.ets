import { promptAction } from '@kit.ArkUI';

@Preview
@Component
export struct OtherWaysToLogin {
  @State buttonColor: ResourceColor = Color.Gray
  @State buttonContent: string = "发送短信验证码"
  // 手机号是否可用
  phoneNumberAvailable: boolean = false;
  isAgree: boolean = false
  // 可发送验证码的倒计时秒数
  countdownSeconds: number = 0;
  loginIcons: Resource[] = [$r('app.media.app_logo1'), $r('app.media.app_logo2'), $r('app.media.app_logo3')]

  build() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Image($r("app.media.phone")).width(40)
        Text("手机号登录").fontSize(20)
      }.width("100%")
      .justifyContent(FlexAlign.Start)

      Text("首次登录会产生新的账号").width("100%").textAlign(TextAlign.Start).fontSize(18)

      Row() {
        Text("+86")
        Image($r("app.media.arrow_right")).size({ width: 15, height: 15 })
          .margin({ left: 5 })
        TextInput({ placeholder: "请输入手机号" }).backgroundColor(Color.Transparent)
          .margin({ left: 5 })
          .maxLength(11)
          .onChange((value: string) => {
            if (value.length == 11) {
              this.phoneNumberAvailable = true
              this.buttonColor = Color.Blue;
            } else {
              this.phoneNumberAvailable = false
              this.buttonColor = Color.Grey;
            }
          })
      }.width("100%")
      .justifyContent(FlexAlign.Start)

      Button(this.buttonContent).width("100%").backgroundColor(this.buttonColor)
        .onClick(() => {
          if (this.countdownSeconds > 0) {
            return
          }

          if (!this.isAgree) {
            promptAction.showToast({ message: "请先阅读并同意用户协议" })
            return
          }
          if (!this.phoneNumberAvailable) {
            promptAction.showToast({ message: "请输入正确的手机号" })
            return
          }
          promptAction.showToast({ message: "短信验证码已发送" })
          this.buttonColor = Color.Gray
          this.countdownSeconds = 30
          const timerId = setInterval(() => {
            this.countdownSeconds--
            if (this.countdownSeconds <= 0) {
              this.buttonContent = "发送短信验证码"
              clearInterval(timerId)
              this.buttonColor = this.phoneNumberAvailable ? Color.Blue : Color.Gray
              return
            } else {
              this.buttonContent = this.countdownSeconds + "s后可再次发送"
            }
          }, 1000)
        })

      Row() {
        Checkbox().select(this.isAgree).onChange((value: boolean) => {
          this.isAgree = value
        })
        Text() {
          Span("阅读并同意").fontColor("#999999")
          Span("服务协议及个人信息处理规则")
            .fontColor(Color.Orange)
            .onClick(() => {
              promptAction.showToast({ message: "服务协议及个人信息处理规则" })
            })
        }
      }

      List({ space: 20 }) {
        ForEach(this.loginIcons, (item: Resource) => {
          ListItem() {
            Image(item)
              .width(32)
              .onClick(() => {
                promptAction.showToast({ message: "使用XX应用登录" })
              })
          }
        })
      }.listDirection(Axis.Horizontal)
      .backgroundColor("#fff000")
      .alignListItem(ListItemAlign.Center)
      .size({ width: "100%", height: 60 })

    }.size({ width: "100%", height: "100%" })
    .justifyContent(FlexAlign.Center)

  }
}