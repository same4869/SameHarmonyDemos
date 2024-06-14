import { MLog, MToast } from '@same/common/Index';
import { Constants } from '../config/Constants'
import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@ohos.base';

@Preview
@Component
@Entry({ routeName: 'vibrateeffect/VibrateEffectView' })
export struct VibrateEffectView {
  @State translateX: number = 0; // 初始化提示文本的偏移量
  @State confirm: boolean = false; // 是否勾选协议
  uiContext: UIContext | undefined = undefined; // UIContext实例对象

  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
  }

  // 触发手机振动效果
  startVibrate() {
    try {
      // TODO: 知识点：vibrator.startVibration 根据指定振动效果和振动属性触发马达振动
      vibrator.startVibration({
        type: 'time',
        // 持续触发马达振动时间600ms
        duration: Constants.VIBRATION_TIME,
      }, {
        id: 0,
        usage: 'alarm',
      }, (error: BusinessError) => {
        if (error) {
          MLog.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
          return;
        }
      });
    } catch (err) {
      MLog.error(`An unexpected error occurred. Code: ${err.code}, message: ${err.message}`);
    }
  }

  // 触发提示文本抖动动画效果
  startAnimation() {
    if(!this.uiContext){
      return
    }
    this.translateX = Constants.POSITION_ZERO
    // TODO: 知识点：通过keyframeAnimateTo关键帧动画指定状态变化过渡动效
    this.uiContext.keyframeAnimateTo({
      iterations:Constants.PLAYBACK_COUNT
    },[
      {
        // 第一段动画时长为100ms，translateX属性从0到5
        duration: Constants.ANIMATION_TIME,
        event: () => {
          this.translateX = Constants.TRANSLATE_OFFSET_X;
        }
      },
      {
        // 第二段动画时长为100ms，translateX属性从5到0
        duration: Constants.ANIMATION_TIME,
        event: () => {
          this.translateX = Constants.POSITION_ZERO;
        }
      }
    ])
  }

  build() {
    Column() {
      Row()
        .width("100%")
        .height(100)

      Scroll() {
        Column({ space: Constants.MARGIN_VERTICAL }) {
          Image($r("app.media.vibrateeffect_speed_train"))
            .width(80)
            .height(80)
            .backgroundColor("#0a59f7")
            .borderRadius(12)

          Text("188******88")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)

          Column() {
            Row() {
              Image(this.confirm ? $r("app.media.vibrateeffect_ic_ok") : $r("app.media.vibrateeffect_ic_default"))
                .height(15)
                .width(15)
                .margin({ right: 5 })
                .onClick(() => {
                  this.confirm = !this.confirm
                })

              Text() {
                Span("我已阅读并同意")
                  .fontColor("#99000000")
                  .fontSize(12)
                Span("「**账号服务与隐私政策」")
                  .fontColor("#0a59f7")
                  .fontSize(12)
                  .onClick(() => {
                    MToast.showToast("仅演示1")
                  })
                Span("和")
                  .fontColor("#99000000")
                  .fontSize(12)
                Span("「服务协议」")
                  .fontColor("#0a59f7")
                  .fontSize(12)
                  .onClick(() => {
                    MToast.showToast("仅演示2")
                  })
                Span("「隐私政策」")
                  .fontColor("#0a59f7")
                  .fontSize(12)
                  .onClick(() => {
                    MToast.showToast("仅演示3")
                  })
              }
              .flexShrink(Constants.FLEX_SHRINK)
            }
            .width("100%")
            .alignItems(VerticalAlign.Top)

            // 若没有勾选协议，则会出现提示文本：“请阅读并勾选协议”
            Stack() {
              if (!this.confirm) {
                Column() {
                  Image($r("app.media.vibrateeffect_login_popup"))
                    .width(10)
                    .height(10)
                    .position({
                      x: Constants.POPUP_POSITION_X,
                      y: Constants.POPUP_POSITION_Y
                    })

                  Text("请阅读并勾选协议")
                    .fontColor("#ffffff")
                    .fontSize(10)
                    .textAlign(TextAlign.Center)
                    .backgroundColor("#000000")
                    .width(100)
                    .height(20)
                    .position({
                      x: Constants.MARK_POSITION_X,
                      y: Constants.MARK_POSITION_Y
                    })
                    .borderRadius(4)
                    .opacity(Constants.OPACITY_VALUE)
                }
                .width(100)
                .height(30)
                .position({
                  x: this.translateX,
                  y: Constants.POSITION_ZERO
                })
              }
            }
            .alignContent(Alignment.Start)
            .height(30)
            .width("100%")
          }

          Button("本机号码一键登录")
            .type(ButtonType.Normal)
            .borderRadius(12)
            .fontColor("#ffffff")
            .fontSize(14)
            .width("100%")
            .onClick(() => {
              // 点击登录按钮，若没有勾选协议则触发手机振动效果和抖动动画
              if (!this.confirm) {
                this.startVibrate();
                this.startAnimation();
              } else {
                MToast.showToast("登录成功")
              }
            })
        }.width("100%")
      }
      .scrollBar(BarState.Off)
    }
    .width("100%")
    .height("100%")
    .padding(12)
  }
}