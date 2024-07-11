/**
 * @Author: xwang
 * @Date: 2024/7/11 11:16
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter'
import { MToast } from '@same/common/src/main/ets/utils/MToast'
import { TopTabContent } from '../model/DataModel'
import { VideoSwiper } from './VideoSwiper'

@AppRouter({ name: "shortvideo/ShortVideo" })
@Component
export struct ShortVideo {
  @State currentIndex: number = 1
  scroller: Scroller = new Scroller()
  private topTabListData: TopTabContent = new TopTabContent()

  build() {
    Stack({ alignContent: Alignment.Top }) {
      if (this.currentIndex === 1) {
        VideoSwiper() // 视频滑动组件
          .height('100%')
      }

      Row() {
        Image($r("app.media.shortvideo_search_icon"))
          .width(20)
          .height(20)
          .onClick(() => {
            MToast.showToast("没有实现 搜索")
          })

        List({ scroller: this.scroller }) {
          LazyForEach(this.topTabListData, (item: string, index) => {
            ListItem() {
              Column() {
                Text(item).fontColor(this.currentIndex === index ? Color.White : "#aaaaaa")
                  .fontSize(16)
                  .onClick(() => {
                    MToast.showToast("仅演示" + item)
                  })

                Divider()
                  .width(this.currentIndex === index ? 30 : 0)
                  .strokeWidth(2)
                  .color(this.currentIndex === index ? Color.White : Color.Gray)
                  .margin({
                    top: 5
                  })
              }
            }
            .padding({ top: 15 })
            .width("25%")
          }, (item: string, index) => JSON.stringify(item))
        }
        .listDirection(Axis.Horizontal)
        .height("100%")
        .width("60%")

        Image($r("app.media.shortvideo_add1"))
          .width(20)
          .height(20)
          .onClick(() => {
            MToast.showToast("仅演示 添加")
          })
      }
      .height(50)
      .width("100%")
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width("100%")
    .height("100%")
    .backgroundColor(Color.Black)
  }
}