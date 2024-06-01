import { MethodPoints } from './MethodPoints';
import { SceneModuleInfo } from './model/SceneModuleInfo';
import { TabDataModel, TAB_DATA } from './model/TabData';
import { WaterFlowDataSource } from './model/WaterFlowDataSource';

@Preview
@Component
export struct FunctionalScenes {
  private scrollController: Scroller = new Scroller();
  @State tabsIndex: number = 0;
  tabsController: TabsController = new TabsController();
  @Link listData: SceneModuleInfo[]
  dataSource: WaterFlowDataSource = new WaterFlowDataSource(this.listData)

  @Builder
  tabsMenu() {
    Menu() {
      ForEach(TAB_DATA, (item: TabDataModel) => {
        MenuItem({ content: item.navData })
          .onClick(() => {
            this.tabsIndex = item.id
            this.tabsController.changeIndex(item.id)
            if (item.id > 2) {
              this.scrollController.scrollToIndex(item.id, true)
            }
          })
      })
    }
  }

  @Builder
  tabBuilder(index: number, name: string | undefined) {
    Stack() {
      Column() {
      }
      .width(this.tabsIndex === index ? 97 : 71)
      .backgroundColor(this.tabsIndex === index ? '#0A59F7' : "#000000")
      .opacity(this.tabsIndex === index ? 1 : 0.05)
      .height(38)
      .borderRadius(21)

      Text(name).fontSize(14).fontColor(this.tabsIndex === index ? Color.White : Color.Black)
        .opacity(this.tabsIndex === index ? 1 : 0.8)
        .height("100%")
    }
    .margin(index != 0 && index !== TAB_DATA.length ? { left: 9 } : {
      left: 0, right: 0
    })
    .align(Alignment.Center)
    .onClick(() => {
      this.tabsIndex = index
      this.tabsController.changeIndex(index)
    })
  }

  build() {
    Column() {
      Row() {
        Stack() {
          List({ scroller: this.scrollController }) {
            ForEach(TAB_DATA, (tabItem: TabDataModel) => {
              ListItem() {
                this.tabBuilder(tabItem.id, tabItem.navData)
              }
            })
          }
          .margin({ top: 3 })
          .height(38)
          .listDirection(Axis.Horizontal)
          .padding({ right: 46 })
          .scrollBar(BarState.Off)

          Row() {
            Row() {
              Image($r("app.media.ic_public_more"))
                .width(20)
            }
            .justifyContent(FlexAlign.Center)
            .width(43)
            .height(43)
            .borderRadius(100)
            .backgroundColor("#d8d8d8")
            .bindMenu(this.tabsMenu)
          }
          .linearGradient({
            angle: 90,
            colors: [['rgba(241, 241, 241, 0)', 0], ['#F1F3F5', 0.2], ['#F1F3F5', 1]]
          })
          .justifyContent(FlexAlign.End)
          .width(60)
          .height(43)
        }
        .alignContent(Alignment.TopEnd)
      }
      .padding({ left: 13, right: 13 })
      .margin({ top: 8 })

      Tabs({ controller: this.tabsController }) {
        ForEach(TAB_DATA, (tabItem: TabDataModel) => {
          TabContent() {
            WaterFlow() {
              LazyForEach(this.dataSource, (waterFlowItem: SceneModuleInfo) => {
                FlowItem() {
                  if (tabItem.navData === "全部" || tabItem.navData === waterFlowItem.category) {
                    MethodPoints({ listData: waterFlowItem })
                  }
                }
              }, (waterFlowItem: SceneModuleInfo) => JSON.stringify(waterFlowItem))
            }
            .nestedScroll({
              scrollForward: NestedScrollMode.PARENT_FIRST,
              scrollBackward: NestedScrollMode.SELF_FIRST
            })
            .cachedCount(1)
            .columnsTemplate('1fr 1fr')
            .columnsGap(6)
            .width('100%')
          }
          .backgroundColor("#f1f1f1")
        })
      }
      .margin({ top: 8 })
      .backgroundColor(Color.White)
      .padding({ left: 13, right: 13 })
      .barWidth(10)
      .barHeight(10)
      .onChange((index: number) => {
        this.tabsIndex = index
        this.scrollController.scrollToIndex(index)
      })
    }
    .padding({ bottom: 100 })
    .height("100%")
    .backgroundColor("#f1f1f1")
  }
}