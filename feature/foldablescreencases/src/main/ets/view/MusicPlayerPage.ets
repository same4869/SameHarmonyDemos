import { display, window } from '@kit.ArkUI'
import { AppRouter } from '@ohos/dynamicsRouter';
import { MLog } from '@same/common';
import CommonConstants from '../common/CommonConstants'
import { MusicPlayerInfoComp } from '../components/MusicPlayerInfoComp';
import { MusicModel } from '../model/MusicModel';
import WindowModel from '../model/WindowModel';
import { MusicPlayerViewModel } from '../vm/MusicPlayViewModel';

/**
 * 音乐播放器页面
 * 实现步骤：
 * 1.通过display的isFoldable接口区分折叠屏和非折叠屏
 * 2.通过监听display的foldStatusChange，将折叠屏状态分发给各子组件
 * 3.折叠屏设备使用FolderStack容器组件实现，指定子组件在折叠屏悬停态，移到上屏的能力
 */

@AppRouter({ name: "foldablescreencases/MusicPlayerPage" })
@Component
export struct MusicPlayerPage {
  // 当前播放音乐数据模型
  @State musicModel: MusicModel = new MusicModel(CommonConstants.TEST_MUSIC_INFO);
  // 当前折叠屏状态（若当前为折叠屏设备才有效）
  @State curFoldStatus: display.FoldStatus = display.getFoldStatus();
  // 窗口管理model
  private windowModel: WindowModel = new WindowModel();
  // 当前页面的vm实例
  @Provide('musicPlayerViewModel') viewModel: MusicPlayerViewModel = new MusicPlayerViewModel();

  // 通用样式
  @Styles
  stackStyle() {
    .height("100%")
    .width("100%")
    .backgroundImage(this.musicModel.cover)
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
  }
  
  aboutToAppear(): void {
    // 初始化窗口管理model
    const windowStage: window.WindowStage | undefined = AppStorage.get('windowStage');
    // 没有windowStage将无法执行下列逻辑
    if (!windowStage) {
      MLog.warn('MusicPlayerPage', 'windowStage init error!');
      return;
    }

    // 初始化windowModel中的windowStage实例
    this.windowModel.setWindowStage(windowStage);
    // 初始化音乐播放器页面沉浸式展示
    this.windowModel.setMainWindowImmersive(true);
    // 折叠屏设备，音乐播放器页面的窗口属性初始化
    if (display.isFoldable()) {
      // 根据当前折叠屏状态修改窗口显示方向
      this.windowModel.updateMainWinPreferredOrientation();
      // 监听折叠屏状态变更，更新折叠态，修改窗口显示方向
      display.on('foldStatusChange', (curFoldStatus: display.FoldStatus) => {
        this.curFoldStatus = curFoldStatus;
        this.windowModel.updateMainWinPreferredOrientation(curFoldStatus);
      })
    }

    // vm配置歌曲数据
    this.viewModel.musicModel = this.musicModel;
  }

  build() {
    if (display.isFoldable()) {
      // TODO：知识点：FolderStack继承于Stack控件，通过upperItems字段识别指定id的组件，自动避让折叠屏折痕区后移到上半屏
      FolderStack({ upperItems: [CommonConstants.FOLDER_STACK_UP_COMP_ID] }) {
        MusicPlayerInfoComp({ musicModel: this.musicModel, curFoldStatus: this.curFoldStatus })
          .id(CommonConstants.FOLDER_STACK_UP_COMP_ID)
      }
      // TODO：知识点：是否使用默认动效
      .enableAnimation(false)
      // TODO：知识点：是否开启自动旋转，仅在系统自动旋转关闭时该属性生效
      .autoHalfFold(false)
      // TODO：知识点：folderStack如果不撑满页面全屏，作为普通Stack使用
      .stackStyle()
      .alignContent(Alignment.Bottom)
    } else {
      Stack() {
        MusicPlayerInfoComp({ musicModel: this.musicModel })
      }
      .stackStyle()
      .alignContent(Alignment.Bottom)
    }
  }
}