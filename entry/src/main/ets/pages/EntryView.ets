import { FunctionalScenes } from "@same/functionalscenes/src/main/ets/FunctionalScenes"
import { SceneModuleInfo } from '@same/functionalscenes/src/main/ets/model/SceneModuleInfo';
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
import('@same/pageturninganimation/src/main/ets/view/PageTurningAnimation');

@Entry
@Component
struct EntryView {
  @State listData: SceneModuleInfo[] = waterFlowData;

  build() {
    Stack() {
      Navigation() {
        FunctionalScenes({ listData: this.listData })
      }
      .mode(NavigationMode.Stack)
      .navBarWidth("50%")
      .hideTitleBar(true)
    }
    .alignContent(Alignment.BottomEnd)
    .height("100%")
    .backgroundColor("#f1f1f1")
  }
}