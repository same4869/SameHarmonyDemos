/**
 * @Author: xwang
 * @Date: 2024/6/26 15:53
 * @Description:
 **/
import { AppRouter, DynamicsRouter } from '@ohos/dynamicsRouter/Index';
import { MLog, MockDataUtil } from '@same/common';
import { FlowItemContent, FlowItemContentsData } from '../model/FlowItemContentsData';
import { XVideoComponent } from './XComponentVideo';
import { window } from '@kit.ArkUI';

const ASPECT_RATIO: number = 1.77777778; //元素宽高比
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const JSON_URI: string = 'media_full_screen_mockData.json'; // 获取mock数据的json名称
const WINDOW_SYSTEM_BAR: Array<'status' | 'navigation'> = ['navigation', 'status'];

@AppRouter({ name: "mediafullscreen/MediaFullScreen" })
@Component
export struct MediaFullScreen {
  @Provide pageMediaFullScreen: NavPathStack = new NavPathStack();
  @State selectedVideo: string = ''; // 选择的视频名称
  @State isLandscape: boolean = false; // 是否横屏状态
  @State videoLocation: Area = {
    // 视频在屏幕中的位置信息
    width: 0,
    height: 0,
    position: { x: 0, y: 0 },
    globalPosition: { x: 0, y: 0 }
  };
  @State contentData: FlowItemContentsData = new FlowItemContentsData(); // 瀑布流内容
  @State cachedCountNumber: number = 6; // 懒加载缓存数

  async aboutToAppear() {
    const newModelMockData: Array<FlowItemContent> = MockDataUtil.getMockDataFromJson<FlowItemContent>(JSON_URI)
    MLog.debug(`newModelMockData -> ${newModelMockData}`)
    this.contentData.pushData(newModelMockData);
  }

  async aboutToDisappear() {
    // 销毁组件时恢复window方向
    const currentWindow = await window.getLastWindow(getContext(this));
    currentWindow.setWindowSystemBarEnable(WINDOW_SYSTEM_BAR);
  }

  build() {
    // 应用主页用NavDestination承载，用于显示Navigation的内容区
    Navigation(this.pageMediaFullScreen) {

    }
    .mode(NavigationMode.Stack)
    .onAppear(() => {
      this.pageMediaFullScreen.pushPathByName("MediaFullScreen", null, false)
    })
    // 创建NavDestination组件，需使用此组件的onBackPressed回调拦截返回事件
    .navDestination(this.videoArea)
  }

  @Builder
  videoArea() {
    // 性能知识点: 功能是以har的形式集成在主工程中，没有@Entry修饰的组件，无法使用@Entry组件的onBackPress生命周期函数。
    NavDestination() {
      Column() {
        // 引入自定义视频组件
        XVideoComponent({
          fileName: this.selectedVideo,
          videoLocation: this.videoLocation,
          isLandscape: this.isLandscape
        })
        WaterFlow() {
          // 性能知识点: LazyForEach 懒加载优化，详情请见 https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/lazyforeach_optimization.md/
          LazyForEach(this.contentData, (moment: FlowItemContent) => {
            FlowItem() {
              ReusableComponent({
                moment,
                selectedVideo: this.selectedVideo,
                videoLocation: this.videoLocation
              })
            }.width("100%")
          }, (moment: FlowItemContent) => moment.id)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .cachedCount(this.cachedCountNumber)
        .width("100%")
        .height("100%")
      }
      .backgroundColor("#33182431")
      .height("100%")
      .layoutWeight(1)
    }
    .hideTitleBar(true)
    // TODO：知识点：返回时通过弹窗拦截，点击弹窗不保存按钮直接返回主界面，点击保存按钮将数据写入到preferences实例中，持久化存储数据
    .onBackPressed(() => {
      if (this.selectedVideo === '') {
        DynamicsRouter.popAppRouter()
        return true
      } else {
        this.isLandscape = !this.isLandscape
        return true
      }
    })
  }
}

// 性能知识点: @Reusable复用组件优化，详情请见 https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/component-recycle.md/
@Reusable
@Component
struct ReusableComponent {
  @Prop moment: FlowItemContent;
  @Link selectedVideo: string;
  @Link videoLocation: Area;

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Image($r(`app.media.${this.moment.mediaPreview}`))
          .width("100%")
          .aspectRatio(ASPECT_RATIO)
        Image($r("app.media.media_full_screen_play"))
          .width(40)
          .height(40)
      }
      .onClick((event?: ClickEvent) => {
        if (this.selectedVideo !== '') {
          return
        }
        this.selectedVideo = this.moment.media
        if (event) {
          this.videoLocation = event.target.area
        }
      })

      Text(this.moment.text)
        .lineHeight(22)
        .fontFamily("HarmonyHeiTi")
        .fontWeight(FontWeight.Medium)
        .fontSize(14)
        .fontColor("#182431")
        .padding(10)

      Row() {
        Image($r(`app.media.${this.moment.user.userImage}`))
          .autoResize(false)
          .width(20)
          .height(20)
          .borderRadius(10)
        Text(this.moment.user.userName)
          .fontSize(14)
          .fontColor("#182431")
          .lineHeight(19)
          .fontFamily("HarmonyHeiTi")
          .margin({ left: 8 })
          .layoutWeight(LAYOUT_WEIGHT)
      }
    }
    .shadow({ radius: 3, color: Color.Gray })
    .border({ radius: 10 })
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Start)
  }
}