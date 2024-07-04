import { AbilityConstant, Configuration, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, window } from '@kit.ArkUI';
import { eventSubscription } from '@same/applicationexception/Index';
import { DynamicsRouter } from '@same/routermodule/Index';
import { BusinessError } from '@kit.BasicServicesKit';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    DynamicsRouter.routerInit({
      libPrefix: "@same", mapPath: "routerMap"
    }, this.context);

    // 事件订阅(获取上次异常退出信息)
    eventSubscription();
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/EntryView', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });

    let windowClass: window.Window | undefined = undefined
    window.getLastWindow(this.context, (err: BusinessError, data) => {
      if (err.code) {
        console.error('Failed to obtain top window. Cause:' + JSON.stringify(err));
        return;
      }
      windowClass = data;
      console.info('Success to obtain top window. Cause:' + JSON.stringify(data));
      // 窗口内容规避的顶部状态栏高度
      let statusHeight = 0;
      // 窗口内容规避的底部安全区高度
      let bottomHeight = 0;
      // 获取窗口内容规避的区域在componentstack里使用
      let type = window.AvoidAreaType.TYPE_SYSTEM;
      try {
        let avoidArea = windowClass.getWindowAvoidArea(type);
        console.info('Succeeded to obtain the area. Cause:' + JSON.stringify(avoidArea));
        statusHeight = avoidArea.topRect.height;
        bottomHeight = avoidArea.bottomRect.height
      } catch (exception) {
        console.error('Failed to obtain the area. Cause:' + JSON.stringify(exception));
      }
      // 存储窗口内容规避的状态栏高度
      AppStorage.setOrCreate('statusHeight', statusHeight);
      // 存储窗口内容规避的底部安全区高度
      AppStorage.setOrCreate('bottomHeight', bottomHeight);

      // 当前窗口高度
      let screenHeight = 0;
      // 获取窗口区域在componentstack里使用
      let displayClass: display.Display | null = null;
      try {
        displayClass = display.getDefaultDisplaySync();
        screenHeight = displayClass.height;
      } catch (exception) {
        console.error('Failed to obtain the default display object. Code: ' + JSON.stringify(exception));
      }
      console.error('Succeeded to obtain the default display object. Code: ' + JSON.stringify(displayClass));
      // 存储当前窗口高度
      AppStorage.setOrCreate('screenHeight', screenHeight);
    })

    // 获取当前的颜色模式并保存
    AppStorage.setOrCreate('currentColorMode', this.context.config.colorMode);
    // 保存windowStage供fitfordarkmode的har包中FitForDarkPage.ets中setStatusBar方法修改状态栏颜色。
    AppStorage.setOrCreate('windowStage', windowStage);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    // 获取最新的变更颜色并更新到AppStorage
    AppStorage.setOrCreate('currentColorMode', newConfig.colorMode);
  }
}
