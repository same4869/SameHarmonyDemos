/**
 * @Author: xwang
 * @Date: 2024/7/26 15:31
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import { DigitalScrollDetail } from './DigitalScrollDetail';

@Component
@AppRouter({ name: "digitalscrollanimation/DigitalScrollExample" })
export struct DigitalScrollExample {
  private scroller: Scroller = new Scroller(); // Scroller对象
  @State data: number[] = [1, 2, 3, 4, 5, 6]; // 数据项
  @State isRefresh: boolean = false;

  build() {
    Column({ space: 12 }) {
      Refresh({ refreshing: $$this.isRefresh }) {
        this.scrollArea()
      }
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefresh = false
        }, 2000)
      })
    }
    .padding({ top: 32 })
    .width("100%")
    .height("100%")
    .linearGradient({
      colors: [["#b5d5fe", 0.0], [$r('sys.color.ohos_id_color_background'), 0.3]]
    })
  }

  @Builder
  scrollArea() {
    List({ space: 12, scroller: this.scroller }) {
      ListItem() {
        Text("下拉抢火车票")
          .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          .width("100%")
          .textAlign(TextAlign.Center)
      }

      ListItem() {
        Row({ space: 2 }) {
          Text("今日为")
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontWeight(FontWeight.Bold)

          DigitalScrollDetail({ isRefresh: this.isRefresh })

          Text("人提供抢票服务")
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontWeight(FontWeight.Bold)
        }
        .width("100%")
        .justifyContent(FlexAlign.Center)
      }
    }
    .scrollBar(BarState.Off)
    .height("100%")
  }
}