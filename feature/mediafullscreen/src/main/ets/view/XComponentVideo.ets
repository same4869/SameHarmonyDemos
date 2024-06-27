import { media } from '@kit.MediaKit';
import { resourceManager } from '@kit.LocalizationKit';
import { audio } from '@kit.AudioKit';
import { MLog } from '@same/common';
import { window } from '@kit.ArkUI';
import { getTimeString } from '../util/TimeTools';

const ASPECT_RATIO: number = 1.77777778; // 元素宽高比
const VIDEO_Z_INDEX: number = 100; // 组件zIndex
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const ANIMATE_DURATION: number = 400; // 动画持续时间
const TIMEOUT_DURATION: number = 200; // 计时器时间
const WINDOW_SYSTEM_BAR: Array<'status' | 'navigation'> = ['navigation', 'status'];
const SPEED_POPUP_LIST_SPACE: number = 20;

// 倍速对象
interface speedObj {
  text: string,
  value: number
};

class AVPlayerConstants {
  // 倍速
  static readonly SPEED_ARRAY: speedObj[] = [
    {
      text: '0.75x', value: 0
    },
    {
      text: '1.0x', value: 1
    },
    {
      text: '1.25x', value: 2
    },
    {
      text: '1.75x', value: 3
    },
    {
      text: '2.0x', value: 4
    }];
}

@Component
export struct XVideoComponent {
  @Link @Watch('createOrFinish') fileName: string; // 视频名称
  @State isFullScreen: boolean = false; // 是否全屏状态
  @Prop videoLocation: Area; // 视频在屏幕中的位置信息
  @State systemHeight: number = 0; // 系统状态栏高度
  private xComponentController: XComponentController = new XComponentController();
  private surfaceID: string | undefined = undefined; // 视频播放器ID
  @Link @Watch('changeOrientation') isLandscape: boolean; // 是否横屏状态
  private avPlayer: media.AVPlayer = {} as media.AVPlayer; // 视频播放器对象
  private isCreate: boolean = false; // 视频播放器是否被创建
  @State @Watch('onChangePlay') isPlaying: boolean = false; // 是否播放状态
  private callbackComplete: () => void = () => { // 播放至结尾状态回调
  };
  private callbackTimeUpdate: (nol: number) => void = (nol: number) => { // 时间上报函数回调
  };
  private callbackBitrateUpdate: (bitrateList: number[]) => void = (bitrateList: number[]) => { // 比特率更新回调
  };
  private callbackErrorUpdate: (error: string) => void = (error: string) => { // 错误状态回调
  };
  @State totalDuration: number = 0; // 视频总时长
  @State currentTime: number = 0; // 视频当前时间
  @State isSpeedShow: boolean = false; // 是否倍速状态
  @State speed: string = '1.0x'; // 倍速大小

  aboutToAppear(): void {
    // 获取系统状态栏高度
    window.getLastWindow(getContext()).then((lastWindow) => {
      const areas = lastWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.systemHeight = px2vp(areas.topRect.height);
    });
    // 设置播放状态
    this.setCompleteCallback(() => {
      MLog.info('completed state called')
      this.isPlaying = !this.isPlaying
    });
    // 时间上报函数
    this.setTimeUpdateCallback((time) => {
      this.currentTime = time
    });
  }

  // 倍速弹框
  @Builder
  speedPopup() {
    List({ space: SPEED_POPUP_LIST_SPACE }) {
      ForEach(AVPlayerConstants.SPEED_ARRAY, (item: speedObj) => {
        ListItem() {
          Row() {
            Text(item.text)
              .fontColor('rgba(255,255,255,0.90)')
              .fontSize(15)
              .onClick(() => {
                if (this.isCreate) {
                  this.avPlayer.setSpeed(item.value);
                }
                this.speed = item.text;
                this.isSpeedShow = false;
              })
          }
          .padding({ left: 10 })
          .width("100%")
          .height(20)
        }
      }, (item: speedObj) => {
        return JSON.stringify(item);
      })
    }
    .width(80)
    .padding(10)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        XComponent({
          id: '',
          type: 'surface',
          controller: this.xComponentController
        })
          .width("100%")
          .aspectRatio(ASPECT_RATIO)
          .onLoad(() => {
            this.surfaceID = this.xComponentController.getXComponentSurfaceId()
          })
      }
      .borderRadius(this.isFullScreen ? 0 : {
        topLeft: 10,
        topRight: 10
      })
      .justifyContent(FlexAlign.Center)
      .width("100%")
      .height("100%")
      .aspectRatio(this.isFullScreen ? -1 : ASPECT_RATIO)
      .layoutWeight(LAYOUT_WEIGHT)
      .backgroundColor(Color.Black)
      .zIndex(0)

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
        // 播放icon
        Image(this.isPlaying ? $r("app.media.media_full_screen_icon_play") :
        $r("app.media.media_full_screen_icon_pause"))
          .width(24)
          .height(24)
          .margin({
            top: 0,
            bottom: 0,
            left: 10,
            right: 10
          })
          .onClick(() => {
            this.isPlaying = !this.isPlaying
          })
        // 时间轴
        Row() {
          Text(getTimeString(this.currentTime))
            .fontSize(16)
            .fontColor(Color.White)
            .fontWeight(500)
            .opacity(0.6)
          Slider({
            value: Math.round(this.currentTime / this.totalDuration * 100)
          })
            .selectedColor(Color.White)
            .layoutWeight(1)
            .trackColor(Color.Gray)
            .onChange((value: number) => {
              if (this.isCreate) {
                this.currentTime = this.totalDuration * value / 100;
                this.avPlayer.seek(this.currentTime);
              }
            })
          Text(getTimeString(this.totalDuration))
            .fontSize(16)
            .fontColor(Color.White)
            .fontWeight(500)
            .opacity(0.6)
        }
        .layoutWeight(1)
        .height(25)

        // 全屏icon
        Image($r("app.media.media_full_screen_icon_large"))
          .width(24)
          .height(24)
          .margin({
            top: 0,
            bottom: 0,
            left: 10,
            right: 10
          })
          .opacity(0.6)
          .onClick(() => {
            this.isLandscape = !this.isLandscape;
          })
        // 倍速icon
        Text(this.speed)
          .fontColor('rgba(255,255,255,0.90)')
          .fontSize(18)
          .fontFamily("HarmonyHeiTi")
          .margin(15)
          .onClick(() => {
            this.isSpeedShow = !this.isSpeedShow;
          })
          .bindPopup(this.isSpeedShow, {
            builder: this.speedPopup,
            placement: Placement.Top,
            popupColor: 'rgba(0,0,0,0.6)'
          })
      }
      .visibility(this.isFullScreen ? Visibility.Visible : Visibility.None)
      .width("100%")
      .height("100%")
      .zIndex(1)
    }
    .visibility(this.fileName !== '' ? Visibility.Visible : Visibility.None)
    .width(this.isFullScreen ? "100%" : this.videoLocation.width)
    .height("100%")
    .aspectRatio(this.isFullScreen ? -1 : ASPECT_RATIO)
    .position(this.isFullScreen ? { x: 0, y: 0 } : {
      x: this.videoLocation.globalPosition.x,
      y: (this.videoLocation.globalPosition.y as number) - this.systemHeight
    })
    .zIndex(VIDEO_Z_INDEX)
  }

  // 视频信息上报函数
  async setSourceInfo(): Promise<void> {
    // 时间上报函数
    this.avPlayer.on('timeUpdate', (time: number) => {
      MLog.info('timeUpdate called: time is :' + time);
      MLog.info('timeUpdate called: currentTime is :' + this.avPlayer.currentTime);
      this.callbackTimeUpdate(time);
    });
    // 音量变化回调函数
    this.avPlayer.on('volumeChange', (vol: number) => {
      MLog.info('volumeChange success,and new volume is :' + vol);
    });
    // 视频播放结束触发回调
    this.avPlayer.on('endOfStream', () => {
      MLog.info('endOfStream success');
    });
    // seek操作回调函数
    this.avPlayer.on('seekDone', (seekDoneTime: number) => {
      MLog.info('seekDone success,and seek time is:' + seekDoneTime);
    });
    // 视频总时长上报函数
    this.avPlayer.on('durationUpdate', (duration: number) => {
      MLog.info('durationUpdate success,and durationUpdate is:' + duration);
    });
    // 设置倍速播放回调函数
    this.avPlayer.on('speedDone', (speed: number) => {
      MLog.info('speedDone success,and speed value is:' + speed);
    });
    // bitrate设置成功回调函数
    this.avPlayer.on('bitrateDone', (bitrate: number) => {
      MLog.info('bitrateDone success,and bitrate value is:' + bitrate);
    });
    // 缓冲上报回调函数
    this.avPlayer.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
      MLog.info('bufferingUpdate success,and infoType value is:' + infoType + ', value is :' + value);
    });
    // 首帧上报回调函数
    this.avPlayer.on('startRenderFrame', () => {
      MLog.info('startRenderFrame success 1');
    });
    // 视频宽高上报回调函数
    this.avPlayer.on('videoSizeChange', (width: number, height: number) => {
      MLog.info('videoSizeChange success,and width is:' + width + ', height is :' + height);
    });
    // 焦点上报回调函数
    this.avPlayer.on('audioInterrupt', (info: audio.InterruptEvent) => {
      // 触发焦点上报后调用暂停接口暂停播放
      MLog.info('audioInterrupt success,and InterruptEvent info is:' + JSON.stringify(info));
    });
    // HLS上报所有支持的比特率
    this.avPlayer.on('availableBitrates', (bitrates: number[]) => {
      MLog.info('availableBitrates success,and availableBitrates length is:' + bitrates.length);
      this.callbackBitrateUpdate(bitrates);
    });
    // 设置错误监听
    this.avPlayer.on('error', (error) => {
      MLog.error('error happened,message is :' + error.message);
      this.callbackErrorUpdate('Error ' + error.code + ' - ' + error.message);
    });
  }

  // 状态机上报回调函数
  async setStateChangeCallback(): Promise<void> {
    this.avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      MLog.info('stateChange callback function is triggered,state is:' + state + ',reason is :' + reason);
      switch (state) {
        case 'idle':
          this.release();
          MLog.info('state idle called');
          break;
        case 'initialized':
          MLog.info('state initialized called');
          this.setSurfaceID();
          this.avPlayer.prepare();
          break;
        case 'prepared':
          MLog.info('state prepared called');
          this.isPlaying = true;
          this.totalDuration = this.avPlayer.duration;
          this.getPlay();
        // 设置全屏播放展开动画
          animateTo({
            duration: ANIMATE_DURATION,
            onFinish: () => {
              this.isLandscape = !this.isLandscape; // 设置横屏
            }
          }, () => {
            this.isFullScreen = !this.isFullScreen;
          });
          break;
        case 'playing':
          MLog.info('state playing called');
          break;
        case 'paused':
          MLog.info('state paused called');
          break;
        case 'completed':
          MLog.info('state completed called');
          this.callbackComplete();
          break;
        case 'stopped':
          MLog.info('state stopped called');
          break;
        case 'released':
          MLog.info('state released called');
          break;
        case 'error':
          MLog.info('state error called');
          break;
        default:
          MLog.info('unknown state :' + state);
          break;
      }
    })
  }

  // TODO 知识点：XComponent和AVPlayer通过surfaceId绑定
  setSurfaceID(): void {
    MLog.info('play video: surfaceID is:' + this.surfaceID);
    this.avPlayer.surfaceId = this.surfaceID;
  }

  setCompleteCallback(func: () => void) {
    this.callbackComplete = func;
  }

  setTimeUpdateCallback(func: (nol: number) => void) {
    this.callbackTimeUpdate = func;
  }

  setBitrateUpdateCallback(func: (bitrateList: number[]) => void) {
    this.callbackBitrateUpdate = func;
  }

  setErrorCallback(func: (error: string) => void) {
    this.callbackErrorUpdate = func;
  }

  // 初始化播放器
  async init(): Promise<void> {
    await this.release()
    const context = getContext(this)
    // 获取fdSrc用于注册AVPlayer
    context.resourceManager.getRawFd(this.fileName).then(async (value: resourceManager.RawFileDescriptor) => {
      this.avPlayer = await media.createAVPlayer()
      this.isCreate = true
      await this.setSourceInfo() // 视频信息上报函数
      await this.setStateChangeCallback()
      this.avPlayer.fdSrc = {
        fd: value.fd,
        offset: value.offset,
        length: value.length
      };
    })
  }

  async release() {
    if (this.isCreate) {
      await this.avPlayer.release()
      this.isCreate = false
      this.isPlaying = false
    }
  }

  getPlay() {
    if (this.isCreate) {
      this.avPlayer.play();
    }
  }

  getPause() {
    if (this.isCreate) {
      this.avPlayer.pause();
    }
  }

  getStop() {
    if (this.isCreate) {
      this.avPlayer.stop();
    }
  }

  createOrFinish() {
    if (this.fileName !== '') {
      this.init()
    } else {
      this.getStop()
      this.release()
    }
  }

  changeOrientation() {
    // 获取UIAbility实例的上下文信息
    let context = getContext(this);
    // 调用该接口手动改变设备横竖屏状态（设置全屏模式，先强制横屏，再加上传感器模式）
    window.getLastWindow(context).then((lastWindow) => {
      if (this.isLandscape) {
        // 设置窗口的布局是否为沉浸式布局
        lastWindow.setWindowLayoutFullScreen(true, () => {
          // 设置窗口全屏模式时导航栏、状态栏的可见模式
          lastWindow.setWindowSystemBarEnable([]);
          // 设置窗口的显示方向属性，AUTO_ROTATION_LANDSCAPE表示传感器自动横向旋转模式
          lastWindow.setPreferredOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE);
        });
      } else {
        // 设置窗口的显示方向属性，UNSPECIFIED表示未定义方向模式，由系统判定
        lastWindow.setPreferredOrientation(window.Orientation.UNSPECIFIED, () => {
          // 设置窗口全屏模式时导航栏、状态栏的可见模式
          lastWindow.setWindowSystemBarEnable(WINDOW_SYSTEM_BAR, () => {
            // 设置窗口的布局是否为沉浸式布局
            lastWindow.setWindowLayoutFullScreen(false, () => {
              setTimeout(() => {
                // 设置退出全屏动画
                animateTo({
                  duration: ANIMATE_DURATION,
                  onFinish: () => {
                    this.fileName = '';
                  }
                }, () => {
                  this.isFullScreen = !this.isFullScreen;
                });
              }, TIMEOUT_DURATION);
            });
          });
        });
      }
    });
  }

  onChangePlay() {
    this.isPlaying ? this.getPlay() : this.getPause();
  }
}