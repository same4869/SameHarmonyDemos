/**
 * @Author: xwang
 * @Date: 2024/7/8 13:18
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import { MToast } from '@same/common/src/main/ets/utils/MToast';
import { dataPageFour, dataPageOne, dataPageThree, dataPageTwo, GridItemInfo } from '../model/DataModel';

/**
 * 页面高度随着swiper高度平滑变化
 * 滑动swiper，页面高度随着swiper高度平滑变化
 * 效果：当不同swiper页面的高度发生变化时，下方页面的高度也会随着一起平滑的变化
 */
@AppRouter({ name: "swipersmoothvariation/SwiperSmoothVariation" })
@Component
export struct SwiperSmoothVariation {
  // scroller控制器初始化
  private gridScroller: Scroller = new Scroller();
  // 下方页面对应swiper上下位置的变化
  @State swiperDistance: number = 0;

  @Builder
  GridBuilderFunc(page: GridItemInfo[], height: number, template: string) {
    Column() {
      Grid(this.gridScroller) {
        ForEach(page, (item: GridItemInfo) => {
          GridItem() {
            ViewItem({ item: item })
              .onClick(() => {
                MToast.showToast("没有实现")
              })
          }
          .width("100%")
          .height(height)
          .width(340)
        })
      }
      .height(height)
      .width("100%")
      .borderRadius(12)
      .edgeEffect(EdgeEffect.None)
      .columnsTemplate("1fr 1fr 1fr 1fr 1fr")
      .rowsTemplate(template)
    }
    .margin(page === dataPageOne ? { top: 23 } : 0)
  }

  build() {
    Stack() {
      Swiper() {
        Column() {
          Stack() {
            Text("功能栏") {
            }
            .textAlign(TextAlign.Center)
            .margin({ top: 5, left: 12 })

            this.GridBuilderFunc(dataPageOne, 130, "1fr 1fr")
          }
          .alignContent(Alignment.TopStart)
        }

        // swiper第二个page
        this.GridBuilderFunc(dataPageTwo, 130, "1fr 1fr")
        // swiper第三个page
        this.GridBuilderFunc(dataPageThree, 130, "1fr 1fr")
        // swiper第四个page
        this.GridBuilderFunc(dataPageFour, 65, "1fr")
      }
      .width("100%")
      .backgroundColor("#ffffff")
      .borderRadius(12)
      .margin({ top: 15 })
      .effectMode(EdgeEffect.None)
      .loop(false)

      // TODO: 知识点: Swiper组件绑定onGestureSwipe事件，在页面跟手滑动过程中，逐帧触发该回调
      // 性能知识点: onGestureSwipe属于频繁回调，不建议在onGestureSwipe做耗时和冗余操作
      .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
        animateTo({
          duration: 0,
          curve: Curve.EaseOut,
          playMode: PlayMode.Normal,
          onFinish: () => {

          }
        }, () => { // 通过左右滑动的距离来计算对应的上下位置的变化
          if (index === 0 && extraInfo.currentOffset < 0) {
            this.swiperDistance = extraInfo.currentOffset / 340 * 13
          } else if (index === 1 && extraInfo.currentOffset > 0) {
            this.swiperDistance = extraInfo.currentOffset / 340 * 13 - 13
          } else if (index === 2 && extraInfo.currentOffset < 0) {
            this.swiperDistance = extraInfo.currentOffset / 340 * 65 - 13
          } else if (index === 3 && extraInfo.currentOffset > 0) {
            this.swiperDistance = extraInfo.currentOffset / 340 * 65 - 13 - 65
          }
        })
      })

      // 平滑变化的动画效果
      .onAnimationStart((_: number, targetIndex: number) => {
        animateTo({
          duration: 400,
          curve: Curve.EaseOut,
          playMode: PlayMode.Normal,
          onFinish: () => {
          }
        }, () => {
          if (targetIndex === 0) {
            this.swiperDistance = 0;
          } else if (targetIndex === 1 || targetIndex === 2) {
            this.swiperDistance = -13
          } else {
            this.swiperDistance = -13 - 65
          }
        })
      })

      .indicator(new DotIndicator()
        .selectedItemWidth(18)
        .selectedItemHeight(3)
        .itemWidth(5)
        .itemHeight(-3)
        .selectedColor("#ffec6553")
        .color("f88662")
      )

      // swiper下方的页面
      Image($r("app.media.swipersmoothvariation_test"))
        .height(100)
        .borderRadius(12)
        .width($r('app.string.swipersmoothvariation_width_full'))
        .offset({ y: this.swiperDistance })
        .margin({ top: 200 })
    }
    .backgroundColor("#fff5f5f3")
    .padding(12)
    .alignContent(Alignment.TopStart)
  }
}

@Component
struct ViewItem {
  @Prop item: GridItemInfo

  build() {
    Column() {
      Stack() {
        Image(this.item.image)
          .height(30)
          .height(30)

        Text(this.item.prompt)
          .fontColor("#ffffff")
          .fontSize(10)
          .backgroundColor("#eefd5217")
          .borderRadius({
            topLeft: 5,
            topRight: 5,
            bottomRight: 5
          })
          .textAlign(TextAlign.Center)
          .width(35)
          .height(18)
          .margin({ top: -20, left: 30 })// TODO: 知识点: Text绑定visibility属性方法，进而控制组件的显隐状态，避免组件的频繁创建与销毁，提升性能。
            // 性能知识点: Text绑定visibility属性方法，避免组件的频繁创建与销毁，提升性能。
          .visibility(this.item.prompt !== undefined ? Visibility.Visible : Visibility.None)
      }
      .width("100%")

      Text(this.item.name)
        .margin({ top: 8 })
        .fontSize(13)
    }
  }
}