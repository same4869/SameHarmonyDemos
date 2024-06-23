import { FunctionalScenes } from "@same/functionalscenes/src/main/ets/FunctionalScenes"
import { SceneModuleInfo } from '@same/functionalscenes/src/main/ets/model/SceneModuleInfo';
import { DynamicsRouter } from '@same/routermodule/Index';
import { waterFlowData } from '../data/waterFlowData';

import('@same/addressexchange/src/main/ets/view/AddressExchangeView');
import('@same/customtabbar/src/main/ets/view/TabView');
import('@same/modalwindow/src/main/ets/components/ModalWindow');
import('@same/mpcharts/src/main/ets/health/view/MpCharts');
import('@same/slidetohideanddisplace/src/main/ets/components/SlideToHideAndDisplace');
import('@same/imageviewerview/src/main/ets/view/ImageViewerView');
import('@same/eventpropagation/src/main/ets/view/EventPropagation');
import('@same/secondarylinkexample/src/main/ets/pages/SecondaryLinkExample');
import('@same/todolist/src/main/ets/pages/ToDoList');
import('@same/nativerawfiledemo/src/main/ets/components/mainpage/NativeRawfileDemo');
import('@same/friendsbook/src/main/ets/pages/FriendsBook');
import('@same/handletabs/src/main/ets/pages/HandleTabs');
import('@same/akiview/src/main/ets/view/AKiView');
import('@same/variablewatchview/src/main/ets/view/VariableWatchView');
import('@same/photopickandsave/src/main/ets/view/PictureManager');
import('@same/applicationexception/src/main/ets/view/ApplicationExceptionView');
import('@same/fitfordarkmode/src/main/ets/view/FitForDarkMode');
import('@same/marquee/src/main/ets/view/MarqueeView');
import('@same/pulltorefreshnews/src/main/ets/pages/PullToRefreshNews');
import('@same/verifycode/src/main/ets/view/VerifyCodeView');
import('@same/vibrateeffect/src/main/ets/view/VibrateEffect');
import('@same/navigationbarchange/src/main/ets/view/NavigationBarChange');

@Entry
@Component
struct EntryView {
  @State listData: SceneModuleInfo[] = waterFlowData;
  // Navigation路由栈,控制页面跳转
  @Provide('pageStack') pageStack: NavPathStack = DynamicsRouter.navPathStack;
  @State navigationMode: number = NavigationMode.Stack;

  build() {
    Stack() {
      Navigation(this.pageStack) {
        FunctionalScenes({ listData: this.listData })
      }
      .padding({ bottom: 1 })
      .backgroundColor("#f1f1f1")
      .hideTitleBar(true)
      .navBarWidth("50%")
      .hideNavBar(false)
      .navDestination(this.pageMap)
      .mode(this.navigationMode)
    }
    .alignContent(Alignment.BottomEnd)
    .height("100%")
    .backgroundColor("#f1f1f1")
  }

  @Builder
  pageMap(name: string, param: ESObject) {
    NavDestination() {
      // 根据模块名，获取WrappedBuilder对象，通过builder接口创建页面
      DynamicsRouter.getBuilder(name).builder(param);
    }
    .padding({ bottom: 8 })
    // 登录页是半模态，需要背景透明，设置为DIALOG
    .backgroundColor("f1f1f1")
    .hideTitleBar(true)
  }
}