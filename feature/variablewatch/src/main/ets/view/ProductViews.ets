import { FistGoodsModel, SecondGoodsItemList, ThirdGoodsItem } from '../model/GoodsModel'

const OHOS_CARD_MARGIN = 8; // 文字和图片之间的间距

@Component
export default struct GoodViewStruct {
  @Link model: FistGoodsModel

  build() {
    Column() {
      SecondView({ data: this.model.itemList })
    }
  }
}

@Component
struct SecondView {
  // TODO: 知识点：@ObjectLink装饰器装饰的状态变量用于接收@Observed装饰的类的实例，和父组件中对应的状态变量建立双向数据绑定
  @ObjectLink data: SecondGoodsItemList

  build() {
    Grid() {
      ForEach(this.data.itemList, (item: ThirdGoodsItem, index: number) => {
        GridItem() {
          ThirdView({ item: this.data.itemList[index] })
        }
        .backgroundColor("#ffffff")
        .borderRadius(12)
      })
    }
    .columnsTemplate('1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .rowsGap(8)
    .columnsGap(8)
    .width("100%")
    .height("40%")
  }
}

@Component
struct ThirdView {
  // TODO: 知识点：@ObjectLink装饰器装饰的状态变量用于接收@Observed装饰的类的实例，和父组件中对应的状态变量建立双向数据绑定
  @ObjectLink item: ThirdGoodsItem

  build() {
    Column({ space: OHOS_CARD_MARGIN }) {
      Image(this.item.imageSrc).width(90)
      Text(this.item.price.toString()).fontSize(14)
    }
    .alignItems(HorizontalAlign.Center)
    .width("100%")
    .padding(8)
    .borderRadius(12)
  }
}