import { ProductDataModel } from '../model/GoodsModel';
import { promptAction } from '@kit.ArkUI';
import { PRODUCT_DATA } from '../mock/GoodsMock';

const GUTTER_X: number = 8; // 商品上下间隔
const GUTTER_Y: number = 8; // 商品左右间隔
const IMAGE_ASPECT_RATIO: number = 1; // 图片的宽高比
const OFFSET: number = -3; // 价格控件偏移量
const SPAN: number = 6; // 超过规定列数6时自动换行

@Component
export struct GoodsList {
  build() {
    GridRow({ gutter: { x: GUTTER_X, y: GUTTER_Y } }) {
      // GridRow组件不支持LazyForEach方法
      ForEach(PRODUCT_DATA, (item: ProductDataModel) => {
        GridCol({ span: SPAN }) {
          ItemView({ item: item })
        }
      }, (item: ProductDataModel) => item.id.toString())
    }
    .padding({
      left: 12,
      right: 12,
      top: 12,
      bottom: 12
    })
    .backgroundColor("#e7d9d9")
  }
}

@Component
struct ItemView {
  @Prop item: ProductDataModel

  build() {
    Column() {
      Image(this.item.uri)
        .width("70%")
        .aspectRatio(IMAGE_ASPECT_RATIO)
        .objectFit(ImageFit.Contain)
        .margin({ bottom: 12 })

      Column() {
        // TODO: 知识点：UI组件颜色属性是系统中的颜色（即分层参数颜色资源），深浅模式自动切换色值。
        // 用系统提供的分层参数颜色资源方式设置色值
        Text(this.item.price)
          .fontSize(16)
          .offset({ x: OFFSET })
          .fontColor($r('sys.color.ohos_id_color_foreground'))

        // TODO: 知识点：SVG格式在resources目录下新增dark/element目录，创建深色模式color.json文件，设置深色模式图片fillColor颜色。（注意事项:颜色name必须相同）
        // SVG格式图片fillColor颜色资源ID方式设置（浅色模式色值为'#000000'、深色模式色值为'#FFFFFF'）
        Row() {
          Image($r("app.media.fit_for_dark_mode_view"))
            .fillColor("#000000")
            .width(20)
            .aspectRatio(IMAGE_ASPECT_RATIO)
            .objectFit(ImageFit.Contain)

          Text(this.item.views)
            .fontSize(16)
            .margin({ left: 5 })
            .fontColor($r('sys.color.ohos_id_color_foreground'))
        }.margin({ top: 6 })
      }
      .margin({ left: 10 })
      .alignItems(HorizontalAlign.Start)
    }
    .onClick(() => {
      promptAction.showToast({
        message: "什么都没做"
      })
    })
    .borderRadius(10)
    .padding(12)
    .backgroundColor("#ffffff")
  }
}