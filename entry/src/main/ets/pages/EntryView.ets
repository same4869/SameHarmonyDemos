import { FunctionalScenes } from "@same/functionalscenes/src/main/ets/FunctionalScenes"
import { SceneModuleInfo } from '@same/functionalscenes/src/main/ets/model/SceneModuleInfo';
import { DynamicsRouter } from '@same/routermodule/Index';
import { MLog } from '@same/utils';
import { waterFlowData } from '../data/waterFlowData';
import util from '@ohos.util';

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

// 插入执行前后打印时间, 将插入动作封装成一个接口
function addTimePrinter(targetClass: Object, methodName: string, isStatic: boolean) {
  let t1 = 0;
  let t2 = 0;
  util.Aspect.addBefore(targetClass, methodName, isStatic, () => {
    t1 = new Date().getTime();
    MLog.debug("aspect t1 = " + t1.toString());
  });
  util.Aspect.addAfter(targetClass, methodName, isStatic, () => {
    t2 = new Date().getTime();
    MLog.debug("aspect t2 = " + t2.toString());
    MLog.debug("aspect t2---t1 = " + (t2 - t1).toString());
  });
}

@Entry
@Component
struct EntryView {
  @State listData: SceneModuleInfo[] = waterFlowData;
  // Navigation路由栈,控制页面跳转
  @Provide('pageStack') pageStack: NavPathStack = DynamicsRouter.navPathStack;
  @Provide('isFullScreen') isFullScreen: boolean = false;
  @State navigationMode: number = NavigationMode.Stack;

  testTime() {
    let a: number = 100000
    for (let index = 0; index < 999999; index++) {
      a /= 2
      a *= 2
    }
    MLog.debug("aspect testTime")
  }

  // aboutToAppear() {
  //   // 给Test的doSomething实例方法添加打印执行时间的逻辑
  //   // addTimePrinter(EntryView, 'testTime', false);
  //   util.Aspect.replace(EntryView, 'testTime', false, (instance: EntryView, arg: string) => {
  //     MLog.debug("aspect replace testTime method impl")
  //   })
  //   this.testTime()
  // }

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