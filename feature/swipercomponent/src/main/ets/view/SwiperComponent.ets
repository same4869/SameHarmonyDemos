/**
 * @Author: xwang
 * @Date: 2024/7/9 14:00
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import { MToast } from '@same/common';
import { SwiperData } from '../model/SwiperData';

/**
 * 主页轮播图组件
 * 通过stack组件堆叠图片，实现多层级效果，配合手势滑动和显式动画实现切换的动画效果。同时通过改变数据中间值currentIndex来改变组件zIndex层级和高度来实现切换的效果。该场景多用于购物、资讯类应用。
 */
@AppRouter({ name: "swipercomponent/SwiperComponent" })
@Component
export struct SwiperComponent {
  @State swiperInterval: number = 0
  private automaticSwitchTime: number = 5000;
  @State swiperData: SwiperData[] = [
    new SwiperData($r("app.media.swipercomponent_mp_chart"), 'MpChart图表实现案例', "barchart/BarChartPage"),
    new SwiperData($r("app.media.swipercomponent_lottie"), 'Lottie动画', "lottieview/LottieView"),
    new SwiperData($r("app.media.swipercomponent_component_tack"), '组件堆叠', "componentstack/ComponentStack"),
  ];
  @State currentIndex: number = 0;
  private halfCount: number = Math.floor(3 / 2);
  private manualSlidingDuration: number = 800;
  private automaticSlidingDuration: number = 300;

  /**
   * 获取图片系数
   * @param index：索引值
   * @returns
   */
  getImgCoefficients(index: number): number {
    const coefficient: number = this.currentIndex - index; // 计算图片左右位置
    const tempCoefficient: number = Math.abs(coefficient);
    if (tempCoefficient <= this.halfCount) {
      return coefficient;
    }
    const dataLength: number = this.swiperData.length;
    let tempOffset: number = dataLength - tempCoefficient; // 判断图片位于左右层级位置
    if (tempOffset <= this.halfCount) {
      if (coefficient > 0) {
        return -tempOffset;
      }
      return tempOffset;
    }
    return 0;
  }

  /**
   * 计算偏移量
   * @param index：索引值
   * @returns
   */
  getOffSetX(index: number): number {
    const offsetIndex: number = this.getImgCoefficients(index);
    const tempOffset: number = Math.abs(offsetIndex);
    let offsetX: number = 0;
    if (tempOffset === 1) {
      // 根据图片层级系数来决定左右偏移量
      offsetX = -35 * offsetIndex;
    }
    return offsetX;
  }

  // 性能：显式动画(https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V2/ts-explicit-animation-0000001478341181-V2)
  startAnimation(isLeft: boolean, duration: number): void {
    animateTo({
      duration: duration,
    }, () => {
      const dataLength: number = this.swiperData.length;
      const tempIndex: number = isLeft ? this.currentIndex + 1 : this.currentIndex - 1 + dataLength;
      this.currentIndex = tempIndex % dataLength;
    })
  }

  build() {
    Column() {
      Stack() {
        // LazyForEach必须在容器组件内使用，仅有List、Grid、Swiper以及WaterFlow组件支持数据懒加载，其他组件仍然是一次性加载所有的数据。
        ForEach(this.swiperData, (item: SwiperData, index: number) => {
          Stack({ alignContent: Alignment.BottomStart }) {
            Image(item.imageSrc)
              .objectFit(ImageFit.Cover)
              .width('100%')
              .height('100%')
              .borderRadius(8)

            // 轮播图底部蒙层
            Stack() {
              Column() {
              }
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Black)
              .opacity(0.3)
              .borderRadius({
                topLeft: 0,
                topRight: 0,
                bottomLeft: 8,
                bottomRight: 8
              })

              Text(item.name)
                .width('100%')
                .height('100%')
                .fontSize(16)
                .fontColor(Color.White)
                .textAlign(TextAlign.Start)
                .padding(8)
            }
            .height(36)
          }
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .offset({
            x: this.getOffSetX(index),
            y: 0
          })
          .blur(index !== this.currentIndex ? 12 : 0)
          // TODO: 知识点:通过animateTo实现动画并且同时改变currentIndex数据中间值来判断组件zIndex实现切换动画
          .zIndex(index !== this.currentIndex && this.getImgCoefficients(index) === 0 ? 0 :
            2 - Math.abs(this.getImgCoefficients(index)))
          .width(310)
          .height(index !== this.currentIndex ? 130 : 180)
          .onClick(() => {
            MToast.showToast(`${item.appUri} ${item.param}`)
          })
        })
      }
      .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
        clearInterval(this.swiperInterval)
        if (isVisible && currentRatio >= 1.0) {
          this.swiperInterval = setInterval(() => {
            this.startAnimation(true, this.manualSlidingDuration);
          }, this.automaticSwitchTime)
        }

        if (!isVisible && currentRatio <= 0.0) {
          clearInterval(this.swiperInterval);
        }
      })
      .height(200)
      .width('100%')
      .gesture(
        PanGesture({ direction: PanDirection.Horizontal })
          .onActionStart((event: GestureEvent) => {
            clearInterval(this.swiperInterval);
            this.startAnimation(event.offsetX < 0, this.automaticSlidingDuration);
          })
          .onActionEnd(() => {
            this.swiperInterval = setInterval(() => {
              this.startAnimation(true, this.manualSlidingDuration);
            }, this.automaticSwitchTime);
          })
      )
      .alignContent(Alignment.Center)
      .padding({
        left: 12,
        right: 12,
        top: 12
      })

      Row({ space: 10 }) {
        ForEach(this.swiperData, (item: SwiperData, index: number) => {
          Ellipse(index !== this.currentIndex ? { width: 8, height: 8 } : { width: 10, height: 8 })
            .fill(index !== this.currentIndex ? Color.Black : Color.Red)
            .fillOpacity(0.6)
        })
      }
      .margin({ top: 12 })
    }
    .width("100%")
  }
}