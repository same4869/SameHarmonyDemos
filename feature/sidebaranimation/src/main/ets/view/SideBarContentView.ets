/**
 * @Author: xwang
 * @Date: 2024/7/15 09:31
 * @Description:
 **/
import { resourceManager } from '@kit.LocalizationKit';
import { MToast } from '@same/common/src/main/ets/utils/MToast';

@Component
export struct SideBarContentView {
  @StorageLink('keyboardHeight') keyboardHeight: number = 0;
  @Link isShowSideBar: boolean;
  @State sideBarBtnOffset: number = 0;
  deviceType: resourceManager.DeviceType = resourceManager.DeviceType.DEVICE_TYPE_PHONE;

  switchTabBar() {
    // TODO：知识点：本例核心，点击Button的时候通过显式动画来控制sidebar的显示与隐藏，因为这里只对this.isShowSideBar进行了变化，因此所有相关动画均需与其关联
    animateTo({ duration: 500, curve: Curve.Friction }, () => {
      this.isShowSideBar = !this.isShowSideBar
      if (this.deviceType === resourceManager.DeviceType.DEVICE_TYPE_PHONE) {
        if (this.isShowSideBar) {
          this.sideBarBtnOffset = -1 * 200
        } else {
          this.sideBarBtnOffset = 0
        }
      }
    })
  }

  @Builder
  buildChatInfo() {
    Row() {
      Image(null)
        .width(50)
        .height(50)
        .borderRadius(25)
        .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
      Column() {
        Text("Author 2024-02-25 14:30")
        Text("本例主要用于2in1设备，如群聊侧边栏显示群成员，在手机上的效果与2in1设备上有区别。通过显式动画来实现SideBarContainer侧边栏的淡入淡出。\n1. 请点击右侧三角进行侧边栏的显示或隐藏\n2. 请将鼠标置于侧边栏边缘，待鼠标变为双向箭头样式，长按鼠标左键并左右拖动以变化侧边栏大小（手机上无此效果）")
          .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
          .padding($r("sys.float.ohos_id_card_margin_start"))
          .borderRadius($r("sys.float.ohos_id_corner_radius_default_m"))
          .constraintSize({
            maxWidth: "calc(100% - 50vp)"
          }) // TODO：知识点：这里使用了计算特性对组件的最大宽度进行了限制，以避免组件尺寸超出父组件
      }
      .alignItems(HorizontalAlign.Start)
      .margin({
        left: $r("sys.float.ohos_id_card_margin_start"),
      })
    }
    .width("100%")
    .alignItems(VerticalAlign.Top)
  }

  build() {
    Stack() {
      Column() {
        Column() {
          Text("侧边栏淡入淡出动画案例")
            .fontSize($r("sys.float.ohos_id_text_size_headline8"))
            .fontWeight(16)
            .margin($r("sys.float.ohos_id_card_margin_start"))

          Divider()
          Column() {
            this.buildChatInfo()
          }
          .width("100%")
          .padding({ top: $r("sys.float.ohos_id_card_margin_start") })
        }
        .alignItems(HorizontalAlign.Start)
        .width("100%")

        Blank()

        if (this.deviceType === resourceManager.DeviceType.DEVICE_TYPE_PHONE) {
          TextInput()
            .defaultFocus(false)
            .width("100%")
        } else {
          Stack() {
            TextArea()
              .borderRadius($r("sys.float.ohos_id_corner_radius_default_m"))
              .height(200)
            Button("发送")
              .onClick(() => {
                MToast.showToast("仅供UI展示")
              })
              .margin($r("sys.float.ohos_id_card_margin_end"))
          }
          .align(Alignment.BottomEnd)
        }
      }
      .alignItems(HorizontalAlign.End)
      .width("100%")
      .height("100%")
      .padding({ left: $r("sys.float.ohos_id_card_margin_start"), right: $r("sys.float.ohos_id_card_margin_start") })

      Image(this.isShowSideBar ? $r("sys.media.ohos_ic_public_arrow_right") : $r("sys.media.ohos_ic_public_arrow_left"))
        .autoResize(true)
        .objectFit(ImageFit.Cover)
        .onClick(() => {
          this.switchTabBar()
        })
        .height(40)
        .width(20)
        .borderRadius({
          topLeft: 6,
          bottomLeft: 6
        })
        .offset({ x: this.sideBarBtnOffset })
        .responseRegion({
          x: -10,
          y: -10,
          width: 40,
          height: 60
        })
        .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
    }
    .width("100%")
    .alignContent(Alignment.End)
    .padding({ bottom: px2vp(this.keyboardHeight) })
  }
}