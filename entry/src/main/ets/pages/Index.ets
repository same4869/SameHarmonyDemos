import { router } from '@kit.ArkUI';
import { MLog } from '@same/utils/Index';
import('@same/addressexchange/src/main/ets/view/AddressExchangeView');
import('@same/customtabbar/src/main/ets/view/TabView');
import('@same/modalwindow/src/main/ets/components/ModalWindow');

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button("地址交换动画").onClick(() => {
        router.pushNamedRoute({
          name: 'AddressExchangePage',
          params: {}
        }).catch((e: Error) => {
          MLog.debug('router push error' + JSON.stringify(e))
        })
      })
      Button("自定义tabbar").onClick(() => {
        router.pushNamedRoute({
          name: 'customtabbar',
          params: {}
        }).catch((e: Error) => {
          MLog.debug('router push error' + JSON.stringify(e))
        })
      })
      Button("全屏登录页面").onClick(() => {
        router.pushNamedRoute({
          name: 'modalwindow',
          params: {}
        }).catch((e: Error) => {
          MLog.debug('router push error' + JSON.stringify(e))
        })
      })
    }
    .height('100%')
    .width('100%')
  }
}