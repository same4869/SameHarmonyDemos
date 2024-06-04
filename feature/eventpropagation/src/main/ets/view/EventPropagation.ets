import { FunctionDescription } from "@same/common"

@Preview
@Entry({ routeName: 'eventpropagation/EventPropagation' })
@Component
export struct EventPropagation {
  // 初始化控制使能开关变量
  @Provide isEnabled: boolean = true;

  build() {
    Column() {
      FunctionDescription({
        title: "阻塞事件冒泡",
        content: "正常事件冒泡机制，父组件可接收子组件点击/触摸事件。打开阻塞事件冒泡，父组件无法接收子组件点击/触摸事件"
      })

      Row() {
        Text("阻塞事件冒泡")

        Toggle({ type: ToggleType.Switch, isOn: this.isEnabled })
          .selectedColor("#007DFF")
          .switchPointColor("#ffffff")
          .onChange((isOn: boolean) => {
            this.isEnabled = isOn
          })
      }
      .width("100%")
      .height(56)
      .margin({ top: 16 })
      .justifyContent(FlexAlign.SpaceBetween)

      ClickEvent()
      TouchEvent()
    }.padding(12)
  }
}

@Component
struct ClickEvent {
  // 初始化控制使能开关变量
  @Consume isEnabled: boolean
  // 父组件响应次数
  @State parentCompResponseTimes: number = 0;

  build() {
    Column() {
      Text("点击事件例子(子组件disable，不响应点击等操作)")
        .width("100%")
        .textAlign(TextAlign.Start)

      Column() {
        Text("父组件")
          .margin(8)

        Row() {
          Text("父组件响应次数")
          Text(`${this.parentCompResponseTimes}`)
        }.margin({
          top: 8,
          bottom: 8
        })

        Column() {
          Button("disable的子组件")
            .width(260)
            .height(30)
            .borderRadius(8)
            .enabled(false)
            .onClick(() => {

            })
        }
        /*
 TODO：知识点：在onClick事件里，需要将Button按钮包裹一层容器组件，在此容器组件通过使用hitTestBehavior来阻止事件冒泡(子组件向父组件透传onClick事件)，
  hitTestBehavior的属性值设置为HitTestMode.Block。
 */
        .hitTestBehavior(this.isEnabled ? HitTestMode.Block : HitTestMode.Default)
      }
      .size({ width: "100%", height: 200 })
      .backgroundColor("#f1f3f5")
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        // 冒泡事件发生时，该回调不会触发
        this.parentCompResponseTimes++;
      })
      .margin({ top: 8 })
      .borderRadius(12)
    }
    .margin({ top: 16 })
  }
}

@Component
struct TouchEvent {
  // 初始化控制使能开关变量
  @Consume isEnabled: boolean;
  // 父组件响应次数
  @State parentCompResponseTimes: number = 0;
  // 子组件响应次数
  @State childCompResponseTimes: number = 0;

  build() {
    Column() {
      Text("触摸事件例子")
        .width("100%")
        .textAlign(TextAlign.Start)

      Column() {
        Text("父组件")
          .margin(8)

        Row() {
          Text("父组件响应次数")
          Text(`${this.parentCompResponseTimes}`)
        }.margin({
          top: 8,
          bottom: 8
        })

        //子组件响应次数
        Row() {
          Text("子组件响应次数")
          Text(`${this.childCompResponseTimes}`)
        }.margin({ bottom: 8 })

        Text("子组件")
          .width(260)
          .height(30)
          .borderRadius(8)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .backgroundColor(Color.Brown)
          .onTouch((event) => {
            if (this.isEnabled) {
              // TODO：知识点：在onTouch事件里，通过调用event.stopPropagation()阻止事件冒泡(子组件向父组件透传Touch事件)
              event.stopPropagation();
            }
            this.childCompResponseTimes++
          })
      }
      .size({ width: "100%", height: 200 })
      .backgroundColor("#f1f3f5")
      .alignItems(HorizontalAlign.Center)
      .onTouch(() => {
        // 冒泡事件发生时，该回调不会触发
        this.parentCompResponseTimes++;
      })
      .margin({ top: 8 })
      .borderRadius(12)
    }
    .margin({ top: 16 })
  }
}