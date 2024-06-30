import { DynamicsRouter } from '@ohos/dynamicsRouter';
import CommonConstants from '../common/CommonConstants';
import { display, mediaquery } from '@kit.ArkUI';
import { MLog } from '@same/common';
import { MusicModel } from '../model/MusicModel';

@Component
export struct MusicPlayerInfoComp {
  // 音乐模型数据实例
  @Prop musicModel: MusicModel;
  // 歌曲信息组件Flex布局方向
  @State curFlexDirection: FlexDirection = FlexDirection.Row;
  // 歌曲信息组件整体高度百分比
  @State totalHeightPer: string = CommonConstants.MUSIC_INFO_COMP_HEIGHT_COMMON;
  // 歌词子组件外边距
  @State lyricsMargin: Margin = { top: CommonConstants.MUSIC_LYRICS_COMP_MARGIN_TOP_COMMON };
  // 歌词子组件高度百分比
  @State lyricsHeightPer: string = CommonConstants.MUSIC_LYRICS_COMP_HEIGHT_EXPANDED;
  // 歌曲封面图片尺寸
  @State curImgSize: number = CommonConstants.MUSIC_COVER_SIZE_COMMON;
  // 通知Navigation组件隐藏导航栏
  @Consume('isFullScreen') isFullScreen: boolean;
  // 父组件单向绑定的屏幕状态
  @Prop @Watch('updateWithFoldStatus') curFoldStatus: display.FoldStatus;
  // 当前是否横屏状态
  private isLandscape: boolean = false;
  private screenW: number = px2vp(display.getDefaultDisplaySync().width);
  // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  private readonly DEVICESIZE: number = 600;
  // list控制器
  private lyricsScrollerCtrl: Scroller = new Scroller();
  // 属性动画配置
  private attrAniCfg: AnimateParam = {
    duration: 2000,
    curve: Curve.EaseOut,
    iterations: 1,
    playMode: PlayMode.Normal
  }
  private callBack = async (curFoldStatus: display.FoldStatus) => {
    // 同一个状态重复触发不做处理
    if (this.curFoldStatus === curFoldStatus) {
      return;
    }
    // 缓存当前折叠状态
    this.curFoldStatus = curFoldStatus;
    this.hideNavBar(this.curFoldStatus);
  }
  // TODO：知识点：通过媒体查询监听显示屏幕横竖屏方向状态变更
  private landscapeListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(orientation: landscape)');

  aboutToAppear(): void {
    //初始化各组件样子
    this.updateWithFoldStatus()
    if (display.isFoldable()) {
      this.regDisplayListener()
    } else {
      if (this.screenW >= this.DEVICESIZE) {
        this.navigationAnimation(true)
      } else {
        this.navigationAnimation(false)
      }
    }

    //监听媒体查询横屏切换
    this.landscapeListener.on('change', (mediaQueryResult: mediaquery.MediaQueryResult) => {
      this.updateWithOrientation(mediaQueryResult)
    })
  }

  /**
   * 注册屏幕状态监听
   * @returns {void}
   */
  regDisplayListener(): void {
    this.hideNavBar(display.getFoldStatus());
    display.on('foldStatusChange', this.callBack);
  }

  // 隐藏navigation导航栏，设置为全屏。
  navigationAnimation(isFullScreen: boolean): void {
    animateTo({
      duration: CommonConstants.MUSIC_DURATION,
      curve: Curve.EaseInOut,
    }, () => {
      this.isFullScreen = isFullScreen;
    })
  }

  hideNavBar(status: number): void {
    if (status === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.navigationAnimation(false);
    } else {
      this.navigationAnimation(true);
    }
  }

  build() {
    Flex({ direction: this.curFlexDirection }) {
      Image($r("app.media.foldable_screen_cases_back"))
        .width(CommonConstants.MUSIC_PLAYER_CTRL_BTN_SIZE_COMMON)
        .height(CommonConstants.MUSIC_PLAYER_CTRL_BTN_SIZE_COMMON)
        .onClick(() => {
          DynamicsRouter.popAppRouter()
          this.navigationAnimation(false)
          if (display.isFoldable()) {
            display.off('foldStatusChange', this.callBack)
          }
        })
        .position({
          x: 10,
          y: -40
        })
        .fillColor(Color.White)
      Column() {
        Text(this.musicModel.title)
          .fontSize(40)
          .fontColor(Color.White)
        Text(this.musicModel.singer)
          .fontSize(16)
          .fontColor(Color.White)
        Image(this.musicModel.cover)
          .width(this.curImgSize)
          .height(this.curImgSize)
          .margin(20)
          .animation(this.attrAniCfg)
          .interpolation(ImageInterpolation.High)
          .draggable(false)
      }
      .width("100%")
      .height("50%")
      .margin({ top: 10 })

      /**
       * TODO：高性能知识点：歌词列表数据较多，不需要全部渲染上屏，采用LazyForEach，仅渲染可视区域的歌词
       * https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/lazyforeach_optimization.md/
       */
      List({ space: 20, scroller: this.lyricsScrollerCtrl }) {
        LazyForEach(this.musicModel.lyricsInfo, (lyricsLine: string) => {
          ListItem() {
            Text(lyricsLine)
              .width("100%")
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
          }
        })
      }
      .width('100%')
      .height(this.lyricsHeightPer)
      .margin(this.lyricsMargin)
      .scrollBar(BarState.Off)
      .animation(this.attrAniCfg)
    }
    .width("100%")
    .height(this.totalHeightPer)
    .animation(this.attrAniCfg)
  }

  /**
   * 根据折叠态和屏幕方向，修改样式，包括折叠屏设备和非折叠屏设备
   * @param curFoldStatus
   * @returns {void}
   */
  updateWithFoldStatus() {
    // 修改图片尺寸、整个信息组件高度百分比、歌词百分比、歌词和其他信息的布局方向
    if (this.curFoldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      // 折叠屏展开态
      // 使用展开态的属性样式
      MLog.info("The device is currently in the expanded state");
      this.curImgSize = CommonConstants.MUSIC_COVER_SIZE_EXPANDED;
      this.totalHeightPer = CommonConstants.MUSIC_INFO_COMP_HEIGHT_COMMON;
      this.lyricsHeightPer = CommonConstants.MUSIC_LYRICS_COMP_HEIGHT_EXPANDED;
      this.lyricsMargin.top = CommonConstants.MUSIC_LYRICS_COMP_MARGIN_TOP_EXPANDED;
      this.curFlexDirection = FlexDirection.Row;
    } else if (this.curFoldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      // 折叠屏折叠态
      // 使用折叠态的属性样式
      MLog.info("The device is currently in the folded state");
      this.curImgSize = CommonConstants.MUSIC_COVER_SIZE_COMMON;
      this.totalHeightPer = CommonConstants.MUSIC_INFO_COMP_HEIGHT_COMMON;
      this.lyricsHeightPer = CommonConstants.MUSIC_LYRICS_COMP_HEIGHT_COMMON;
      this.lyricsMargin.top = CommonConstants.MUSIC_LYRICS_COMP_MARGIN_TOP_COMMON;
      this.curFlexDirection = FlexDirection.Column;
    } else if (this.curFoldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
      // 折叠屏半折叠态
      MLog.info("The device is currently in the half folded state");
      if (this.isLandscape) {
        // 半折叠态同时横屏
        // 使用半折叠态的属性样式
        this.curImgSize = CommonConstants.MUSIC_COVER_SIZE_HALF_FOLDED;
        this.totalHeightPer = CommonConstants.MUSIC_INFO_COMP_HEIGHT_HALF_FOLDED;
        this.lyricsHeightPer = CommonConstants.MUSIC_LYRICS_COMP_HEIGHT_HALF_FOLDED;
        this.lyricsMargin.top = CommonConstants.MUSIC_LYRICS_COMP_MARGIN_TOP_EXPANDED;
      } else {
        // 半折叠态同时竖屏
        // 使用展开态的属性样式
        this.curImgSize = CommonConstants.MUSIC_COVER_SIZE_EXPANDED;
        this.totalHeightPer = CommonConstants.MUSIC_INFO_COMP_HEIGHT_COMMON;
        this.lyricsHeightPer = CommonConstants.MUSIC_LYRICS_COMP_HEIGHT_EXPANDED;
        this.lyricsMargin.top = CommonConstants.MUSIC_LYRICS_COMP_MARGIN_TOP_EXPANDED;
      }
      this.curFlexDirection = FlexDirection.Row;
    } else {
      // 非折叠屏设备
      // 使用非折叠屏的属性样式
      this.curImgSize = CommonConstants.MUSIC_COVER_SIZE_COMMON;
      this.totalHeightPer = CommonConstants.MUSIC_INFO_COMP_HEIGHT_COMMON;
      this.lyricsHeightPer = CommonConstants.MUSIC_LYRICS_COMP_HEIGHT_COMMON;
      this.lyricsMargin.top = CommonConstants.MUSIC_LYRICS_COMP_MARGIN_TOP_COMMON;
      this.curFlexDirection = FlexDirection.Column;
    }
  }

  /**
   * 屏幕方向变更时，修改展示样式
   * @param mediaQueryResult 媒体查询横屏结论
   * @returns {void}
   */
  updateWithOrientation(mediaQueryResult: mediaquery.MediaQueryResult): void {
    this.isLandscape = mediaQueryResult.matches;
    this.updateWithFoldStatus();
  }
}