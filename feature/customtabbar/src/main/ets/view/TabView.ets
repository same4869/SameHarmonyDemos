@Preview
@Component
export struct TabView {
  @Provide selectedIndex: number = 0
  private controller: TabsController = new TabsController()

  build() {
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
    }.onChange((index: number) => {
      this.selectedIndex = index
    })


  }
}