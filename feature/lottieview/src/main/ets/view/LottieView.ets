/**
 * @Author: xwang
 * @Date: 2024/7/15 13:50
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import Lottie from '@ohos/lottie';
import { FunctionDescription } from '@same/common';

const FRAME_START: number = 60; // 动画播放的起始帧
const FRAME_END: number = 120; // 动画播放的终止帧
const TEXT_DATA_LENGTH: number = 3; // 可变文本数据的长度

/**
 * 页面一进来，在onReady函数中执行lottie.loadAnimation来加载动画，默认不自动播放，
 * 点击加载的动画卡片，动画播放，并叠加点击的次数，最后根据(点击的次数%文本数据的数组长度)来更新响应动画的文本。
 */
@AppRouter({ name: "lottieview/LottieView" })
@Component
export struct LottieView {
  build() {
    Column() {
      FunctionDescription({
        title: "实现Lottie动画",
        content: "点击卡片，动画执行播放，并且动画文本刷新"
      })

      LottieAnimation()
    }
    .width("100%")
    .height("100%")
    .alignItems(HorizontalAlign.Center)
    .backgroundImage($r("app.media.lottie_view_bg"))
    // 扩展至所有非安全区域
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundImageSize(ImageSize.Cover)
    .padding(12)
  }
}

@Component
struct LottieAnimation {
  private politeChickyController: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(); // CanvasRenderingContext2D对象
  private textArray: Array<string> = ['戳我呀', '幸福鸡', '坏了呀']; // 文本数据，用来点击更新文本
  @State times: number = 0; // 初始化点击次数
  private animateItem: ESObject = null; // 初始化loadAnimation接口的返回对象
  private politeChicky: string = 'lottie2'; // 动画名称
  private politeChickyPath: string = 'common/lottie/lottie2.json'; // hap包内动画资源文件路径，仅支持json格式

  loadAnimation(autoplay: boolean) {
    if (this.animateItem !== null) {
      this.animateItem.destroy()
      this.animateItem = null
    }
    this.animateItem = Lottie.loadAnimation({
      container: this.politeChickyController,
      renderer: "canvas",
      loop: false,
      autoplay: autoplay,
      name: this.politeChicky,
      path: this.politeChickyPath,
      initialSegment: [0, 60]
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Canvas(this.politeChickyController)
        .width(150)
        .height(150)
        .backgroundColor("#46b1e3")
        .borderRadius(12)
        .onReady(() => {
          this.loadAnimation(false)
        })
        .onClick(() => {
          this.loadAnimation(true)
          this.times++
        })

      Text(this.textArray[this.times % TEXT_DATA_LENGTH])
        .fontSize(20)
        .margin(8)
        .fontColor(Color.White)
    }
    .margin({ top: 16 })
  }
}