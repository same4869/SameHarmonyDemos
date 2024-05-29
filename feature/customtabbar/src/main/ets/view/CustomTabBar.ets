import { TABINFO } from '../model/TabBarData'
import { TabBarDataType } from '../model/TabBarDataType'

const COMMUNITY_TAB_BAR_INDEX: number = 2

@Component
export struct CustomTabBar {
  @Link selectedIndex: number

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
      ForEach(TABINFO, (item: TabBarDataType, tabIndex: number) => {
        TabItem({ tabBarIndex: tabIndex, selectedIndex: $selectedIndex})
      })
    }
    .height(60)
  }
}

@Component
struct TabItem {
  @State iconOffset: number = 0; // 初始化tabBar图片的偏移量
  @Prop tabBarIndex: number
  @Link selectedIndex: number

  build() {
    Stack() {
      Column() {
        if (this.tabBarIndex == COMMUNITY_TAB_BAR_INDEX) {
          Column() {
            Image(this.selectedIndex === this.tabBarIndex ? TABINFO[this.tabBarIndex].selectedIcon : TABINFO[this.tabBarIndex].defaultIcon)
              .size({
                width: 43,
                height: 43
              })
              .interpolation(ImageInterpolation.High)
          }
          .width(52)
          .height(52)
          .borderRadius(24)
          .margin({ top: -15 })
          .backgroundColor(Color.White)
          .justifyContent(FlexAlign.Center)
        } else {
          Column() {
            Image(this.selectedIndex === this.tabBarIndex ? TABINFO[this.tabBarIndex].selectedIcon : TABINFO[this.tabBarIndex].defaultIcon)
              .interpolation(ImageInterpolation.High)
              .size(this.selectedIndex === this.tabBarIndex ? { width: 43, height: 43 } : { width: 28, height: 28 })
              .offset({
                y: (this.selectedIndex === this.tabBarIndex && this.selectedIndex !== COMMUNITY_TAB_BAR_INDEX) ?
                this.iconOffset : 0
              })
              .animation({
                duration: 1000,
                curve: Curve.Ease,
                iterations: 1,
                playMode: PlayMode.Normal
              })
          }
        }

        Text(TABINFO[this.tabBarIndex].title)
          .fontSize(14)
          .fontColor(this.selectedIndex === this.tabBarIndex ? "#E6304F" : Color.Black)
      }
      .width(60)
      .onClick(() => {
        this.selectedIndex = this.tabBarIndex
        this.iconOffset = -60
      })
    }
  }
}
