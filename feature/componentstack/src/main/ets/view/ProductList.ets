/**
 * @Author: xwang
 * @Date: 2024/7/4 14:02
 * @Description:
 **/
import { MToast } from '@same/common/src/main/ets/utils/MToast';
import { PRODUCT_DATA } from '../mock/IconMock';
import { ProductDataModel, ProductDataSource } from '../model/ProductDataSource';

const COLUMNSPACE: number = 5; // column各子组件间距
const ASPECT_RATIO: number = 1; // 图片的宽高比
const OFFSET: number = -4; // 价格控件偏移量
const COLUMNSGAP: number = 12; // WaterFlow组件纵向间距
const ROWSGAP: number = 12; // WaterFlow组件横向间距

@Component
export struct ProductList {
  private productData: ProductDataSource = new ProductDataSource();

  aboutToAppear() {
    this.productData.pushData(PRODUCT_DATA)
  }

  build() {
    // TODO: 知识点：瀑布流容器，由“行”和“列”分割的单元格所组成，通过容器自身的排列规则，将不同大小的“项目”自上而下，如瀑布般紧密布局。
    WaterFlow() {
      LazyForEach(this.productData, (item: ProductDataModel) => {
        FlowItem() {
          Column({ space: COLUMNSPACE }) {
            Image(item.uri)
              .width(120)
              .aspectRatio(ASPECT_RATIO)
              .objectFit(ImageFit.Contain)
              .margin({ top: 5 })
              .alignSelf(ItemAlign.Center)
              .padding({ right: 20 })

            Text(item.title)
              .width('100%')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Black)

            Text(item.price)
              .width('100%')
              .fontSize(20)
              .offset({ x: OFFSET })// 因为￥是中文字符，上面的是中文字符，占的宽度不一样，所以需要对齐，添加offset
              .fontWeight(FontWeight.Bold)
              .fontColor("#e84026")

            Text(item.insurance)
              .fontSize(12)
              .fontColor("#ed6f21")
              .borderColor("#ed6f21")
              .borderWidth(1)
              .borderRadius(4)
              .padding({
                left: 8,
                right: 8,
                top: 3,
                bottom: 3
              })
              .margin({ top: 10 })
          }
          .alignItems(HorizontalAlign.Start)
          .padding({ left: 20 })
          .width("100%")
          .height(250)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .onClick(() => {
            MToast.showToast("没有实现")
          })
        }
      }, (item: ProductDataModel) => item.id.toString())
    }
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .columnsTemplate("1fr 1fr")
    .columnsGap(COLUMNSGAP)
    .rowsGap(ROWSGAP)
    .padding({ bottom: 80 })
  }
}