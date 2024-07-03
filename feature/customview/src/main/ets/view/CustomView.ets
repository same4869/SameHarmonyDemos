/**
 * @Author: xwang
 * @Date: 2024/7/3 14:51
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';

/**
 * 实现步骤：
 * 1. 页签实现：添加onClick方法，记录点击的index，index变化后，改变页签颜色、字体大小，使用animateTo方法实现页签切换动画
 * 2. 内容区实现：使用List，添加滑动手势来进行页面的切换，手势响应后，使用scrollToIndex方法来实现平滑的滑动到相应index
 */
@AppRouter({ name: "customview/CustomView" })
@Component
export struct CustomView {
  // 当前选中的页签index
  @State currentIndex: number = 0;
  // 颜色条的偏移量
  @State transitionX: number = 0;
  // 即将前往的页签index
  @State wantGoIndex: number = 0;
  // 创建Scroller对象
  scroller: Scroller = new Scroller();
  // 页签显示数据
  private titleArray: Array<string> = ['候补预测', '在线换座', '余票挖掘', '个人中心'];

  build() {
    Column() {
      // 页签实现
      DiscoverTopView({
        currentIndex: this.currentIndex,
        transitionX: this.transitionX,
        wantGoIndex: this.wantGoIndex,
        scroller: this.scroller,
        titleArray: this.titleArray
      })

      // 内容区域实现
      DiscoverTabView({
        currentIndex: this.currentIndex,
        transitionX: this.transitionX,
        wantGoIndex: this.wantGoIndex,
        scroller: this.scroller,
        titleArray: this.titleArray
      })
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }
}

//顶部页签
@Component
struct DiscoverTopView {
  // 颜色条的偏移量
  @Link transitionX: number;
  // 页签显示数据
  titleArray: Array<string> = [];
  // title宽度计算基数
  private titleLengthRadix: number = 20;
  // 当前选中的页签index
  @Link currentIndex: number;
  // 即将前往的页签index
  @Link wantGoIndex: number;
  // duration计算基数
  private durationRadix: number = 200;
  // iterations默认值
  private iterationsDefault: number = 1;
  // 创建Scroller对象
  scroller: Scroller = new Scroller();
  // 循环因子初始值
  private loopDefault: number = 0;
  // 计算title长度的一半
  private titleLengthHalf: number = 2;
  // 颜色条长度的一半
  private colorBarHalf: number = 10;

  aboutToAppear(): void {
    this.transitionX = this.getTransitionX(this.currentIndex)
  }

  // 获取颜色条偏移量
  getTransitionX(index: number) {
    let theNumber: number = 0;
    for (let i = this.loopDefault; i <= index; i++) {
      const title = this.titleArray[i];
      const titleLength = title.length * this.titleLengthRadix;
      if (i === index) {
        theNumber += titleLength / this.titleLengthHalf - this.colorBarHalf;
      } else {
        theNumber += titleLength;
      }
    }
    return theNumber;
  }

  build() {
    Column() {
      Row() {
        ForEach(this.titleArray, (title: string, idx: number) => {
          Text(title)
            .textAlign(TextAlign.Center)
            .height(30)
            .width(this.titleLengthRadix * title.length)
            .fontColor(this.wantGoIndex === idx ? "#111111" : "#999999")
            .fontSize(this.currentIndex === idx ? 18 : 14)
            .fontWeight(this.currentIndex === idx ? FontWeight.Bold : FontWeight.Normal)
            .onClick(() => {
              // TODO 知识点：页签实现：记录点击index，index变化后，获取颜色条偏移量，刷新页签颜色、字体大小，实现效果
              if (this.currentIndex !== idx) {
                //记录点击的index
                this.wantGoIndex = idx
                //动画
                animateTo({
                  duration: Math.abs(idx - this.currentIndex) * this.durationRadix,
                  curve: Curve.EaseInOut,
                  iterations: this.iterationsDefault,
                  playMode: PlayMode.Normal,
                  onFinish: () => {
                    this.currentIndex = idx
                    // 高性能知识点：scrollToIndex方法，开启smooth动效时，会对经过的所有item进行加载和布局计算，当大量加载item时会导致性能问题
                    this.scroller.scrollToIndex(this.currentIndex, true, ScrollAlign.START)
                  }
                }, () => {
                  // 获取颜色条偏移量
                  this.transitionX = this.getTransitionX(idx);
                })
              }
            })
        })
      }
      .height(30)
      .width("100%")

      Row()
        .width(20)
        .height(6)
        .borderRadius(3)
        .backgroundColor("#3366ff")
        .position({ x: this.transitionX, y: 30 })
    }
    .height(40)
    .width(320)
  }
}

//内容区域
@Component
struct DiscoverTabView {
  // 当前选中的页签index
  @Link currentIndex: number;
  // 颜色条的偏移量
  @Link transitionX: number;
  // 即将前往的页签index
  @Link wantGoIndex: number;
  // 创建Scroller对象
  scroller: Scroller = new Scroller();
  // 创建PanGestureOptions对象
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right });
  // 是否开始动画标志
  isStartAction: boolean = false;
  // 判断条件值
  private judgmentValue: number = 0;
  // 页签显示数据
  titleArray: Array<string> = [];
  // 计算title长度的一半
  private titleLengthHalf: number = 2;
  // 颜色条长度的一半
  private colorBarHalf: number = 10;
  // title宽度计算基数
  private titleLengthRadix: number = 20;
  // 循环因子初始值
  private loopDefault: number = 0;
  // duration计算基数
  private durationRadix: number = 200;
  // iterations默认值
  private iterationsDefault: number = 1;
  // currentIndex计算基数
  private currentIndexRadix: number = 1;

  // 获取偏移量
  getTransitionX(index: number) {
    let theNumber: number = 0;
    for (let i = this.loopDefault; i <= index; i++) {
      const title = this.titleArray[i];
      const titleLength = title.length * this.titleLengthRadix;
      if (i === index) {
        theNumber += titleLength / this.titleLengthHalf - this.colorBarHalf;
      } else {
        theNumber += titleLength;
      }
    }
    return theNumber;
  }

  // 实现动画效果
  achieveEffect(temIndex: number) {
    // 高性能知识点：scrollToIndex方法，开启smooth动效时，会对经过的所有item进行加载和布局计算，当大量加载item时会导致性能问题
    this.scroller.scrollToIndex(temIndex, true, ScrollAlign.START);
    this.wantGoIndex = temIndex;
    // 动画效果
    animateTo({
      duration: Math.abs(temIndex - this.currentIndex) * this.durationRadix,
      curve: Curve.EaseInOut,
      iterations: this.iterationsDefault,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.currentIndex = temIndex;
      }
    }, () => {
      this.transitionX = this.getTransitionX(temIndex);
    })
  }

  build() {
    List({ scroller: this.scroller }) {
      // 内容区域部分
      // TODO 高性能知识点：此处为了演示场景，列表数量只有4个，使用ForEach，列表数量较多的场景，推荐使用LazyForEach+组件复用+缓存列表项实现
      ForEach(this.titleArray, (item: string) => {
        ListItem() {
          Text(item)
            .width("100%")
            .height(50)
            .fontSize(25)
            .textAlign(TextAlign.Center)
        }
      })
    }
    .scrollBar(BarState.Off)
    .listDirection(Axis.Horizontal)
    .priorityGesture(
      PanGesture(this.panOption)// TODO 知识点：内容区域实现：添加滑动手势，手势响应后，使用scrollToIndex方法来实现效果
        .onActionUpdate((event: GestureEvent) => {
          if (!this.isStartAction) {
            this.isStartAction = true
            if (event.offsetX < this.judgmentValue) {
              if (this.currentIndex < this.titleArray.length - this.currentIndexRadix) {
                const temIndex: number = this.currentIndex + this.currentIndexRadix
                this.achieveEffect(temIndex);
              }
            } else {
              if (this.currentIndex > this.judgmentValue) {
                const temIndex: number = this.currentIndex - this.currentIndexRadix;
                this.achieveEffect(temIndex);
              }
            }
          }
        })
        .onActionEnd(() => {
          this.isStartAction = false;
        })
    )
    .backgroundColor("#eeeeee")
    .width("100%")
    .height(50)
  }
}
