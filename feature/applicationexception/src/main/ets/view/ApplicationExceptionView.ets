import { FunctionDescription } from '@same/common/Index'
import { FaultDataSource } from '../model/FaultDataSource';
import { PreferencesManager } from '../model/PreferencesManager';
import { hiAppEvent } from '@kit.PerformanceAnalysisKit';
import { BUTTON_TEXT } from '../model/MockData';

@Component
@Entry({ routeName: 'applicationexception/ApplicationExceptionView' })
export struct ApplicationExceptionView {
  // 初始化被点击的异常事件下标
  @Provide eventIndex: number = -1;

  build() {
    Column() {
      FunctionDescription({
        title: "应用异常信息获取",
        content: "点击构建异常事件，3s之后触发系统异常事件，需要重新启动应用并进入本页面，由于规格原因需等待1min左右才能获取异常数据"
      })

      FaultArea()

      FaultConstruction()
    }.padding(12)
  }
}

@Component
struct FaultArea {
  // 懒加载数据源
  @State faultDataSource: FaultDataSource = new FaultDataSource();
  // 双向数据绑定懒加载数据源的数组长度
  @StorageLink('faultDataSourceLength') faultDataSourceLength: number = 0;
  // 被点击的异常事件下标
  @Consume eventIndex: number;
  // 异常触发标识
  @StorageLink('faultSign') faultSign: boolean = false;
  // 双向数据绑定事件组，与AppStorage.setOrCreate进行绑定，此变量发生变化触发getFaultMessage函数
  @StorageLink('appEventGroups') @Watch('getFaultMessage') appEventGroups: Array<hiAppEvent.AppEventGroup> = [];

  async aboutToAppear() {
    await PreferencesManager.getPreferences(this.faultDataSource)
    // 先从持久化存储中获取数据，再获取上一次应用异常信息添加到列表头部，并更新持久化存储
    this.getFaultMessage();
    // 重置AppStorage中的appEventGroups，避免添加重复数据
    AppStorage.setOrCreate('appEventGroups', []);
  }

  // 获取应用异常信息
  async getFaultMessage() {
    if (this.appEventGroups && this.appEventGroups.length > 0) {
      this.appEventGroups.forEach((eventGroup: hiAppEvent.AppEventGroup) => {
        eventGroup.appEventInfos.forEach(async (eventInfo: hiAppEvent.AppEventInfo) => {
          let message: string = '';
          message += `HiAppEvent eventInfo.domain=${eventInfo.domain}\n` // 事件领域
            + `HiAppEvent eventInfo.name=${eventInfo.name}\n`  // 事件名称
            + `HiAppEvent eventInfo.eventType=${eventInfo.eventType}\n` // 事件名称
            + `HiAppEvent eventInfo.params.time=${eventInfo.params['time']}\n` // 事件发生的时间
            + `HiAppEvent eventInfo.params.crash_type=${eventInfo.params['crash_type']}\n`
            + `HiAppEvent eventInfo.params.foreground=${eventInfo.params['foreground']}\n`
            + `HiAppEvent eventInfo.params.bundle_version=${eventInfo.params['bundle_version']}\n`
            + `HiAppEvent eventInfo.params.bundle_name=${eventInfo.params['bundle_name']}\n`
            + `HiAppEvent eventInfo.params.exception=${JSON.stringify(eventInfo.params['exception'])}\n`
            + `HiAppEvent eventInfo.params.hilog.size=${eventInfo.params['hilog'].length}\n`;
          // TODO：知识点：将异常信息存储到数组faultMessage当中
          this.faultDataSource.pushData(message);
        })
      })
    }
    // TODO：知识点：持久化存储异常信息集合
    this.faultDataSource.persistenceStorage();
  }

  build() {
    List() {
      // 添加判断，如果异常信息集合的信息条数大于0，遍历异常信息
      if (this.faultDataSourceLength > 0) {
        // 性能：动态加载数据场景可以使用LazyForEach遍历数据。https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-rendering-control-lazyforeach-0000001524417213-V3
        LazyForEach(this.faultDataSource, (message: string) => {
          ListItem() {
            Text(message).textAlign(TextAlign.Start)
          }
        }, (item: string) => item)
      } else {
        ListItem() {
          Text(this.eventIndex === 0 ? "3s之后触发系统崩溃事件，需要重新启动应用并进入本页面获取上次异常退出原因" :
            (this.eventIndex === 1 ? "3s之后触发系统卡死事件，需要重新启动应用并进入本页面获取上次异常退出原因" :
              (this.faultSign ? "由于规格原因，当前异常事件接收有延迟，数据大约在1min左右会进行更新" :
                "暂无信息")))
        }
      }
    }
    .width("100%")
    .height(300)
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    .borderRadius(12)
    .padding(12)
    .margin({ top: 16 })
  }
}

@Component
struct FaultConstruction {
  // 被点击的异常事件下标
  @Consume eventIndex: number;
  // 双向数据绑定懒加载数据源的数组长度
  @StorageLink('faultDataSourceLength') faultDataSourceLength: number = 0;
  // 异常触发标识
  @StorageLink('faultSign') faultSign: boolean = false;

  handleOperate(index: number) {
    switch (index) {
      case 0:
      // 在按钮点击函数中构造一个APP_CRASH场景，触发应用崩溃事件
        const result: object = JSON.parse('');
        break;
      case 1:
      // 在按钮点击函数中构造一个APP_FREEZE场景，触发应用卡死事件,500ms之后执行无限循环
        while (true) {
        }
    }
  }

  build() {
    Column() {
      ForEach(BUTTON_TEXT, (item: string, index: number) => {
        Button(item)
          .type(ButtonType.Capsule)
          .size({ width: "100%" })
          .borderRadius(12)
          .margin({ top: 8 })
          .onClick(() => {
            // 触发异常标识
            this.faultSign = true;
            PreferencesManager.putFaultSign();
            // 点击异常的时候，清空页面信息数据，显示异常描述信息。控制页面信息数据的显示需要将此变量设置为0
            this.faultDataSourceLength = 0;
            // 更新被点击的异常事件下标
            this.eventIndex = index;
            // 3s之后执行系统崩溃操作
            setTimeout(() => {
              this.handleOperate(index);
            }, 3000)
          })
      }, (item: string) => JSON.stringify(item))
    }
    .margin({ top: 16 })
  }
}