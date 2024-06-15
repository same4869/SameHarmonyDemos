@Preview
@Component
@Entry({ routeName: 'navigationbarchange/NavigationBarChangeView' })
export struct NavigationBarChangeView {
  // Scroll的偏移量
  @State scrollOffset: number = 0;
  // 创建Scroll对象
  private scroller: Scroller = new Scroller();
  // 透明度默认值
  private opacityDefaultValue: number = 1;
  // 透明度计算基数
  private opacityComputeRadix: number = 35;
  // 状态栏组件的透明度
  @State headOpacity: number = 0;
  // 内容相隔距离
  private columnSpace: number = 15;

  build() {
    Stack() {
      Scroll(this.scroller) {
        Column({ space: this.columnSpace }) {
          Text("欢迎")
            .fontSize(22)
            .width("100%")
            .textAlign(TextAlign.Start)
            .margin({ top: 60 })

          Text("新用户享特别大礼包")
            .fontSize(14)
            .margin({ top: -5 })
            .width("100%")
            .textAlign(TextAlign.Start)

          Button("登录和注册", { type: ButtonType.Capsule })
            .margin({ top: 20 })
            .fontSize(18)
            .height(40)
            .width(130)
            .position({ y: 110 })

          Text("购物区")
            .fontColor(Color.Black)
            .fontSize(20)
            .margin({ top: 60, bottom: -5 })
            .width("100%")
            .textAlign(TextAlign.Center)

          Image($r('app.media.navigationbarchange_shopping'))
            .width("100%")
            .height("25%")
            .borderRadius(12)

          // "娱乐"功能区
          Text("娱乐区")
            .fontColor(Color.Black)
            .fontSize(20)
            .margin({
              top: 10,
              bottom: -10
            })
            .width("100%")
            .textAlign(TextAlign.Center)

          Image($r('app.media.navigationbarchange_happly'))
            .width("100%")
            .height("25%")
            .borderRadius(12)

          // "休闲"功能区
          Text("休闲区")
            .fontColor(Color.Black)
            .fontSize(20)
            .margin({
              top: 10,
              bottom: -10
            })
            .width("100%")
            .textAlign(TextAlign.Center)

          Image($r('app.media.navigationbarchange_relaxation'))
            .width("100%")
            .height("25%")
            .borderRadius(12)
            .margin({ bottom: 5 })
        }
        .width("92%")
      }
      .width("100%")
      .height("100%")
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      // 高性能知识点：onScroll属于频繁回调接口，应该避免在内部进行冗余和耗时操作，例如避免打印日志
      .onScroll(() => {
        // TODO 知识点：显隐变化效果，获取Scroll偏移量，计算透明度，实现效果
        this.scrollOffset = this.scroller.currentOffset().yOffset
        if (this.scrollOffset <= this.opacityComputeRadix) {
          this.headOpacity = this.scrollOffset / this.opacityComputeRadix
        } else {
          this.headOpacity = this.opacityDefaultValue
        }
      })

      Header({ headOpacity: this.headOpacity, titleBackgroundColor: "#ffffff", isTop: false })

      Header({ headOpacity: this.opacityDefaultValue, titleBackgroundColor: "#00000000", isTop: true })
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#ffd9e8ef")
    .alignContent(Alignment.Top)
  }
}

@Component
struct Header {
  // 状态栏组件的透明度
  @Prop headOpacity: number;
  // 状态栏的背景颜色
  @Prop titleBackgroundColor: ResourceStr;
  // 内容相隔距离
  private columnSpace: number = 15;
  // 是否在顶部的标志
  @Prop isTop: Boolean;
  // 组件置顶时透明度
  private opacityTopValue: number = 0;
  // 组件非置顶时透明度
  private opacityUnTopValue: number = 1;

  build() {
    Row() {
      Row({ space: this.columnSpace }) {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.navigationbarchange_button_setting_configuration'))
            .width(35)
            .height(35)
        }.backgroundColor("#00000000")

        Button({ type: ButtonType.Normal }) {
          Image($r("app.media.navigationbarchange_button_scan"))
            .width(30)
            .height(30)
        }
        .backgroundColor("#00000000")
      }
      .justifyContent(FlexAlign.Start)
      .margin({ left: -10 })
      .width("30%")

      Text("我的")
        .fontColor(Color.Black)
        .fontSize(22)
        .opacity(this.isTop ? this.opacityTopValue : this.opacityUnTopValue)

      Row() {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.navigationbarchange_button_customer_service_line'))
            .width(30)
            .height(30)
        }
        .backgroundColor("#00000000")
      }.justifyContent(FlexAlign.End)
      .margin({ right: -10 })
      .width("30%")
    }
    .opacity(this.headOpacity)
    .height(60)
    .width("100%")
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(this.titleBackgroundColor)
  }
}