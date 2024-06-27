import display from '@ohos.display'
import { SceneModuleInfo } from './model/SceneModuleInfo';
import { router } from '@kit.ArkUI';
import { MLog } from '@same/common/Index';
import { DynamicsRouter } from '@ohos/dynamicsRouter/Index';

@Reusable
@Component
export struct MethodPoints {
  @State listData: SceneModuleInfo =
    new SceneModuleInfo($r("app.media.functional_scenes_address_exchange"), '地址交换动画',
      'addressexchange/AddressExchangeView', '动效')
  //当前折叠屏状态（仅限折叠屏）
  curFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN
  @State screenW: number = px2vp(display.getDefaultDisplaySync().width);
  @State isNeedClear: boolean = false;
  private deviceSize: number = 600; // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。

  aboutToAppear(): void {
    if (display.isFoldable()) {
      this.regDisplayListener();
    } else {
      if (this.screenW >= this.deviceSize) {
        this.isNeedClear = true;
      } else {
        this.isNeedClear = false;
      }
    }
  }

  /**
   * 组件的生命周期回调，在可复用组件从复用缓存中加入到组件树之前调用
   * @param params：组件更新时所需参数
   */
  aboutToReuse(params: Record<string, SceneModuleInfo>): void {
    this.listData = params.listData as SceneModuleInfo;
  }

  build() {
    Column() {
      Image(this.listData.imageSrc)
        .borderRadius({
          topLeft: 8,
          topRight: 8,
          bottomLeft: 0,
          bottomRight: 0
        })
        .objectFit(ImageFit.Contain)
        .width("100%")

      Text(this.listData.name)
        .padding({
          left: 16,
          right: 16
        })
        .width("100%")
        .fontColor(Color.Black)
        .textAlign(TextAlign.Start)
        .maxLines(2)
        .fontSize(14)
        .margin({
          top: 10,
          bottom: 10
        })
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
      Row() {
        Text("难度")
          .fontColor(Color.Black)
          .opacity(0.6)
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .height(18)
          .fontSize(12)
        Rating({
          rating: this.listData.ratingNumber,
          indicator: true
        }).stars(5)
      }
    }
    .linearGradient({
      angle: 180,
      colors: [['#ccdfff', 0], ["#f3f4f7", 1]]
    })
    .width(177)
    .borderRadius(8)
    .margin({
      top: 4,
      bottom: 4
    })
    .onClick(() => {
      // 平板采用点击切换案例，需要pop，手机则不需要，左滑时已pop。
      // if (this.isNeedClear) {
      //   DynamicsRouter.clear();
      // }
      if (this.listData !== undefined) {
        // 点击瀑布流Item时，根据点击的模块信息，将页面放入路由栈
        // DynamicsRouter.pushUri(this.listData.appUri,this.listData.param);

        MLog.debug(`click appuri:${this.listData.appUri} params:${this.listData.param}`)

        if (this.listData.isUseNewRouter) {
          // 点击瀑布流Item时，根据点击的模块信息，将页面放入路由栈
          DynamicsRouter.pushUri(this.listData.appUri, this.listData.param);
        } else {
          router.pushNamedRoute({
            name: this.listData.appUri,
            params: this.listData.param
          }).catch((e: Error) => {
            // MLog.debug('router push error' + JSON.stringify(e))
          })
        }
      }
    })
  }

  /**
   * 注册屏幕状态监听 (仅限折叠屏)
   * @returns {void}
   */
  regDisplayListener(): void {
    this.changeNeedClear(display.getFoldStatus());
    display.on('foldStatusChange', async (curFoldStatus: display.FoldStatus) => {
      // 同一个状态重复触发不做处理
      if (this.curFoldStatus === curFoldStatus) {
        return;
      }
      // 缓存当前折叠状态
      this.curFoldStatus = curFoldStatus;
      this.changeNeedClear(this.curFoldStatus);
    })
  }

  changeNeedClear(status: number): void {
    if (status === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.isNeedClear = false;
    } else {
      this.isNeedClear = true;
    }
  }
}