import { FunctionDescription, MLog } from '@same/common/Index'
import Constants from '../model/Constants'
import { TripDataSource } from '../model/DataSource'
import { TripDataType } from '../model/DataType'
import { TRIP_DATA } from '../model/MockData'
import { display } from '@kit.ArkUI'

@Preview
@Component
@Entry({ routeName: 'marquee/MarqueeView' })
export struct MarqueeView {
  build() {
    Column() {
      FunctionDescription({
        title: "跑马灯案例",
        content: "文本宽度过宽时，则实现跑马灯效果(文本循环滚动，每循环一次之后会停滞一段时间后再滚动)"
      })

      // 行程信息组件
      TripView()
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
struct TripView {
  @State tripData: TripDataSource = new TripDataSource()

  aboutToAppear(): void {
    this.tripData.pushData(TRIP_DATA)
  }

  build() {
    Column() {
      Text("我的行程")
        .width("100%")
        .fontSize(20)
        .margin({ top: 16 })

      LazyForEach(this.tripData, (item: TripDataType) => {
        TripMessage({
          tripDataItem: item
        })
      }, (item: TripDataType) => JSON.stringify(item))
    }
  }
}

@Component
struct TripMessage {
  //动画延迟时间
  @State delay: number = 0
  //初始化文本偏移量
  @State ticketCheckTextOffset: number = 0
  //初始化文本组件所占的宽度
  @State ticketCheckTextWidth: number = 0
  // 初始化Scroll组件所占的宽度
  @State ticketCheckScrollWidth: number = 0;
  // 行程信息数据
  private tripDataItem: TripDataType = {} as TripDataType;

  // 通用样式函数
  @Styles
  commonStyles(){
    .width('100%')
    .margin({ top: 8 })
  }

  // 文本滚动函数
  scrollAnimation() {
    // 文本宽度小于Scroll组件宽度，不执行滚动操作
    if (this.ticketCheckTextWidth < this.ticketCheckScrollWidth) {
      return;
    }
    /**
     * 文本向左偏移动画
     *
     * @param duration:动画总时长
     * @param curve:动画曲线
     * @param delay:延迟时间
     * @param onFinish:完成回调函数
     * 性能：播放动画时，系统需要在一个刷新周期内完成动画变化曲线的计算，完成组件布局绘制等操作。建议使用系统提供的动画接口，
     * 只需设置曲线类型、终点位置、时长等信息，就能够满足常用的动画功能，减少UI主线程的负载。
     * 参考资料：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-attribute-animation-apis-0000001820879805
     */
    animateTo({
      duration: Constants.ANIMATION_DURATION,
      curve: Curve.Linear,
      delay: this.delay,
      onFinish: () => {
        // TODO：知识点：动画完成时，添加定时器，1s之后重新执行动画函数，达到停滞操作。
        setTimeout(() => {
          // 初始化文本偏移量
          this.ticketCheckTextOffset = 0;
          // 执行动画函数
          this.scrollAnimation();
        }, Constants.DELAY_TIME)
      }
    }, () => {
      // 文本偏离量
      this.ticketCheckTextOffset = -(this.ticketCheckTextWidth + Constants.BLANK_SPACE)
    })
  }

  build() {
    Column() {
      Row() {
        Text(this.tripDataItem.trainNumber)
        Text(this.tripDataItem.wholeCourse)
      }.width("100%")
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(this.tripDataItem.startingTime)
          .fontSize($r('sys.float.ohos_id_text_size_headline6'))
          .width(100)
          .textAlign(TextAlign.Start)

        Text("计划出发")
          .fontColor("0A59F7")
          .width(80)
          .height(24)
          .textAlign(TextAlign.Center)
          .border({
            width: 1,
            radius: 12,
            color: "#0A59F7"
          })

        Text(this.tripDataItem.endingTime)
          .fontSize($r('sys.float.ohos_id_text_size_headline6'))
          .width(100)
          .textAlign(TextAlign.End)
      }.commonStyles()
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(this.tripDataItem.origin)
        Text(this.tripDataItem.timeDifference)
        Text(this.tripDataItem.destination)
      }
      .commonStyles()
      .justifyContent(FlexAlign.SpaceBetween)

      RelativeContainer() {
        Text("检票口:")
          .padding({
            right: 4
          })
          .id('ticketEntrance')
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })

        // TODO：知识点：使用Scroll组件和文本内容组件结合来判断文本宽度过宽时执行文本滚动，否则不执行
        Scroll() {
          Row() {
            Text(this.tripDataItem.ticketEntrance)
              .onAreaChange((oldValue, newValue) => {
                MLog.info(`TextArea oldValue:${JSON.stringify(oldValue)},newValue:${JSON.stringify(newValue)}`);
                // 获取当前文本内容宽度
                this.ticketCheckTextWidth = Number(newValue.width);
              })
            // TODO：知识点：文本宽度大于Scroll组件宽度时显示。在偏移过程中可实现文本接替并显示在同一显示区的效果
            if (this.ticketCheckTextWidth >= this.ticketCheckScrollWidth) {
              Blank()
                .width(Constants.BLANK_SPACE)
              Text(this.tripDataItem.ticketEntrance)
            }
          }.offset({ x: this.ticketCheckTextOffset })
        }
        .width(display.isFoldable() ? "30%" : "25%")
        .id('marquee')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: 'ticketEntrance', align: HorizontalAlign.End }
        })
        .align(Alignment.Start)
        .enableScrollInteraction(false)
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .onAreaChange((oldValue, newValue) => {
          MLog.info(`scrollArea oldValue:${JSON.stringify(oldValue)},newValue:${JSON.stringify(newValue)}`);
          // 获取当前Scroll组件宽度
          this.ticketCheckScrollWidth = Number(newValue.width);
        })

        Row() {
          Text("车型:")
          Text(this.tripDataItem.vehicleModel)
        }
        .id('vehicleModel')
        .justifyContent(FlexAlign.End)
        .backgroundColor(Color.White)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
      }
    }
    .width("100%")
    .height(160)
    .padding(12)
    .borderRadius(12)
    .margin({ top: 16 })
    .backgroundColor(Color.White)
    .onAppear(() => {
      // 执行动画函数
      this.scrollAnimation();
    })
  }
}