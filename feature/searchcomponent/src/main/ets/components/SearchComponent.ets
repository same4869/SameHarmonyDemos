/**
 * @Author: xwang
 * @Date: 2024/7/8 14:37
 * @Description:
 **/
import { curves } from '@kit.ArkUI';
import { SceneModuleInfo } from '@ohos/functionalscenes';

/**
 * 搜索实现思路：
 * 1.在进入首页时存储一份初始数据用于查询时筛选数据。
 * 2.通过输入框onchange接口获取输入框输入的值与ListData中name字段进行对比筛选出符合条件的数据。
 * 3.将筛选获得的数据通过LazyForeach遍历渲染，点击相应的listitem时通过统一封装的接口buildRouterModel进行跳转。
 * 4.跳转后将点击的一条数据通过PersistentStorage.persistProp持久化存储下来，保证应用退出后数据依然存在并且实现搜索历史功能。
 */
/**
 * 一镜到底实现思路：
 * 1.通过bindContentCover全屏模态转场实现对搜索页面显示的控制。
 * 2.通过transition组件内转场实现搜索页面消失显示过程中的过渡效果。
 * 3.通过geometryTransition组件内隐式共享元素转场绑定两个搜索框实现传承过渡。
 * 3.在切换过程中使用animateTo显式动画配合改变搜索框大小实现转换过程中的动画和一镜到底的效果。
 */

@Component
export struct SearchComponent {
  @State isSearchPageShow: boolean = false; // 搜索页面是否显示标志位
  @State avoidAreaHeight: number = 0;
  @State geometryId: string = ''; // 组件内隐式共享元素转场id
  @State searchNewListData: SceneModuleInfo[] = [];
  @State searchContext: string = ''; // 搜索输入内容

  @Builder
  searchPage() {
    Column() {

    }
    .transition(TransitionEffect.opacity(0))
    .backgroundColor(Color.White)
    .padding({
      top: px2vp(this.avoidAreaHeight)
    })
    .width("100%")
    .height("120%")
  }

  /**
   * 1.点击返回箭头，搜索框退出搜索页面animateTo显式动画。
   * 2.两个搜索框同时绑定同一个geometryId。
   */
  private onArrowClicked() {
    this.geometryId = "search"
    animateTo({
      // 构造插值器弹簧曲线对象，生成一条从0到1的动画曲线
      curve: curves.interpolatingSpring(0, 1, 342, 38)
    }, () => {
      this.searchNewListData = [];
      this.isSearchPageShow = false;
    })
  }

  /**
   * 1.搜索框进入搜索页面animateTo显式动画。
   * 2.两个搜索框同时绑定同一个geometryId。
   */
  private onSearchClicked(): void {
    this.geometryId = 'search';
    animateTo({
      duration: 100,
      // 构造插值器弹簧曲线对象，生成一条从0到1的动画曲线
      curve: curves.interpolatingSpring(0, 1, 324, 38)
    }, () => {
      this.isSearchPageShow = true;
    })
  }

  build() {
    Column() {
      Search({ placeholder: "搜索" })
        .backgroundColor(Color.Black)
        .focusOnTouch(false)
        .focusable(false)
        .enableKeyboardOnFocus(false)
        .width(353)
        .height(43)
        .onClick(() => {
          this.onSearchClicked()
        })
        .geometryTransition(this.geometryId, { follow: true })
        .transition(TransitionEffect.OPACITY.animation({
          duration: 200,
          curve: curves.cubicBezierCurve(0.33, 0, 0.57, 1)
        }))
        .backgroundColor("#e7e9e8")
        .borderRadius(24)
    }
    .width("100%")
    // TODO：知识点：通过bindContentCover属性为组件绑定全屏模态页面，在组件插入和删除时可通过设置转场参数ModalTransition显示过渡动效
    .bindContentCover(this.isSearchPageShow, this.searchPage(), {
      modalTransition: ModalTransition.NONE,
      onDisappear: () => {
        this.onArrowClicked()
        this.searchContext = ""
      }
    })
    .alignItems(HorizontalAlign.Center)
  }
}