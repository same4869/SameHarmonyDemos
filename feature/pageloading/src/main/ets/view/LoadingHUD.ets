/**
 * @Author: xwang
 * @Date: 2024/7/12 15:34
 * @Description:
 **/
@Component
export struct LoadingHUD {
  build() {
    Column() {
      // TODO: 知识点：创建加载进展组件，除支持通用属性外，还支持设置加载进度条前景色和设置动画显示或者不显示。
      LoadingProgress()
        .color(Color.White)
        .width(80).height(80)

      Text("努力加载中...")
        .fontSize(16)
        .fontColor(Color.White)
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#40000000")
    .justifyContent(FlexAlign.Center)
  }
}