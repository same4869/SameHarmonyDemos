import { MenuBar } from './MenuBar';
import { TabSheets } from './TabSheets'
import { util } from '@kit.ArkTS';
import { FunctionDescription } from '@same/common/Index';
import STYLE_CONFIGURATION from '../model/constantsData';

@Preview
@Entry({ routeName: 'handletabs/HandleTabs' })
@Component
export struct HandleTabs {
  @State tabArray: Array<number> = [0]; // 控制页签渲染的数组
  @State focusIndex: number = 0; // Tabs组件当前显示的页签下标
  controller: TabsController = new TabsController(); // Tabs控制器
  private addressList: Array<number> = new Array(8).fill(0) // 快捷方式集合

  @Builder
  tabContentBuilder() {
    Column() {
      Search().width("90%")
      Grid() {
        // 性能知识点：此处列表项确定且数量较少，使用了ForEach，在列表项多的情况下，推荐使用LazyForeEach
        ForEach(this.addressList, () => {
          GridItem() {
            Column({ space: STYLE_CONFIGURATION.CONTENT_GUTTER_S }) {
              Text().width(STYLE_CONFIGURATION.IMAGE_SIZE)
                .aspectRatio(1)
                .backgroundColor("#33000000")
                .borderRadius(STYLE_CONFIGURATION.IMAGE_RADIUS)
              Text()
                .width(STYLE_CONFIGURATION.TEXT_WIDTH)
                .height(STYLE_CONFIGURATION.TEXT_HEIGHT)
                .backgroundColor("#33000000")
            }
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(STYLE_CONFIGURATION.CONTENT_GUTTER_M)
      .rowsTemplate('1fr 1fr')
      .height(STYLE_CONFIGURATION.GRID_HEIGHT)
      .margin({ top: STYLE_CONFIGURATION.GRID_MARGIN })
    }
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      /**
       * 自定义TabBar组件
       * TODO:知识点：1.隐藏系统Tab组件的TabBar，在自定义tabBar组件中，修改focusIndex实现不同页签切换
       */
      TabSheets({ tabArray: $tabArray, focusIndex: $focusIndex, controller: this.controller })

      MenuBar()

      Divider()
        .width("100%")
        .backgroundColor($r('sys.color.ohos_id_color_subheading_separator'))

      Tabs({ barPosition: BarPosition.Start, index: this.focusIndex, controller: this.controller }) {
        /**
         * TODO：知识点：2.通过ForEach循环数组动态创建TabContent组件
         * 性能知识点：ForEach的第三个入参keyGenerator唯一时，动态修改ForEach时，可降低渲染开销
         * 参考文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-foreach-0000001820999585
         */
        ForEach(this.tabArray, (item: number, index: number) => {
          TabContent() {
            Column() {
              if (this.tabArray[index] === 0) {
                FunctionDescription({
                  title: "增删页签",
                  content: "本示例介绍使用了实现自定义增删Tab页签的功能。该场景多用于浏览器等场景。"
                })
              } else {
                this.tabContentBuilder()
              }
            }
          }
        }, (item: number) => item.toString() + util.generateRandomUUID())
      }
      .scrollable(false)
      .onChange((index: number) => {
        this.focusIndex = index
      })
    }.width("100%")
  }
}