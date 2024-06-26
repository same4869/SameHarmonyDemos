/**
 * @Author: xwang
 * @Date: 2024/6/26 15:53
 * @Description:
 **/
import { AppRouter, DynamicsRouter } from '@ohos/dynamicsRouter/Index';

@AppRouter({ name: "mediafullscreen/MediaFullScreen" })
@Component
export struct MediaFullScreen {
  @Provide pageMediaFullScreen: NavPathStack = new NavPathStack();
  @State selectedVideo: string = ''; // 选择的视频名称
  @State isLandscape: boolean = false; // 是否横屏状态

  build() {
    // 应用主页用NavDestination承载，用于显示Navigation的内容区
    Navigation(this.pageMediaFullScreen) {

    }
    .mode(NavigationMode.Stack)
    .onAppear(() => {
      this.pageMediaFullScreen.pushPathByName("MediaFullScreen", null, false)
    })
    // 创建NavDestination组件，需使用此组件的onBackPressed回调拦截返回事件
    .navDestination(this.videoArea)
  }

  @Builder
  videoArea() {
    // 性能知识点: 功能是以har的形式集成在主工程中，没有@Entry修饰的组件，无法使用@Entry组件的onBackPress生命周期函数。
    NavDestination() {
      Column() {

      }
      .backgroundColor("#33182431")
      .height("100%")
      .layoutWeight(1)
    }
    .hideTitleBar(true)
    // TODO：知识点：返回时通过弹窗拦截，点击弹窗不保存按钮直接返回主界面，点击保存按钮将数据写入到preferences实例中，持久化存储数据
    .onBackPressed(() => {
      if (this.selectedVideo === '') {
        DynamicsRouter.popAppRouter()
        return true
      } else {
        this.isLandscape = !this.isLandscape
        return true
      }
    })
  }
}