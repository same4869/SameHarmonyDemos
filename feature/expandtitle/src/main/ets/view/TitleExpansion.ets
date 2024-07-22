/**
 * @Author: xwang
 * @Date: 2024/7/18 15:20
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter'
import { MToast } from '@same/common';
import { MemoDataSource, MemoInfo } from '../model/DataSource';
import { MEMO_DATA } from '../model/MockData';
import MemoItem from './MemoItem';


/**
 * 本示例以备忘录应用为示例，介绍如何在实现标题展开时继续下拉的动效。
 * 通过状态变量isExpanded控制标题是否展开，通过状态变量heightValue控制内容高度变化；
 * 而状态变量的更新在onTouch时间的响应函数handleTouchEvent中处理，根据手指滑动类型TouchType分情况处理；
 * 当响应状态变量更新的动画，通过为标题和菜单绑定属性动画animation实现。
 */
@AppRouter({ name: "expandtitle/TitleExpansion" })
@Component
export struct TitleExpansion {
  @State heightValue: ResourceStr = "88%"; // 笔记列表布局高度
  @State duration: number = 500 // 动画持续时间
  @State memoData: MemoDataSource = new MemoDataSource(); // 懒加载模拟数据源
  @State @Watch("isContinuePullDown") isExpanded: boolean = false; // 标题是否展开 列表是否完成第一次下滑
  @State @Watch("isContinuePullDown") isMoving: boolean = false; // 笔记列表是否在被拖动
  @State @Watch("isContinuePullDown") offsetY: number = 0; // 列表y坐标偏移量
  @State @Watch("isContinuePullDown") atStart: boolean = true; // 笔记列表内容是否在顶部
  private downY: number = 0; // 按下时的y坐标
  private lastMoveY: number = 0 // 上一次移动结束时的坐标
  private throttleStatus: boolean = true; // 节流器状态

  aboutToAppear(): void {
    this.memoData.pushData(MEMO_DATA)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Row() {
          //展开前的标题
          Text(!this.isExpanded ? "All notes" : "")
            .fontSize(25)
          Blank()
          Image($r("app.media.expanded_title_is_public_add"))
            .width(25)
            .height(25)
            .onClick(() => {
              MToast.showToast("++++")
            })

          Image($r("app.media.expanded_title_ic_public_more"))
            .width(25)
            .height(25)
            .margin({ left: 8 })
            .onClick(() => {
              MToast.showToast("more")
            })
        }
        .width("100%")
        .padding(25)
        .margin({ top: 10 })
        .alignItems(VerticalAlign.Center)
        .translate(this.getTitleTranslateOptions())
        .animation({ duration: this.duration, curve: Curve.FastOutLinearIn })

        // 展开后的标题
        Column() {
          Text("All notes2")
            .fontSize(30)
          Text(" 8 notes")
            .fontSize(16)
            .fontColor(Color.Grey)
        }
        .width("100%")
        .padding({ left: 25 })
        .margin({ top: 10 })
        .alignItems(HorizontalAlign.Start)
        .translate(this.getTitleTranslateOptions()) // TODO：知识点：配置标题平移参数
        .scale(this.getTitleScaleOptions()) // TODO：知识点：配置标题缩放参数
        .animation({ duration: this.duration, curve: Curve.FastOutLinearIn })
        .transition({ type: TransitionType.Insert, translate: { y: -50 } })
        .visibility(this.isExpanded ? Visibility.Visible :
        Visibility.Hidden) // TODO: 性能知识点：相对频繁的显隐切换，可以使用显隐控制替换条件渲染，减少组件的反复销毁创建成本。
      }
      .height("100%")
      .width("100%")

      Column() {
        List({ space: 12 }) {
          ListItem() {
            Search({ placeholder: "Type to search..." })
              .width("100%")
              .height("8%")
              .backgroundColor(Color.White)
          }

          LazyForEach(this.memoData, (item: MemoInfo, index: number) => {
            ListItem() {
              MemoItem({ memoItem: item })
            }
            .onClick(() => {
              MToast.showToast("仅演示")
            })
          }, (item: MemoInfo) => JSON.stringify(item))
        }
        .scrollBar(BarState.Off)
        .margin({ left: 10, right: 10 })
        .width("90%")
        .height("100%")
        .onReachStart(() => { // TODO：知识点：通过onReachStart回调，更新列表是否位于顶部的状态更新，以控制仅在顶部时才触发标题下移放大动效
          this.atStart = true;
        })
      }
      .width("100%")
      .height(this.heightValue)
      .animation({ duration: this.duration, curve: Curve.FastOutLinearIn })
      .onTouch((event: TouchEvent) => this.handleTouchEvent(event))
    }
    .backgroundColor("#eaf0ef")
  }

  /**
   * onTouch事件响应函数，根据手指滑动类型TouchType分为三种情况处理：
   * 1. TouchType.Down，即手指下按时：记录按下时的坐标downY，并更新状态变量isMoving为开始滑动、duration为初始动画时长
   * 2. TouchType.Move，即手指滑动时：根据滑动方向的不同，更新滑动距离offsetY、内容高度heightValue、标题是否展开等状态变量
   * 3. TouchType.Up、TouchType.Cancel，即滑动结束时：更新状态变量isMoving为停止滑动、duration为回弹动画时长
   */
  handleTouchEvent(event: TouchEvent): void {
    switch (event.type) {
    // 手指下按时
      case TouchType.Down:
        this.downY = event.touches[0].y;
        this.lastMoveY = event.touches[0].y;
        this.isMoving = true;
        this.duration = 500 // 重置动画持续时间
        break;

    // 手指滑动时
      case TouchType.Move:
        const delta = event.touches[0].y - this.lastMoveY;
        this.offsetY = event.touches[0].y - this.downY;
        if (delta < 0) { // TODO：知识点：手势为上滑时
          this.heightValue = "88%"
          this.isExpanded = false;
          this.atStart = false;
        }
        if (delta > 0 && this.atStart) { // TODO：知识点：手势为下滑，且列表内容位于顶部时
          // 性能知识点：手指滑动的时，直接使用animateTo，会创建大量的animateTo对象，可以通过节流器优化性能
          this.animateToThrottle(() => {
            this.heightValue = "75%"
            this.isExpanded = true;
          }, 1000);
        }
        this.lastMoveY = event.touches[0].y;
        break;

    // 滑动结束时
      case TouchType.Up:
      case TouchType.Cancel:
        this.isMoving = false;
        this.duration = 300 // 控制回弹动画时间
        break;
    }
  }

  isContinuePullDown() {
    return this.isMoving && this.isExpanded && this.offsetY >= 180
  }

  /**
   * 获取标题展开时，标题缩放的Scale参数
   */
  getTitleScaleOptions(): ScaleOptions {
    return this.isContinuePullDown() ? {
      x: 1.1,
      y: 1.1,
      centerX: 0,
      centerY: 0
    } : {
      x: 1,
      y: 1,
      centerX: 0,
      centerY: 0
    };
  }

  /**
   * 获取标题展开时，图标继续下拉的Translate参数
   */
  getMenuTranslateOptions(): TranslateOptions {
    return this.isContinuePullDown() ? {
      y: Math.min(this.offsetY - 180, 20)
    } : { y: 0 };
  }

  /**
   * 获取标题展开时，标题继续下拉的Translate参数
   */
  getTitleTranslateOptions(): TranslateOptions {
    return this.isContinuePullDown() ? {
      y: Math.min(this.offsetY - 180, 30)
    } : { y: 0 };
  }

  /**
   * 节流器：如果短时间内多次触发了同一事件，那么在函数执行一次后，在一个限期内不再执行
   */
  animateToThrottle(fn: Callback<void>, delay: number) {
    if (this.throttleStatus) {
      // TODO: 性能知识点：播放动画时，系统需要在一个刷新周期内完成动画变化曲线的计算，完成组件布局绘制等操作。建议使用系统提供的动画接口，
      // 只需设置曲线类型、终点位置、时长等信息，就能够满足常用的动画功能，减少UI主线程的负载。参考资料：
      // https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-attribute-animation-apis-0000001820879805
      animateTo({
        duration: this.duration, curve: Curve.FastOutLinearIn
      }, fn)
      this.throttleStatus = false;
      setTimeout(() => {
        this.throttleStatus = true;
      }, delay)
    }
  }
}