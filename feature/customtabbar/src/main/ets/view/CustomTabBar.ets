import { TABINFO } from '../model/TabBarData'
import { TabBarDataType } from '../model/TabBarDataType'

@Component
struct CustomTabBar {
  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
      ForEach(TABINFO, (item: TabBarDataType, tabIndex: number) => {

      })
    }
  }
}

@Component
struct TabItem{
  build() {
  }
}