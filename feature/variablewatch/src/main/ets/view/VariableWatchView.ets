import { FistGoodsModel, loadSource,
  originItemList,
  SecondGoodsItemList, targetItemList, ThirdGoodsItem } from '../model/GoodsModel';
import GoodViewStruct from './ProductViews'

const OHOS_CARD_MARGIN = 16 // 各组件上下间距

@Preview
@Component
@Entry({ routeName: 'variablewatch/VariableWatchView' })
export struct VariableWatchView {
  @State itemList: Array<ThirdGoodsItem> = loadSource(); // 初始化第三层嵌套数组
  @State imgItemList: SecondGoodsItemList = new SecondGoodsItemList(this.itemList); // 初始化第二层嵌套数组列表
  @State model: FistGoodsModel = new FistGoodsModel(this.imgItemList); // 初始化首层Model类
  @State isGoodsChanged: Boolean = false; // 数据刷新标志

  build() {
    Column({ space: OHOS_CARD_MARGIN }) {
      Column({ space: OHOS_CARD_MARGIN }) {
        Text("功能介绍").fontSize(20)
        Text("该方案展示了三层类嵌套对象的监听，使用@ObjectLink和@Observed类装饰器进行双向数据同步，其中的图片和价格是第三层的数据，点击按钮更新数据，图片和价格也会刷新显示")
          .fontSize(20)
      }
      .backgroundColor("#ffffff")
      .width("100%")
      .padding(12)
      .borderRadius(12)

      Column() {
        Text("商城").fontSize(20)
      }

      Row() {
        Text("热门推荐")
      }.justifyContent(FlexAlign.Start).width("100%")

      Column() {
        GoodViewStruct({ model: $model })
      }.width("100%")

      Column() {
        Button("刷新商品和价格(仅演示)")
          .fontSize(14)
          .width("100%")
          .onClick(() => {
            // 点击后更新第三层嵌套class ThirdGoodsItem的数据，UI刷新
            this.isGoodsChanged = !this.isGoodsChanged
            if (this.isGoodsChanged) {
              this.itemList.forEach((item, index) => {
                item.imageSrc = targetItemList[index].imageSrc
                item.price = targetItemList[index].price
              })
            } else {
              this.itemList.forEach((item, index) => {
                item.imageSrc = originItemList[index].imageSrc
                item.price = originItemList[index].price
              })
            }
          })
      }
    }
    .size({ height: "100%", width: "100%" })
    .backgroundColor("#f1f3f5")
    .padding(12)
  }
}