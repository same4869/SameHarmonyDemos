import { TabSheets } from './TabSheets'

@Preview
@Entry({ routeName: 'handletabs/HandleTabs' })
@Component
export struct HandleTabs {
  @State tabArray: Array<number> = [0]; // 控制页签渲染的数组
  @State focusIndex: number = 0; // Tabs组件当前显示的页签下标
  controller: TabsController = new TabsController(); // Tabs控制器

  build() {
    Column() {
      /**
       * 自定义TabBar组件
       * TODO:知识点：1.隐藏系统Tab组件的TabBar，在自定义tabBar组件中，修改focusIndex实现不同页签切换
       */
      TabSheets({ tabArray: $tabArray, focusIndex: $focusIndex, controller: this.controller })
    }.width("100%")
  }
}