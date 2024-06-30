/**
 * 时间显示builder函数参数接口
 */
import CommonConstants from '../common/CommonConstants'
import { MusicPlayerViewModel } from '../vm/MusicPlayViewModel';

interface ShowTimeBuilderParam {
  str: string
}

/**
 * 控制按钮builder函数参数接口
 */
interface CtrlBtnBuilderParam {
  imgSrc: Resource,
  btnSize: number,
  callback: Function,
  needBackground?: boolean
}

@Component
export struct MusicPlayerCtrlComp {
  // 当前页面的vm实例
  @Consume('musicPlayerViewModel') viewModel: MusicPlayerViewModel;

  // 音乐当前播放时间和总时间显示
  @Builder
  showTimeBuilder($$: ShowTimeBuilderParam) {
    Text($$.str)
      .fontSize(10)
      .fontColor(Color.White)
      .maxLines(CommonConstants.MUSIC_TIME_MAX_LINES)
      .textOverflow({ overflow: TextOverflow.Clip })
      .flexShrink(CommonConstants.MUSIC_TIME_FLEX_SHRINK)
  }

  // 播放器控制按钮
  @Builder
  ctrlBtnBuilder($$: CtrlBtnBuilderParam) {
    Button({ type: ButtonType.Circle, stateEffect: true, buttonStyle: ButtonStyleMode.TEXTUAL }) {
      Image($$.imgSrc)
        .width($$.btnSize)
        .height($$.btnSize)
        .fillColor(Color.White)
        .flexShrink(CommonConstants.MUSIC_CTRL_BTN_FLEX_SHRINK)
    }
    .onClick(() => {
      $$.callback();
    })
    .backgroundColor($$.needBackground ? Color.Gray : '#00000000')
    .padding($$.needBackground ? 10 : 0)
  }

  aboutToAppear(): void {
    this.viewModel.init();
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        this.showTimeBuilder({ str: this.viewModel.curTimeStr })
        Slider({
          value: this.viewModel.curProgress,
          min: CommonConstants.MUSIC_SLIDER_MIN,
          max: CommonConstants.MUSIC_SLIDER_MAX,
          style: SliderStyle.InSet
        })
          .selectedColor(Color.Gray)
          .trackThickness(5)
          .onChange((value: number, mode: SliderChangeMode) => {
            if (!this.viewModel.musicModel) {
              return;
            }

            // 当前进度到达最大进度时，不响应onChange事件
            if (this.viewModel.curProgress >= CommonConstants.MUSIC_SLIDER_MAX) {
              return;
            }

            // slider由于鼠标或手势开始进行变化时，禁止进度条通过avplayer同步进度
            if (mode === SliderChangeMode.Begin) {
              this.viewModel.progressLock = true;
            }

            // 计算滑动条拖动到的地方，对应的时间值
            const toTime = this.viewModel.musicModel.totalTime * value / CommonConstants.MUSIC_SLIDER_MAX;
            // 更新当前拖动到的时间值
            this.viewModel.updateCurTime(toTime);
            // 播放器seek到指定时间
            if (mode === SliderChangeMode.End) {
              this.viewModel.seek(toTime);
            }
          })
        this.showTimeBuilder({ str: this.viewModel.totalTimeStr })
      }
      .margin(10)
      .width("90%")

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        // 播放模式切换按钮
        this.ctrlBtnBuilder({
          imgSrc: $r('app.media.foldable_screen_cases_order_play'),
          btnSize: CommonConstants.MUSIC_PLAYER_CTRL_BTN_SIZE_COMMON,
          callback: () => {
            this.viewModel.showTodoToast();
            // TODO：需求：播放模式切换逻辑
          }
        });
        // 切换到前一首歌曲按钮
        this.ctrlBtnBuilder({
          imgSrc: $r('app.media.foldable_screen_cases_play_last'),
          btnSize: CommonConstants.MUSIC_PLAYER_CTRL_BTN_SIZE_COMMON,
          callback: () => {
            this.viewModel.showTodoToast();
            // TODO：需求：切换到前一首歌曲逻辑
          }
        });
        // 播放、暂停按钮
        this.ctrlBtnBuilder({
          imgSrc: this.viewModel.curPlayerState === CommonConstants.AVPLAYER_STATE_PLAYING ?
          $r('app.media.foldable_screen_cases_pause') : $r('app.media.foldable_screen_cases_play'),
          btnSize: CommonConstants.MUSIC_PLAYER_CTRL_BTN_SIZE_BIG,
          callback: () => {
            if (this.viewModel.curPlayerState === CommonConstants.AVPLAYER_STATE_IDLE) {
              this.viewModel.play();
            } else if (this.viewModel.curPlayerState === CommonConstants.AVPLAYER_STATE_PLAYING) {
              this.viewModel.pause();
            } else {
              this.viewModel.resume();
            }
          },
          needBackground: true
        });
        // 切换到后一首歌曲按钮
        this.ctrlBtnBuilder({
          imgSrc: $r('app.media.foldable_screen_cases_play_next'),
          btnSize: CommonConstants.MUSIC_PLAYER_CTRL_BTN_SIZE_COMMON,
          callback: () => {
            this.viewModel.showTodoToast();
            // TODO：需求：切换到后一首歌曲逻辑
          }
        });
        // 其他功能菜单按钮
        this.ctrlBtnBuilder({
          imgSrc: $r('app.media.foldable_screen_cases_drawer'),
          btnSize: CommonConstants.MUSIC_PLAYER_CTRL_BTN_SIZE_COMMON,
          callback: () => {
            this.viewModel.showTodoToast();
            // TODO：需求：其他功能菜单逻辑
          }
        });
      }
      .margin({
        top: 30,
        bottom: 40
      })
      .width("90%")
    }
  }
}