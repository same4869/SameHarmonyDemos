import { AppRouter } from '@ohos/dynamicsRouter';
import { HomeTop, ImageMapView, SettingItemView, StatusHead } from '../component/Compontent';
import { CommonConstants } from '../constants/CommonConstants';
import { SettingItem } from '../util/dataSource';
import WindowModel from '../util/WindowModel';
import { promptAction, window } from '@kit.ArkUI';

@AppRouter({
  name: "bottomdrawerslidecase/bottomdrawerslidecase"
})
@Component
export struct bottomdrawerslidecase {
  @State bottomAvoidHeight: number = 0; //底部导航条高度
  private listScroller = new ListScroller(); // list滚动控制器
  @State listHeight: number = 0; // list高度
  @State windowHeight: number = 0; // window高度
  @State statusBarHeight: number = 0; // 顶部状态栏高度
  private yStart: number = 0; // list触摸事件起始纵坐标
  private windowModel: WindowModel = WindowModel.getInstance(); // 窗口管理model
  @State isScroll: boolean = false; // list是否可以滚动
  @State isUp: boolean = true; // list是否向上滑动
  @State isShow: boolean = false; // 顶部遮蔽导航栏区域是否显示
  @State listItem: SettingItem[] = [
    new SettingItem('list_item_id_first'),
    new SettingItem('list_item_id_second'),
    new SettingItem('list_item_id_third'),
    new SettingItem('list_item_id_fourth'),
    new SettingItem('list_item_id_fifth'),
    new SettingItem('list_item_id_sixth'),
    new SettingItem('list_item_id_seventh'),
    new SettingItem('list_item_id_eighth'),
  ]; // list内容项
  @State firstListItemHeight: number = 195; // 列表第一个item高度
  @State secondListItemHeight: number = this.bottomAvoidHeight + 150; // 列表第二个item高度
  @State itemNumber: number = 0; // 列表显示第一项
  @State positionY: number = 0; // 列表的Y轴偏移量

  aboutToAppear(): void {
    // 初始化窗口管理model
    const windowStage: window.WindowStage | undefined = AppStorage.get('windowStage');

    // 没有windowStage将无法执行下列逻辑
    if (!windowStage) {
      return;
    }
    this.windowModel.setWindowStage(windowStage);

    // 设置沉浸模式
    this.windowModel.setMainWindowImmersive(true);

    // 获取顶部导航栏高度
    this.windowModel.getStatusBarHeight((statusBarHeight) => {
      this.statusBarHeight = px2vp(statusBarHeight);
    })

    // 获取底部导航条高度
    this.windowModel.getBottomAvoidHeight((bottomAvoidHeight) => {
      this.bottomAvoidHeight = px2vp(bottomAvoidHeight) / 2;
    })

    // 获取窗口高度
    this.windowModel.getWindowHeight().then(s => {
      this.windowHeight = s;
    })

    // 底部list初始显示高度
    this.listHeight = this.firstListItemHeight;
  }

  aboutToDisappear(): void {
    // 关闭沉浸模式
    this.windowModel.setMainWindowImmersive(false);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      RelativeContainer() {
        ImageMapView()
          .id("map")

        // 地图顶部标题栏
        HomeTop({ statusBarHeight: this.statusBarHeight })
          .alignRules({
            'top': { 'anchor': '__container', 'align': VerticalAlign.Top },
            'left': { 'anchor': '__container', 'align': HorizontalAlign.Start },
            'right': { 'anchor': '__container', 'align': HorizontalAlign.End },
          })
          .id('title_bar')

        // list上部的标题栏
        this.itemHead('安全出行季')

        // 底部可变分阶段滑动列表
        List({ scroller: this.listScroller }) {
          ListItem() {
            Column() {
              Row() {
                Text($r("app.string.bottomdrawerslidecase_set_out"))
                  .fontSize($r("app.integer.bottomdrawerslidecase_number_15"))
                Text($r("app.string.bottomdrawerslidecase_destination_new"))
                  .fontSize($r("app.integer.bottomdrawerslidecase_number_15"))
                  .fontColor(Color.Green)
                Text($r("app.string.bottomdrawerslidecase_get_on_the_car"))
                  .fontSize($r("app.integer.bottomdrawerslidecase_number_15"))
              }
              .margin({ left: $r("app.integer.bottomdrawerslidecase_number_10") })
              .height($r("app.integer.bottomdrawerslidecase_height_50"))
              .width('100%')

              Text($r("app.string.bottomdrawerslidecase_please_destination"))
                .padding({ left: $r("app.integer.bottomdrawerslidecase_number_10") })
                .fontSize($r("app.integer.bottomdrawerslidecase_number_20"))
                .fontWeight(2)
                .height($r("app.integer.bottomdrawerslidecase_number_60"))
                .backgroundColor($r("app.color.bottomdrawerslidecase_list_first_backgroundcolor"))
                .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
                .width('100%')
                .onClick(() => {
                  promptAction.showToast({
                    message: $r("app.string.bottomdrawerslidecase_promotion"),
                    duration: 2000
                  })
                })
            }
            .height('80%')
            .width('90%')
            .padding({
              left: $r("app.integer.bottomdrawerslidecase_number_15"),
              right: $r("app.integer.bottomdrawerslidecase_number_15")
            })
            .justifyContent(FlexAlign.Center)
            .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
            .shadow({
              radius: $r("app.integer.bottomdrawerslidecase_number_30"), // 阴影模糊半径
              color: $r("app.color.bottomdrawerslidecase_list_first_backgroundcolor"),
              offsetY: $r("app.integer.bottomdrawerslidecase_number_5") // Y轴偏移量
            })
          }
          .borderRadius({ topLeft: 15, topRight: 15 })
          .width(CommonConstants.FULL_SIZE)
          .height(this.firstListItemHeight)
          .backgroundColor(Color.White)

          /* 性能知识点：此处列表，列表项确定且数量较少，使用了ForEach，在列表项多的情况下，推荐使用LazyForeEach
          *文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609
          */
          ForEach(this.listItem, (item: SettingItem) => {
            ListItem() {
              SettingItemView({ bottomAvoidHeight: this.bottomAvoidHeight })
            }
            .backgroundColor(Color.White)
            .width(CommonConstants.FULL_SIZE)
          }, (item: SettingItem) => item.id.toString())
        }
        .id('scrollPart')
        .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
        .scrollBar(BarState.Off) // 滚动条不显示
        .edgeEffect(EdgeEffect.None) // list滑动到顶部和底部效果
        .width(CommonConstants.FULL_SIZE)
        .height(this.listHeight)
        .alignRules({
          'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
          'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start },
          'right': { 'anchor': '__container__', 'align': HorizontalAlign.End },
        })
        .onReachStart(() => {
          this.itemNumber = 0;
        })
        .onScrollIndex((start: number) => {
          this.itemNumber = start;
        })
        .backgroundColor(Color.White)
        .margin({
          left: $r("app.integer.bottomdrawerslidecase_height_10"),
          right: $r("app.integer.bottomdrawerslidecase_height_10")
        })
        .sticky(StickyStyle.None) // 列表吸顶效果
        .enableScrollInteraction(this.isScroll)
        .offset({ y: this.positionY })
        .onTouch((event: TouchEvent) => {
          switch (event.type) {
          // 手指按下触摸屏幕
            case TouchType.Down: {
              this.yStart = event.touches[0].y;
              break;
            }
          // 手指在屏幕滑动
            case TouchType.Move: {
              const yEnd = event.touches[0].y; // 手指离开屏幕的纵坐标
              const height = Math.abs(Math.abs(yEnd) - Math.abs(this.yStart)); // 手指在屏幕上的滑动距离
              const maxHeight = this.windowHeight - this.statusBarHeight - CommonConstants.LIST_HEADER_HEIGHT; // 设置list最大高度
              // 判断上滑，且list跟随手势滑动
              if (yEnd <= this.yStart) {
                this.isUp = true;
                const temHeight = this.listHeight + height;
                if (temHeight >= maxHeight) {
                  this.isScroll = true;
                  this.isShow = true;
                  this.listHeight = maxHeight;
                } else {
                  this.isScroll = false;
                  this.listHeight = temHeight;
                }
              }
              // 判断下滑，且list跟随手势滑动
              else {
                this.isUp = false;
                const temHeight = this.listHeight - height;
                if (this.itemNumber === 0) {
                  // 列表高度随滑动高度变化
                  this.listHeight = temHeight;
                } else {
                  this.listHeight = maxHeight;
                }
              }
              this.yStart = event.touches[0].y;
              break;
            }

          // 手指离开屏幕
            case TouchType.Up: {
              const maxHeight = this.windowHeight - this.statusBarHeight - CommonConstants.LIST_HEADER_HEIGHT; // 设置list最大高度
              // 列表上滑时，分阶段滑动
              if (this.isUp) {
                // 分阶段滑动，当list高度位于第一个item和第二个item之间时，滑动到第二个item
                if (this.listHeight > this.firstListItemHeight && this.listHeight <= this.firstListItemHeight + this.bottomAvoidHeight + this.secondListItemHeight) {
                  this.listHeight = +this.firstListItemHeight + this.secondListItemHeight;
                  this.isScroll = false;
                  this.isShow = false;
                  return;
                }
                // 分阶段滑动，当list高度位于顶部和第二个item之间时，滑动到页面顶部
                else if (this.firstListItemHeight + this.bottomAvoidHeight + this.secondListItemHeight < this.listHeight && this.listHeight <= maxHeight) {
                  this.listHeight = maxHeight;
                  this.isScroll = true;
                  this.isShow = true;
                  return;
                }
              }
              // 列表下滑时，分阶段滑动
              else {
                if (this.listHeight === maxHeight) {
                  this.isShow = true;
                  this.listHeight = maxHeight;
                }
                // 分阶段滑动，当list高度位于顶部和第二个item之间时,滑动到第二个item
                else if (this.listHeight >= this.firstListItemHeight + this.secondListItemHeight && this.listHeight <= maxHeight) {
                  /*                  this.positionY = maxHeight - this.firstListItemHeight - this.secondListItemHeight - this.bottomAvoidHeight;*/
                  this.listHeight = this.firstListItemHeight + this.secondListItemHeight;
                  this.isShow = false;
                  this.isScroll = false;
                  return;
                }
                // 分阶段滑动，当list高度位于第一个item和第二个item之间时，滑动到第一个item
                else if (this.listHeight <= this.firstListItemHeight + this.secondListItemHeight + this.bottomAvoidHeight || this.listHeight <= this.firstListItemHeight) {
                  /*                  this.positionY = maxHeight - this.firstListItemHeight;*/
                  this.listHeight = this.firstListItemHeight;
                  this.isShow = false;
                  this.isScroll = false;
                  return;
                }
              }
            }
          }
        })
        .animation({
          duration: 500, // 动画持续时间，单位毫秒
          curve: Curve.Friction, // 动画曲线
          iterations: 1, // 动画播放次数
          playMode: PlayMode.Normal// 动画播放模式
        })
      }

      // 当列表滑动到第三阶段再向上划，出现的顶部导航栏遮蔽区域
      StatusHead({
        statusBarHeight: this.statusBarHeight,
        topHeaderHeight: CommonConstants.PAGE_HEADER_HEIGHT,
        isShow: this.isShow
      })
    }
    .width(CommonConstants.FULL_SIZE)
    .height(CommonConstants.FULL_SIZE)
  }

  // list上部的标题栏
  @Builder
  itemHead(text: string) {
    Column() {
      Row() {
        Text(text)
          .fontSize($r('app.string.bottomdrawerslidecase_fontsize_15'))
          .fontColor($r("app.color.bottomdrawerslidecase_list_header_text"))
      }
      .shadow({
        radius: $r("app.integer.bottomdrawerslidecase_number_10"), // 阴影模糊半径
        color: $r("app.color.bottomdrawerslidecase_list_header_shadow"),
      })
      .height($r("app.integer.bottomdrawerslidecase_height_50"))
      .width('40%')
      .margin({ left: $r("app.integer.bottomdrawerslidecase_number_30") })
      .backgroundColor($r("app.color.bottomdrawerslidecase_list_header_backgroundcolor"))
      .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
      .padding({ left: $r("app.integer.bottomdrawerslidecase_number_15") })

      Blank()
        .height($r("app.integer.bottomdrawerslidecase_number_10"))
        .backgroundColor(Color.Transparent)
    }
    .id('listHeader')
    .alignRules({
      'bottom': { 'anchor': 'scrollPart', 'align': VerticalAlign.Top },
      'left': { 'anchor': '__container', 'align': HorizontalAlign.Start },
      'right': { 'anchor': '__container', 'align': HorizontalAlign.End },
    })
    .height(CommonConstants.LIST_HEADER_HEIGHT)
    .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
  }
}