import { ReadAgreement } from './ReadAgreement'
import { promptAction } from '@kit.ArkUI'
import { OtherWaysToLogin } from './OtherWaysToLogin';

@Preview
@Component
export struct DefaultLogin {
  isConfirmed: boolean = false
  @State isDefaultLogin: boolean = true;

  @Builder
  DefaultLoginPage() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Image($r("app.media.batman")).size({ width: 40, height: 40 })
        Column() {
          Text("Hi，欢迎回来").fontWeight(FontWeight.Bold)
            .fontSize(20).fontColor(Color.Black)
          Text("登录后更精彩，美好生活即将开始").fontColor("#333333")
        }.alignItems(HorizontalAlign.Start)
      }.width("100%")

      Text("1388888888")
        .size({ width: "100%", height: 40 })
        .fontWeight(FontWeight.Bold)
        .padding({ left: 12, top: 5, bottom: 5 })
        .borderRadius(8)
        .backgroundColor("#eeeeee")

      Text("认证服务由XX提供").fontSize(15).fontColor("#666666")
        .textAlign(TextAlign.Start).width("100%")

      Row() {
        Checkbox().select(this.isConfirmed)
          .onChange((v: boolean) => {
            this.isConfirmed = v
          })

        ReadAgreement()
      }

      Button("手机号码一键登录")
        .fontColor(Color.White)
        .borderRadius(8)
        .type(ButtonType.Normal)
        .width("100%")
        .onClick(() => {
          if (this.isConfirmed) {
            promptAction.showToast({ message: "登录成功" })
          } else {
            promptAction.showToast({ message: "请先阅读并同意协议" })
          }
        })

      Row() {
        Text("其他登录方式").fontColor("#777777").onClick(() => {
          this.isDefaultLogin = false
        })

        Blank()

        Text("遇到问题").fontColor("#777777").onClick(() => {
          promptAction.showToast({ message: "遇到问题" })
        })
      }.width("100%")

    }
    .size({ width: "100%", height: "100%" })
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.isDefaultLogin) {
        this.DefaultLoginPage()
      } else {
        OtherWaysToLogin()
      }

      Image($r("app.media.arrow_back")).width(25).height(25)
        .margin({ top: 20 })
        .onClick(() => {
          if (this.isDefaultLogin) {

          } else {
            this.isDefaultLogin = true
          }
        })
    }
    .size({ width: "100%", height: "100%" })
    .padding({ top: 12, left: 12, right: 12 })
  }
}