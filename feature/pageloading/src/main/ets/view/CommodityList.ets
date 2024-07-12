/**
 * @Author: xwang
 * @Date: 2024/7/12 15:47
 * @Description:
 **/
import { PRODUCTS_DATA } from '../mock/CommodityMock';
import { CommodityDataModel } from '../model/CommodityDataModel';
import { CommodityDataSource } from '../model/CommodityDataSource';
import { promptAction } from '@kit.ArkUI';

@Component
export struct CommodityList {
  private commodityData: CommodityDataSource = new CommodityDataSource();

  aboutToAppear(): void {
    this.commodityData.pushData(PRODUCTS_DATA)
  }

  build() {
    Column() {
      Column() {
        Image($r("app.media.page_loading_light_mode_banner"))
          .objectFit(ImageFit.Contain)
          .borderRadius($r("app.integer.page_loading_banner_border_radius"))
          .margin({ top: $r("app.integer.page_loading_banner_margin_top") })
          .width('100%')
          .shadow({
            radius: $r("app.integer.page_loading_banner_shadow_border_radius"),
            color: $r("app.color.page_loading_banner_shadow_color"),
            offsetX: 10,
            offsetY: 10
          })

        Text($r("app.string.page_loading_goods_title_text"))
          .fontColor(Color.Black)
          .fontSize($r("app.integer.page_loading_commodity_font"))
          .fontWeight(FontWeight.Bold)
          .height($r("app.integer.page_loading_new_commodity_height"))
          .width('100%')
          .textAlign(TextAlign.Center)
      }
      .padding({
        left: $r("app.integer.page_loading_column_padding_left"),
        right: $r("app.integer.page_loading_column_padding_right")
      })
      .backgroundColor(Color.White)

      List() {
        LazyForEach(this.commodityData, (item: CommodityDataModel) => {
          ListItem() {
            ItemView({ item: item })
          }
          .padding({
            left: $r("app.integer.page_loading_commodity_list_item_padding"),
            right: $r("app.integer.page_loading_commodity_list_item_padding")
          })
          .margin({ top: $r("app.integer.page_loading_commodity_list_item_margin_top") })
        }, (item: CommodityDataModel) => item.id.toString())
      }
      .width('100%')
      .layoutWeight(1)
    }
    // 设置背景颜色渐变
    .linearGradient({
      angle: 180,
      colors: [[0xFFFFFF, 0.0], [0xdddddd, 1.0]]
    })
  }
}

@Component
struct ItemView {
  @Prop item: CommodityDataModel;

  build() {
    // TODO: 知识点：相对布局组件，用于复杂场景中元素对齐的布局，容器内子组件区分水平方向，垂直方向子组件可以将容器或者其他子组件设为锚点。
    RelativeContainer() {
      Image(this.item.uri)
        .width($r("app.integer.page_loading_commodity_image_width"))
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
        .padding({
          top: $r("app.integer.page_loading_commodity_image_padding_top"),
          bottom: $r("app.integer.page_loading_commodity_image_padding_bottom")
        })
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          left: { anchor: "__container__", align: HorizontalAlign.Start }
        })
        .id('image')

      Text(this.item.insurance)
        .fontSize($r("app.integer.page_loading_commodity_insurance_font_size"))
        .fontColor($r("app.color.page_loading_goods_insurance_text_color"))
        .borderColor($r("app.color.page_loading_goods_insurance_border_color"))
        .borderWidth($r("app.integer.page_loading_commodity_insurance_border_width"))
        .borderRadius($r("app.integer.page_loading_commodity_insurance_border_radius"))
        .padding({
          left: $r("app.integer.page_loading_commodity_insurance_padding_left"),
          right: $r("app.integer.page_loading_commodity_insurance_padding_right"),
          top: $r("app.integer.page_loading_commodity_insurance_padding_top"),
          bottom: $r("app.integer.page_loading_commodity_insurance_padding_bottom")
        })
        .margin({ right: $r("app.integer.page_loading_commodity_insurance_margin_right") })
        .alignRules({
          right: { anchor: "__container__", align: HorizontalAlign.End },
          center: { anchor: "__container__", align: VerticalAlign.Center }
        })
        .id('insurance')

      Row() {
        Image($r("app.media.page_loading_views"))
          .width($r("app.integer.page_loading_views_image_width"))
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)

        Text(this.item.views)
          .fontSize($r("app.integer.page_loading_views_font"))
          .margin({ left: $r("app.integer.page_loading_views_margin_left") })
          .fontColor(Color.Black)
      }
      .height($r("app.integer.page_loading_views_height"))
      .width($r("app.integer.page_loading_views_width"))
      .margin({ top: $r("app.integer.page_loading_views_margin_top") })
      .justifyContent(FlexAlign.End)
      .alignRules({
        middle: { anchor: "insurance", align: HorizontalAlign.Center },
        top: { anchor: "insurance", align: VerticalAlign.Bottom }
      })
      .id('views')

      Column() {
        Text(this.item.title)
          .fontSize($r("app.integer.page_loading_commodity_title_text_font_size"))
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .width('100%')

        Text(this.item.price)
          .fontSize($r("app.integer.page_loading_commodity_price_text_font_size"))
          .fontWeight(FontWeight.Bold)
          .offset({ x: -4 })// 因为￥是中文字符，上面的是中文字符，占的宽度不一样，所以需要对齐，添加offset
          .fontColor($r("app.color.page_loading_goods_price_text_color"))
          .margin({ top: $r("app.integer.page_loading_commodity_price_margin_top") })
          .width('100%')
      }
      .justifyContent(FlexAlign.Start)
      .alignRules({
        left: { anchor: "image", align: HorizontalAlign.End },
        right: { anchor: "insurance", align: HorizontalAlign.Start },
        center: { anchor: "image", align: VerticalAlign.Center }
      })
      .id('column')
      .onClick(() => {
        promptAction.showToast({ message: $r("app.string.page_loading_commodity_other_function") });
      })
    }
    .height($r("app.integer.page_loading_commodity_list_item_height"))
    .borderRadius($r("app.integer.page_loading_commodity_border_radius"))
    .width('100%')
    .backgroundColor(Color.White)
  }
}