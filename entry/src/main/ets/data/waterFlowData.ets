import { SceneModuleInfo } from '@same/functionalscenes/src/main/ets/model/SceneModuleInfo'

export const waterFlowData: SceneModuleInfo[] = [
  new SceneModuleInfo($r('app.media.address_exchange'), '地址交换动画', 'addressexchange/AddressExchangeView', '动效', 2),
  new SceneModuleInfo($r('app.media.tab_bar'), '自定义TabBar页签', 'customtabbar/TabView', 'UI布局'),
  new SceneModuleInfo($r('app.media.modal_window'), '全屏登录页面', 'modalwindow/ModalWindow', 'UI布局'),
  new SceneModuleInfo($r('app.media.mp_charts'), 'MpChart运动健康', "barchart/MpCharts", '三方库', 3),
  new SceneModuleInfo($r('app.media.slide_to_hide_and_displace'), '滑动页面改变顶部个人信息栏显示效果', 'slidetohideanddisplace/SlideToHideAndDisplace', '动效'),
  new SceneModuleInfo($r('app.media.image_viewer'), '图片缩放功能实现', 'imageviewer/ImageViewerView', '其他'),
]