/**
 * @Author: xwang
 * @Date: 2024/7/15 08:41
 * @Description:
 **/
import { resourceManager } from '@kit.LocalizationKit';
import { AppRouter } from '@ohos/dynamicsRouter';
import { SideBarContentView } from './SideBarContentView';
import { SideBarView } from './SideBarView';

@AppRouter({ name: "sidebaranimation/SideBarAnimationView" })
@Component
export struct SideBarAnimationView {
  sidebarType: SideBarContainerType = SideBarContainerType.Embed;
  deviceType: resourceManager.DeviceType = resourceManager.DeviceType.DEVICE_TYPE_PHONE;
  @State isShowSideBar: boolean = false;
  @State sideBarBtnOffset: number = 0;

  aboutToAppear(): void {
    this.deviceType = getContext(this).resourceManager.getDeviceCapabilitySync().deviceType
    if (this.deviceType === resourceManager.DeviceType.DEVICE_TYPE_PHONE) {
      this.sidebarType = SideBarContainerType.AUTO
    }
  }

  build() {
    SideBarContainer(this.sidebarType) {
      /**
       * TODO：知识点：这里自定义了Opacity的动画，注意，因为本方案使用的是显式动画，
       * 且通过显式动画对this.isShowSideBar进行了变化，因此相关动画属性均需要与this.isShowSideBar进行关联，
       * 动画的实现见SideBarContentView中的switchTabBar方法
       */
      SideBarView()
        .borderRadius($r("sys.float.ohos_id_corner_radius_default_m"))
        .opacity(this.isShowSideBar ? 1 : 0)

      SideBarContentView({ isShowSideBar: this.isShowSideBar, deviceType: this.deviceType })
        .width("100%")
    }
    .divider(null)
    .sideBarPosition(SideBarPosition.End)
    // TODO：知识点：通过showSideBar属性控制侧边栏的显隐，以便定制动效
    .showSideBar(this.isShowSideBar)
    // TODO：知识点：由于SideBarContainer的默认按钮无法定制动效，所以需要隐藏掉，通过自定义按钮进行动画的控制
    .showControlButton(false)
    .sideBarWidth(200)
    .maxSideBarWidth(this.deviceType === resourceManager.DeviceType.DEVICE_TYPE_PHONE ?
      200 : null)
    .minSideBarWidth(this.deviceType === resourceManager.DeviceType.DEVICE_TYPE_PHONE ?
      200 : null)
    .autoHide(false)
    .size({ width: "100%", height: "100%" })
    .padding($r('sys.float.ohos_id_card_margin_start'))
  }
}