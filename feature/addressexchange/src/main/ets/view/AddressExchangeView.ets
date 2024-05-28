import { curves, promptAction } from '@kit.ArkUI';

@Entry({ routeName: 'AddressExchangePage' })
@Component
export struct AddressExchangeView {
  // 内容相隔距离
  private columnSpace: number = 16;
  // 单次旋转180°
  private rotateAddAngle: number = 180;
  // 整体内容区宽度
  private rowWidth: number = 300;
  // 单次偏移距离
  private distance: number = this.rowWidth * 0.6;
  // 初始化偏移距离
  private zeroTranslate: number = 0;
  @State swap: boolean = false
  @State rotateAngle: number = 0
  // 偏移量
  @State translateX: number = 0;

  build() {
    Column({ space: this.columnSpace }) {
      Row() {
        Text($r("app.string.address_exchange_address_left"))
          .width($r("app.string.address_exchange_address_width"))
          .fontSize(20)
          .translate({ x: this.translateX })
          .textAlign(this.swap ? TextAlign.End : TextAlign.Start)

        Stack() {
          Image($r("app.media.address_exchange_airplane"))
            .size({
              height: $r("app.integer.address_exchange_airplane_size"),
              width: $r("app.integer.address_exchange_airplane_size")
            })
          Image($r("app.media.address_exchange_recycle"))
            .size({
              height: $r("app.integer.address_exchange_recycle_size"),
              width: $r("app.integer.address_exchange_recycle_size")
            })
            .rotate({ angle: this.rotateAngle })
            .animation({
              curve: Curve.EaseOut,
              playMode: PlayMode.Normal,
              duration: 2000
            })
        }
        .onClick(() => {
          this.swap = !this.swap
          this.rotateAngle += this.rotateAddAngle
          animateTo({ curve: curves.springMotion() }, () => {
            if (this.swap) {
              this.translateX = this.distance;
            } else {
              this.translateX = this.zeroTranslate;
            }
          })
        })

        Text($r("app.string.address_exchange_address_right"))
          .width($r("app.string.address_exchange_address_width"))
          .textAlign(TextAlign.End)
          .fontSize(20)
          .translate({ x: -this.translateX })
          .textAlign(this.swap ? TextAlign.Start : TextAlign.End)
      }.margin({ top: 20 })

      Row({ space: this.columnSpace }) {
        Text($r("app.string.address_exchange_date"))
          .fontSize($r("app.integer.address_exchange_date_size"))
          .fontWeight(FontWeight.Medium)
        Text($r("app.string.address_exchange_week"))
      }.width(300)
      .margin({ top: 10 })

      Button($r("app.string.address_exchange_search_ticket"))
        .height(40)
        .width(300)
        .onClick(() => {
          promptAction.showToast({
            message: "nothing to do here"
          })
        })
    }
    .width("94%")
    .height(178)
  }
}