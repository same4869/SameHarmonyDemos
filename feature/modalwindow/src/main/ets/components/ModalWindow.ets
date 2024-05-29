import { DefaultLogin } from './DefaultLogin'

@Preview
@Component
@Entry({ routeName: 'modalwindow' })
export struct ModalWindow {
  @State isPresent: boolean = false

  @Builder
  loginBuilder() {
    Column() {
      DefaultLogin()
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#f2f2f2")
  }

  build() {
    Column() {
      Button("点击跳转到登录页")
        .fontColor(Color.White)
        .borderRadius(8)
        .bindContentCover(this.isPresent, this.loginBuilder, {
          modalTransition: ModalTransition.DEFAULT,
          onDisappear: () => {
            this.isPresent = !this.isPresent
          }
        })
        .onClick(() => {
          this.isPresent = true
        })
    }
    .size({ width: "100%", height: "100%" })
    .padding(12)
    .justifyContent(FlexAlign.Center)
  }
}