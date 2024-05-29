import { CustomTabBar } from './CustomTabBar'

@Preview
@Entry({ routeName: 'customtabbar' })
@Component
export struct TabView {
  @Provide selectedIndex: number = 0
  private controller: TabsController = new TabsController()

  build() {
    Column() {
      Tabs({ index: this.selectedIndex, barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          Text("首页").fontSize(26)
        }

        TabContent() {
          Text("新品").fontSize(26)
        }

        TabContent() {
          Text("社区").fontSize(26)
        }

        TabContent() {
          Text("购物车").fontSize(26)
        }

        TabContent() {
          Text("我的").fontSize(26)
        }
      }
      .vertical(false)
      .scrollable(false)
      .layoutWeight(1)
      .backgroundColor("#ffdbd9d9")
      .barHeight(0)
      .onChange((index: number) => {
        this.selectedIndex = index
      })

      CustomTabBar({ selectedIndex: $selectedIndex })
    }
    .width("100%")
    .height("100%")
  }
}