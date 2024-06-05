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