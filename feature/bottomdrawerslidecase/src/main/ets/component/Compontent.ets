/**
 * @Author: xwang
 * @Date: 2024/8/12 09:23
 * @Description:
 **/
import { CommonConstants } from '../constants/CommonConstants';

@Component
export struct ImageMapView {
  @State imagePositionX: number = 0; // 图片在父组件内X轴位置
  @State imagePositionY: number = 0; // 图片在父组件内Y轴位置
  @State offsetX: number = 0; // 拖动事件结束后图片X轴位置
  @State offsetY: number = 0; // 拖动事件结束后图片Y轴位置

  build() {
    Column() {
      Image($r("app.media.bottomdrawerslidecase_map"))
        .id("bg_img")
        .width(1000)
        .height(1000)
        .objectFit(ImageFit.Contain)
        .translate({ x: this.offsetX, y: this.offsetY })
        .draggable(false)
    }
    .width("100%")
    .height("100%")
    .clip(true)
    .gesture(
      PanGesture({ direction: PanDirection.All, fingers: 1 })
        .onActionUpdate((event: GestureEvent) => {
          this.offsetX = event.offsetX + this.imagePositionX;
          this.offsetY = event.offsetY + this.imagePositionY;
        })
        .onActionEnd((event: GestureEvent) => {
          this.imagePositionX = this.offsetX;
          this.imagePositionY = this.offsetY;
        })
    )
  }
}

// 地图顶部标题栏
@Component
export struct HomeTop {
  @Link statusBarHeight: number; // 状态栏高度

  build() {
    Row() {
      Text("打车")
        .margin({ left:25, right: 15 })
        .fontColor(Color.Black)
        .fontSize(18)
    }
    .width('100%')
    .height(48)
    .margin({ top: this.statusBarHeight })
  }
}

// 页面最顶部自定义标题
@Component
export struct StatusHead {
  @Link statusBarHeight: number;
  @State topHeaderHeight: number = 0;
  @Link isShow: boolean;

  build() {
    Column() {
      Blank()
        .width(CommonConstants.FULL_SIZE)
        .backgroundColor(Color.White)
        .height(this.statusBarHeight)
      Row() {
        Image($r("app.media.bottomdrawerslidecase_next"))
          .width($r("app.integer.bottomdrawerslidecase_height_22"))
          .height($r("app.integer.bottomdrawerslidecase_height_22"))
          .margin({ left: $r("app.integer.bottomdrawerslidecase_number_25"), right: $r("app.integer.bottomdrawerslidecase_number_15") })
        Text($r("app.string.bottomdrawerslidecase_homeTop"))
          .fontColor(Color.Black)
          .fontSize($r("app.integer.bottomdrawerslidecase_number_20"))
      }
      .backgroundColor(Color.White)
      .width(CommonConstants.FULL_SIZE)
      .height(this.topHeaderHeight)
    }
    .visibility(this.isShow ? Visibility.Visible : Visibility.None)
    .animation({
      duration: 200, // 动画持续时间，单位毫秒
      curve: Curve.Smooth, // 动画曲线
      iterations: 1, // 动画播放次数
      playMode: PlayMode.Normal// 动画播放模式
    })
  }
}

// listItem布局样式
@Component
export struct SettingItemView {
  @Link bottomAvoidHeight: number; // 底部导航条避让高度

  build() {
    Column() {
      Image($r("app.media.bottomdrawerslidecase_list_item"))
        .draggable(false)
        .height($r("app.integer.bottomdrawerslidecase_other_itemheight"))
        .width('98%')
        .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
      Blank()
        .color(Color.White)
        .height(this.bottomAvoidHeight)
    }
  }
}
