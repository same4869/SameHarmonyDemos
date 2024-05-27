import { promptAction } from '@kit.ArkUI';

@Component
export struct AddressExchangeView {
  // 内容相隔距离
  private columnSpace: number = 16;

  build() {
    Column({ space: this.columnSpace }) {
      Row() {
        Text($r("app.string.address_exchange_address_left"))
          .width($r("app.string.address_exchange_address_width"))
          .fontSize(20)

        Stack(){
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
        }

        Text($r("app.string.address_exchange_address_right"))
          .width($r("app.string.address_exchange_address_width"))
          .textAlign(TextAlign.End)
          .fontSize(20)
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