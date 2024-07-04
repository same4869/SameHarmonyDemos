/**
 * @Author: xwang
 * @Date: 2024/7/4 10:06
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import { MToast } from '@same/common';
import { IconList1, IconList2, IconList3 } from './IconView';
import { ProductList } from './ProductList';

/**
 * 实现步骤：
 * 1.在设计布局时，考虑到头部组件位于底部且其他组件需在其之上层叠展示，选用Stack组件以达成这种堆叠效果，确保各组件间具有清晰的前后层级关系。
 * 2.为了实现顶部可滚动区域的内容堆叠和滚动效果，我们采用Scroll组件，确保用户可以顺畅地浏览滚动内容。
 * 3.在处理滚动过程中动态调整文本框高度及组件透明度的需求时，通过对Scroll组件的滚动事件回调函数onScroll处理，使其在滚动过程中实时监测并适时修改文本框的高度及组件透明度。
 * 4.在处理多层嵌套滚动场景时，保证正确的滚动顺序（即先滚动父组件再滚动子组件），只需在内层的Scroll组件中设置其nestedScroll属性，确保滚动行为符合预期。
 * 5.商品列表部分采用瀑布流（WaterFlow）布局容器进行设计，将商品信息动态分布并分成两列呈现，每列商品自上而下排列，使用了LazyForEach进行数据懒加载，WaterFlow布局时会根据可视区域按需创建FlowItem组件，并在FlowItem滑出可视区域外时销毁以降低内存占用。
 */

/** 为便于后续描述与交流，现对应用界面中的相关区域进行命名说明：
 * 1.底部白色背景区域：位于搜索栏正下方，呈现纯白色背景的区域，将此区域命名为“快捷图标区域1”。
 * 2.商品上方无背景色横条列表：紧邻商品布局之上，未设置独立背景颜色的一组横向排列的图标，将其定义为“快捷图标区域2”。
 * 3.向上滑动后显现的列表：当用户在界面中向上滑动操作时，会逐渐露出的另一组图标，此部分称为“快捷图标区域3”。
 * 以上定义旨在清晰、准确地标识出应用界面中涉及的三个快捷图标区域，以利于后续描述。
 */

const ASPECTRATIO: number = 1; // 图片的宽高比
const OPACITY: number = 0.6; // 字体设置透明度
const ZINDEX: number = 1; // 快截图标区域3放在最上层
const LAYOUT_WEIGHT: number = 1; // 分配剩余空间
const USED_HEIGHT: number = 110; // 已占用高度

@Preview
@AppRouter({ name: "componentstack/ComponentStack" })
@Component
export struct ComponentStack {
  build() {
    // TODO: 知识点：堆叠容器，子组件按照顺序依次入栈，后一个子组件覆盖前一个子组件。
    Stack({ alignContent: Alignment.Top }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Image($r("app.media.component_stack_user_portrait"))
          .width(30)
          .aspectRatio(1)
          .borderRadius(15)

        Image($r("app.media.component_stack_stack_scan"))
          .width(30)
          .aspectRatio(1)
      }.padding({
        left: 15,
        right: 15,
        top: 5
      })
      .width("100%")
      .height(50)

      ScrollView()
    }
    .width("100%")
    .layoutWeight(1)
    .backgroundColor("#f1f3f5")
    .padding({ top: 12 })
  }
}

@Component
struct ScrollView {
  @State searchHeight: number = 100; // 搜索框原始高度
  readonly searchHeightRaw: number = 100; // 备份搜索框初始高度
  @State marginTop: number = 250; // 快截图标区域2 顶部偏移量
  @State opacity2: number = 1; // 快截图标区域2 透明度
  @State ratio: number = 1; // 快截图标区域2 缩小比例
  @State height2: number = 100; // 快截图标区域2 高度
  readonly height2Raw: number = 100; // 快截图标区域2 备份高度
  @State isChange: boolean = false; // 改变快截图标区域1的组件
  @State opacity1: number = 1; // 快截图标区域1的透明度
  @State marginSpace: number = 25; // 快截图标区域3 左右之间间隔
  readonly maxMarginSpace: number = 25; // IconList3默认最大间距
  readonly minMarginSpace: number = 12; // IconList3默认最小间距
  readonly IconList1Raw: number = 100; // 计算IconList1的透明度
  readonly IconList2Raw: number = 120; // 计算IconList2的透明度
  readonly IconList3Raw: number = 140; // 计算IconList3的透明度
  scroller: Scroller = new Scroller();
  scroller2: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        SearchView({ searchHeight: this.searchHeight })

        Stack({ alignContent: Alignment.Top }) {

          IconView({
            isChange: this.isChange,
            marginSpace: this.marginSpace,
            opacity1: this.opacity1
          })

          Scroll(this.scroller2) {
            BottomView({
              ratio: this.ratio,
              opacity2: this.opacity2,
              height2: this.height2,
              marginTop: this.marginTop
            })
          }
          .width("100%")
          .scrollBar(BarState.Off)
          // TODO: 知识点：嵌套滚动选项。设置向前向后两个方向上的嵌套滚动模式，实现与父组件的滚动联动。
          .nestedScroll({
            scrollForward: NestedScrollMode.PARENT_FIRST, // 可滚动组件往末尾端滚动时的嵌套滚动选项,父组件先滚动，父组件滚动到边缘以后自身滚动。
            scrollBackward: NestedScrollMode.SELF_FIRST // 可滚动组件往起始端滚动时的嵌套滚动选项,自身先滚动，自身滚动到边缘以后父组件滚动。
          })
          .onScroll(() => {
            // TODO: 知识点: Scroll组件绑定onScroll事件，然后在此方法里改变该组件的margin和opacity属性值的大小实现组件移动和隐显
            // 性能知识点: onScroll属于频繁回调，不建议在onScroll做耗时和冗余操作
            const yOffset: number = this.scroller2.currentOffset().yOffset
            this.height2 = this.height2Raw - yOffset * 0.5

            // 根据yOffset的偏移量来设置IconList2的透明度，当偏移量大于等于IconList2原始高度就是透明的。
            if (1 - yOffset / this.IconList2Raw >= 0) {
              this.opacity2 = 1 - yOffset / this.IconList2Raw; // IconList2的透明度
            } else {
              this.opacity2 = 0;
            }
            // 巧妙利用IconList2的透明度的值opacity2来设置IconList2的缩放。
            this.ratio = this.opacity2;
            // 根据yOffset的偏移量来设置IconList1的透明度和IconList3的间距，当偏移量大于等于IconList1原始高度就是透明的同时IconList3的间距也是最小的。
            if (1 - yOffset / this.IconList1Raw > 0) {
              this.isChange = false;
              this.opacity1 = 1 - yOffset / this.IconList1Raw; // IconList1的透明度
              this.marginSpace = this.maxMarginSpace; // IconList3默认间距
            } else {
              this.isChange = true;
              this.opacity1 = (yOffset - this.IconList1Raw) / this.maxMarginSpace; // IconList1的透明度
              this.marginSpace = this.IconList3Raw - yOffset > this.minMarginSpace ?
                (this.IconList3Raw - yOffset) : this.minMarginSpace; // IconList3的间距
            }
          })
        }
      }
      .height("100%")
      .width("100%")
      .margin({ top: 50 }) // 不遮挡搜索栏
    }
    .padding({ left: 12, right: 12 })
    .width("100%")
    .height("100%")
    .scrollBar(BarState.Off)
    .onScroll(() => {
      // 获取滑动距离
      const yOffset: number = this.scroller.currentOffset().yOffset
      // this.searchHeight 随 yOffset变化的公式。按需调整。
      this.searchHeight = this.searchHeightRaw - yOffset * 0.6
    })
  }
}

@Component
struct SearchView {
  @Prop searchHeight: number;

  build() {
    Row() {
      Image($r("app.media.component_stack_search"))
        .width(20)
        .aspectRatio(1)
        .margin({ left: 20 })

      Text("好物精选")
        .opacity(OPACITY)
        .fontColor(Color.Black)
        .fontSize(16)
        .margin({ left: 10 })
    }
    .width("100%")
    .height(this.searchHeight)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .onClick(() => {
      MToast.showToast("搜索栏点击了")
    })
  }
}

@Component
struct IconView {
  @Prop isChange: boolean; // 改变快截图标区域1的组件
  @Prop opacity1: number; // 快截图标区域1的透明度
  @Prop marginSpace: number; // 快截图标区域3 左右之间间隔

  build() {
    if (this.isChange) {
      Row() {
        IconList3({ marginSpace: this.marginSpace })
          .backgroundColor("#f1f3f5")
          .width("100%")
          .height(110)
          .opacity(this.opacity1)// TODO: 知识点：组件的Z序，设置组件的堆叠顺序，zIndex值越大，显示层级越高。
          .zIndex(ZINDEX)
      }
    } else {
      Row() {
        IconList1()
      }
      .width('100%')
      .height(200)
      .opacity(this.opacity1)
    }
  }
}

@Component
struct BottomView {
  @Prop opacity2: number; // 快截图标区域2 透明度
  @Prop ratio: number; // 快截图标区域2 缩小比例
  @Prop height2: number; // 快截图标区域2 高度
  @Prop marginTop: number; // 快截图标区域2 顶部偏移量
  @StorageLink('statusHeight') statusHeight: number = 0; // 状态栏的高度
  @StorageLink('bottomHeight') bottomHeight: number = 0; // 底部安全区高度
  @StorageLink('screenHeight') screenHeight: number = 0; // 当前窗口高度

  build() {
    Column() {
      Row() {
        IconList2({ ratio: this.ratio })
      }
      .width("100%")
      .height(this.height2)
      .opacity(this.opacity2)

      // 商品列表组件
      ProductList()
        .width('100%')
        .height(px2vp(this.screenHeight - this.statusHeight - this.bottomHeight) - USED_HEIGHT)
    }
    .margin({ top: this.marginTop })
  }
}