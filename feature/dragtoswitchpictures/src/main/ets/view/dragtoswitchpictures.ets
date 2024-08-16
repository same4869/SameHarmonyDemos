import { AppRouter } from '@ohos/dynamicsRouter';
import { DesignCattleView } from './DesignCattleView';

@AppRouter({
  name: "dragtoswitchpictures/dragtoswitchpictures"
})
@Component
export struct dragtoswitchpictures {
  build() {
    Scroll() {
      Column() {
        DesignCattleView()
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor("#fcd7d5d5")
    }
    .width("100%")
    .height("100%")
    .scrollBar(BarState.Off)
    .scrollable(ScrollDirection.Vertical)
    .zIndex(1)
  }
}