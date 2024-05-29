import { promptAction } from '@kit.ArkUI'

@Component
export struct ReadAgreement {
  build() {
    Text() {
      Span("阅读并同意")
        .fontColor("#999999")
      Span("服务协议及个人信息处理规则")
        .fontColor(Color.Orange)
        .onClick(() => {
          promptAction.showToast({ message: "服务协议及个人信息处理规则" })
        })
    }
    .textAlign(TextAlign.Start)
  }
}