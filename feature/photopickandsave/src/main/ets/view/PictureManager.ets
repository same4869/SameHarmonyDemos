import { SaveNetWorkPictures } from './SaveNetWorkPictures'
import { SelectPictures } from './SelectPictures'

@Preview
@Component
@Entry({ routeName: 'photopickandsave/PictureManager' })
export struct PictureManager {
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  @Builder
  TabBuilder(index: number, name: ResourceStr) {
    Column() {
      Text(name)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(16)
        .fontColor(this.currentIndex === index ? '#007DFF' : '#182431')
        .lineHeight(30)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .margin({ bottom: 7 })
        .opacity(this.currentIndex === index ? 1 : 0.6)

      Divider()
        .strokeWidth(2)
        .width(48)
        .borderRadius(1)
        .color("#007DFF")
        .opacity(this.currentIndex === index ? 1 : 0)
        .margin({ bottom: 8 })
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
      TabContent() {
        SaveNetWorkPictures()
      }.tabBar(this.TabBuilder(0, "下载保存图片"))

      TabContent() {
        // 图片选择模块
        SelectPictures()
      }.tabBar(this.TabBuilder(1, "选择图片"))
    }
    .barWidth(200)
    .barHeight(40)
    .onChange((index: number) => {
      this.currentIndex = index
    })

  }
}