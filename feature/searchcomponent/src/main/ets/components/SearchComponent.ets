/**
 * @Author: xwang
 * @Date: 2024/7/8 14:37
 * @Description:
 **/
import { curves, display, promptAction, ShowDialogSuccessResponse, window } from '@kit.ArkUI';
import { SceneModuleInfo } from '@ohos/functionalscenes';
import { common } from '@kit.AbilityKit';
import { MToast } from '@same/common';
import { inputMethod } from '@kit.IMEKit';
import { DynamicsRouter } from '@ohos/dynamicsRouter';

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
  @State searchContext: string = ""; // 搜索输入内容
  @StorageLink('context') UIContext: common.UIAbilityContext | undefined = AppStorage.get('context');
  @State screenWidth: number = 0;
  @StorageLink('listData') searchListData: SceneModuleInfo[] | undefined = AppStorage.get('listData'); // 搜索原始数据
  @StorageLink('searchHistoryData') searchHistoryData: SceneModuleInfo[] = []; // 搜索历史数组

  aboutToAppear(): void {
    const type = window.AvoidAreaType.TYPE_SYSTEM
    window.getLastWindow(this.UIContext, (err, data) => {
      if (data !== undefined) {
        let avoidArea = data.getWindowAvoidArea(type)
        this.avoidAreaHeight = avoidArea.topRect.height
      }
    })
    display.getAllDisplays((err, data: Array<display.Display>) => {
      if (data !== undefined && data[0] !== undefined) {
        this.screenWidth = data[0].width
      }
    })
  }

  @Builder
  searchPage() {
    Column() {
      Row() {
        Row() {
          Image($r("app.media.search_component_arrow_left"))
            .width(24)
            .onClick(() => {
              this.onArrowClicked()
            })// TODO：知识点：通过transition属性配置转场参数，在组件插入和删除时显示过渡动效
            .transition(TransitionEffect.asymmetric(
              TransitionEffect.opacity(0)
                .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 200, delay: 150 }),
              TransitionEffect.opacity(0)
                .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 200 })
            ))
        }
        .justifyContent(FlexAlign.Center)
        .width(40)
        .height(40)
        .borderRadius(100)
        .backgroundColor("e5e7e9")

        // TODO：知识点：使用搜索框组件，不需要自己进行封装搜索样式
        Search({ value: this.searchContext, placeholder: "搜索2" })
          .textFont({ weight: 500 })
          .searchButton("搜索3", { fontSize: 14 })
          .defaultFocus(true)// 默认获取焦点拉起键盘
          .backgroundColor("#E7E9E8")
          .onChange((value: string) => {
            this.searchFunc(value)
          })
          .borderRadius(24)
          .geometryTransition(this.geometryId, { follow: true })
          .width(302)
          .height(40)
          .margin({ left: 8 })
          .backgroundColor("#E7E9E8")
      }
      .padding({
        left: 17,
        right: 17
      })
      .alignSelf(ItemAlign.Start)

      //搜索历史
      Column() {
        // 搜索历史标题区
        Row() {
          Text("搜索历史")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          Blank()
          Image($r('app.media.search_component_ic_public_delete'))
            .width(20)
            .onClick(() => {
              // 清空历史记录-确认弹框
              promptAction.showDialog({
                message: "确认删除全部历史记录",
                alignment: DialogAlignment.Center,
                buttons: [
                  {
                    text: "取消",
                    color: "#0000FF"
                  },
                  {
                    text: "确认",
                    color: "#0000FF"
                  }
                ]
              }).then((data: ShowDialogSuccessResponse) => {
                // 点击删除
                if (data.index === 1) {
                  this.searchHistoryData = [];
                }
              })
            })
        }
        .visibility(this.searchHistoryData.length === 0 || this.searchContext.length !== 0 ||
          this.searchNewListData.length !== 0 ? Visibility.None : Visibility.Visible) // 没有搜索历史时隐藏
        .height(20)
        .width('100%')
        .margin({ top: 16 })

        //搜索历史内容区
        Scroll() {
          Flex({ wrap: FlexWrap.Wrap }) {
            // 首次进入页面就需要全部加载不需要使用LazyForeach懒加载
            ForEach(this.searchHistoryData, (item: SceneModuleInfo) => {
              Column() {
                Text(item.name)
                  .fontSize(14)
                  .backgroundColor("#F5F6F8")
                  .padding(6)
                  .borderRadius(8)
              }
              .margin({ top: 10 })
              .padding({ right: 12 })
              .onClick(() => {
                // 点击历史记录直接跳转到指定范例
                this.onItemClicked();
                // 调用动态路由相关方法实现页面跳转
                DynamicsRouter.pushUri(item.appUri, item.param);
                // 点击的项提到历史记录的最前面
                this.searchHistoryData.map((historyItem, index) => {
                  if (historyItem === item) {
                    this.searchHistoryData.unshift(this.searchHistoryData.splice(index, 1)[0]);
                  }
                })
              })
            })
          }
          .margin({ top: 6 })
        }
        .scrollBar(BarState.Off) // 滚动条常驻不显示
        .align(Alignment.TopStart)
        .visibility(this.searchHistoryData.length === 0 || this.searchContext.length !== 0 ||
          this.searchNewListData.length !== 0 ? Visibility.None : Visibility.Visible) // 没有搜索历史时隐藏
        .height(680)
        .onTouch((event) => {
          switch (event.type) {
            case TouchType.Down:
              this.onTouchDown(event);
              break;
          }
          event.stopPropagation(); // 阻止冒泡
        })
      }
      .padding({
        left: 12,
        right: 12
      })
      .alignItems(HorizontalAlign.Start)
      // TODO：知识点：通过transition属性配置转场参数，在组件插入和删除时显示过渡动效。非对称对称转场，第一个为出现动效有150的延迟，第二个为消失动效
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.opacity(0)
          .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 350 })
          .combine(TransitionEffect.translate({ y: 30 })),
        TransitionEffect.opacity(0)
          .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 350 })
          .combine(TransitionEffect.translate({ y: 30 })),))

      List() {
        // TODO：知识点：使用LazyForEach加载搜索结果列表，可以按需加载，解决一次性加载全部列表数据引起的卡顿问题，提高页面响应速度
        ForEach(this.searchNewListData, (item: SceneModuleInfo) => {
          ListItem() {
            Column() {
              Row() {
                Image($r("app.media.search_component_search"))
                  .width(16)
                  .height(16)

                Text(item.name)
                  .fontWeight(500)
                  .fontSize(16)
                  .opacity(0.9)
                  .margin({ left: 12 })
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width("100%")
          .margin({ top: 16 })
          .onClick(() => {
            if (!this.searchHistoryData.includes(item)) {
              // 更新搜索历史数据,插入数组最前侧
              this.searchHistoryData.unshift(item);
            } else {
              this.searchHistoryData.map((historyItem, index) => {
                if (historyItem === item) {
                  this.searchHistoryData.unshift(this.searchHistoryData.splice(index, 1)[0])
                }
              })
            }
            this.onItemClicked();
            // 调用动态路由相关方法实现页面跳转
            DynamicsRouter.pushUri(item.appUri, item.param);
          })
        }, (item: SceneModuleInfo) => JSON.stringify(item))
      }
      .onTouch((event) => {
        switch (event.type) {
          case TouchType.Down:
            this.onTouchDown(event)
            break
        }
        event.stopPropagation
      })
      .height(720)
      .margin({
        left: 30,
        right: 30
      })
      .edgeEffect(EdgeEffect.Spring)
      .sticky(StickyStyle.Header)
      .chainAnimation(false)
      .transition({ opacity: 0 })
      .scrollBar(BarState.Off)
    }
    .transition(TransitionEffect.opacity(0))
    .backgroundColor(Color.White)
    .padding({
      top: px2vp(this.avoidAreaHeight)
    })
    .width("100%")
    .height("120%")
  }

  // 点击提示列表/历史记录进入范例页
  private onItemClicked(): void {
    this.geometryId = 'search';
    animateTo({
      curve: Curve.Ease,
      duration: 20
    }, () => {
      this.searchNewListData = [];
      this.isSearchPageShow = false;
    })
  }

  /**
   * 当开始滑动搜索列表、点击历史搜索空白部分关闭键盘
   * @param event 触屏事件
   */
  private onTouchDown(event: TouchEvent): void {
    let inputMethodController = inputMethod.getController();
    inputMethodController.stopInputSession()
  }

  /**
   * 搜索逻辑
   * @param value:输入框输入的内容
   */
  searchFunc(value: string) {
    let newListData: SceneModuleInfo[] = []
    if (this.searchListData !== undefined) {
      for (let i = 0; i < this.searchListData.length; i++) {
        // 通过includes对输入的字符进行查询
        if (this.searchListData[i].name.toLowerCase().includes(value.toLowerCase())) {
          newListData.push(this.searchListData[i]);
        }
      }
    }
    if (value !== '' && newListData.length === 0) {
      MToast.showToast("暂无查询内容")
    }
    // 判断是否有输入的值
    if (value.length !== 0) {
      this.searchNewListData = newListData;
    } else {
      this.searchNewListData = [];
    }
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
      Search({ placeholder: "搜索1" })
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