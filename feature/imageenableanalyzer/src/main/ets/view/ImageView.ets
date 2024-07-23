/**
 * @Author: xwang
 * @Date: 2024/7/23 14:49
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter'
import { MToast } from '@same/common'
import { image } from '@kit.ImageKit';
import { promptAction } from '@kit.ArkUI';

/**
 * 实现步骤：
 * 通过Image.enableAnalyzer(true)实现Image组件长摁拖拽元素并AI抠图：
 * 1. 目前AI分析支持传入的图片类型为PixelMap且为RGBA_8888类型的图片，因此定义方法使图片转成PixelMap且为RGBA_8888类型。
 * 2. 将需要AI抠图的Image组件添加.enableAnalyzer(true)方法，并传入PixelMap且为RGBA_8888类型的图片，即可开启AI抠图能力。
 * Image.enableAnalyzer()参考文档：
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-image-0000001815927572
 */

@AppRouter({ name: "imageenableanalyzer/ImageView" })
@Component
export struct ImageView {
  @State swiperIndex: number = 0;
  @State imagePixelMapList: Array<image.PixelMap> = []; // 定义转化过类型的图片数组
  scroller: Scroller = new Scroller();

  aboutToAppear() {
    const arr = [$r("app.media.imageenableanalyzer_cat"), $r("app.media.imageenableanalyzer_cat2")];
    arr.forEach(async (item) => {
      const imagePixelMap = await this.getPixmapFromMedia(item); // TODO：知识点：使jpg类型的图片转成PixelMap且为RGBA_8888类型
      this.imagePixelMapList.push(imagePixelMap);
    })
  }

  private async getPixmapFromMedia(resource: Resource) {
    const unit8Array = await getContext(this)?.resourceManager?.getMediaContent({
      bundleName: resource.bundleName,
      moduleName: resource.moduleName,
      id: resource.id
    })
    const imageSource = image.createImageSource(unit8Array.buffer.slice(0, unit8Array.buffer.byteLength));
    const createPixelMap: image.PixelMap = await imageSource.createPixelMap({
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    })
    await imageSource.release();
    return createPixelMap;
  }

  build() {
    Column() {
      this.Title()

      // 内容
      this.Content()
    }
    .width("100%")
    .backgroundColor(Color.White)
  }

  @Builder
  Title() {
    Row() {
      Image($r("app.media.imageenableanalyzer_batman"))
        .width(35)
        .height(35)
        .onClick(() => {
          MToast.showToast("1111")
        })

      Text("蝙蝠侠")
        .margin({ left: 13 })
        .onClick(() => {
          MToast.showToast("22222")
        })

      Blank()

      Image($r("app.media.imageenableanalyzer_share"))
        .width(35)
        .aspectRatio(1)
        .onClick(() => {
          MToast.showToast("33333")
        })
    }
    .width("100%")
    .padding(12)
  }

  @Builder
  // 内容组件
  Content() {
    Column() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Swiper() {
          ForEach(this.imagePixelMapList, (item: image.PixelMap) => { // 传入符合AI处理的图片类型并渲染图片
            /* 性能知识点：当数据量较大时，推荐使用懒加载加载数据。
             * 参考使用数据懒加载文章：
             * https://gitee.com/harmonyos-cases/cases/blob/master/docs/performance/arkts-performance-improvement-recommendation.md
             */
            Image(item)
              .enableAnalyzer(true) // TODO：知识点：开启Image组件的AI分析能力，目前支持分析PixelMap且为RGBA_8888类型的图片
              .width('100%')
              .height(400)
              .draggable(false) // 禁止整张图片拖动
          })
        }
        .height(400)
        .index(this.swiperIndex)
        .onChange((index: number) => {
          this.swiperIndex = index;
        })
        .indicator(new DotIndicator()
          .itemWidth($r('app.integer.imageenableanalyzer_indicator_itemWidth'))
          .itemHeight($r('app.integer.imageenableanalyzer_indicator_itemWidth'))
          .selectedItemWidth($r('app.integer.imageenableanalyzer_indicator_selectedItemWidth'))
          .selectedItemHeight($r('app.integer.imageenableanalyzer_indicator_selectedItemHeight'))
          .color(Color.Gray)
          .selectedColor(Color.Red))

        Text(`${this.swiperIndex + 1}/${this.imagePixelMapList.length}`)
          .fontSize($r('app.integer.imageenableanalyzer_bubble_text_fontSize'))
          .fontColor($r('app.color.imageenableanalyzer_white'))
          .width($r('app.integer.imageenableanalyzer_row_text_width'))
          .height($r('app.integer.imageenableanalyzer_row_text_height'))
          .borderRadius($r('app.integer.imageenableanalyzer_row_borderRadius'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.imageenableanalyzer_bg3'))
          .margin({
            right: $r('app.integer.imageenableanalyzer_row_margin_right'),
            bottom: $r('app.integer.imageenableanalyzer_row_margin_bottom')
          })
      }
      .width('100%')

      Column() {
        Text($r('app.string.imageenableanalyzer_image_drag_title')) // 文字标题
          .fontSize($r('app.integer.imageenableanalyzer_text_title_fontSize'))
          .fontWeight("bold")
          .padding({ top: $r('app.integer.imageenableanalyzer_text_padding_top') })
          .textAlign(TextAlign.Start)
        Text($r('app.string.imageenableanalyzer_image_drag_content')) // 文字内容
          .fontSize($r('app.integer.imageenableanalyzer_text_content_fontSize'))
          .padding({ top: $r('app.integer.imageenableanalyzer_text_padding_top') })
          .lineHeight($r('app.integer.imageenableanalyzer_contain_line_height'))
          .textAlign(TextAlign.Start)
        Text($r('app.string.imageenableanalyzer_image_drag_ref')) // 文字内容话题
          .fontSize($r('app.integer.imageenableanalyzer_text_content_fontSize'))
          .fontColor($r('app.color.imageenableanalyzer_content_color'))
          .padding({ top: $r('app.integer.imageenableanalyzer_text_padding_top') })
          .textAlign(TextAlign.Start)
          .onClick(() => {
            // 调用Toast显示提示:此样式仅为案例展示
            promptAction.showToast({ message: $r('app.string.imageenableanalyzer_only_show_ui') });
          })
      }.padding({
        top: $r('app.integer.imageenableanalyzer_view_padding_top'),
        bottom: $r('app.integer.imageenableanalyzer_view_padding_bottom'),
        left: $r('app.integer.imageenableanalyzer_view_padding_left'),
        right: $r('app.integer.imageenableanalyzer_view_padding_right')
      })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
  }
}