import { FunctionDescription } from '@same/common/Index'
import Constants from '../model/Constants'

@Preview
@Component
export struct MarqueeView {
  build() {
    Column() {
      FunctionDescription({
        title: "跑马灯案例",
        content: "文本宽度过宽时，则实现跑马灯效果(文本循环滚动，每循环一次之后会停滞一段时间后再滚动)"
      })
    }
    .width("100%")
    .height("100%")
    .padding(12)
    .linearGradient({
      angle: Constants.ANGLE,
      colors: [["#ccdfff", 0], ["#f3f4f7", 1]]
    })
  }
}

@Component
struct TripMessage {
  build() {
  }
}