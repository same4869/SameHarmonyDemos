import { promptAction, window } from '@kit.ArkUI';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { MLog } from '@same/common/Index';
import { GoodsList } from './GoodsList';

const COLUM_SPACE: number = 10; // 各组件间的间隔
const IMAGE_ASPECT_RATIO: number = 1; // 图片的宽高比
const LAYOUT_WEIGHT: number = 1; // 自适应占满父容器Column剩余空间
const OPACITY: number = 0.6; // 字体设置透明度

@Preview
@Component
@Entry({ routeName: 'fitfordarkmode/FitForDarkMode' })
export struct FitForDarMode {
  @State banner: ResourceStr = '';
  // @StorageProp + @Watch 获取并监听当前颜色模式
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: number = 0;

  // @Watch回调函数，监听颜色模式刷新状态变量
  onColorModeChange(): void {
    this.banner = setBanner(this.currentMode);
  }

  build() {
    Column() {
      Column({ space: COLUM_SPACE }) {
        Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          Image($r("app.media.fit_for_dark_mode_logo"))
            .width(32)
            .aspectRatio(IMAGE_ASPECT_RATIO)

          Image($r("app.media.fit_for_dark_mode_scan"))
            .width(32)
            .aspectRatio(IMAGE_ASPECT_RATIO)
            .onClick(() => {
              promptAction.showToast({ message: "扫码，仅演示" });
            })
        }
        .width("100%")
        .height(32)
        .margin({ top: 6 })

        Row() {
          Image($r("app.media.fit_for_dark_mode_search"))
            .width(20)
            .aspectRatio(IMAGE_ASPECT_RATIO)
            .margin({ left: 20 })
          // TODO: 知识点：UI组件颜色属性是固定颜色值，深浅模式颜色不变。
          // 将Text直接设置成'#000000'固定色值
          Text("精品好礼")
            .opacity(OPACITY)
            .fontColor($r("app.color.fit_for_dark_mode_black_font_color"))
            .margin({ left: 20 })
        }
        .width("100%")
        .height(40)
        .backgroundColor("#ffffff")
        .borderRadius(20)
        .onClick(() => {
          promptAction.showToast({ message: "仅演示" })
        })
      }
      .padding({ left: 12, right: 12 })
      // TODO: 知识点：在resources目录下新增dark/element目录，创建深色模式color.json文件，设置深色模式UI组件颜色。（注意事项:颜色name必须相同）
      // 用资源ID方式设置Column背景色。（浅色模式色值为'#FA5A3C'、深色模式色值为'#000000'）
      .backgroundColor($r("app.color.fit_for_dark_mode_column_bg_color"))
      .width("100%")
      .height(100)

      Scroll() {
        Column() {
          Column() {
            // TODO: 知识点：在深浅模式下，UI布局或逻辑存在差异，采用AbilityStage.onConfigurationUpdate监听实现
            Image(this.banner)
              .width("100%")
              .height(160)
              .borderRadius(20)

            Text("新品首发")
              .fontColor("#ffffff")
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .height(45)
              .width("100%")
              .textAlign(TextAlign.Center)
              .padding({ top: 5 })
          }
          .backgroundColor("#fa5a3c")
          .padding({ left: 12, right: 12 })
          .borderRadius({
            bottomLeft: 20,
            bottomRight: 20
          })

          GoodsList()
        }
      }
      .backgroundColor("#e7d9d9")
      .padding({ bottom: 12 })
      .width("100%")
      .height("100%")
      .layoutWeight(LAYOUT_WEIGHT)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
    }
    .backgroundColor("#ffffff")
    .width("100%")
    .height("100%")
  }
}

/**
 * 根据不同的颜色模式来设置banner图和statusBar的背景色
 */
function setBanner(currentMode: number): ResourceStr {
  if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
    // 在当前为深色模式中，确保界面美观且颜色统一，设置导航栏的背景色。
    setStatusBar(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    return $r("app.media.fit_for_dark_mode_dark_mode_banner");
  } else {
    // 在当前为浅色模式中，确保界面美观且颜色统一，设置导航栏的背景色。
    setStatusBar(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    return $r("app.media.fit_for_dark_mode_light_mode_banner");
  }
}

async function setStatusBar(currentMode: number) {
  // 1.获取应用主窗口。
  const windowStage: window.WindowStage = AppStorage.get('windowStage') as window.WindowStage;
  windowStage.getMainWindow((err, data) => {
    if (err.code) {
      MLog.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
      return;
    }
    MLog.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));

    let color = '';
    // 设置窗口为全屏布局，配合设置状态栏的背景颜色，与主窗口显示保持协调一致。
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      color = '#000000';
    } else if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      color = '#FFFFFF';
    } else {
      color = '#FA5a3C';
    }
    const sysBarProps: window.SystemBarProperties = {
      statusBarColor: color  // 状态栏背景颜色
    };

    // TODO: 知识点：调用setWindowSystemBarProperties()设置状态栏及导航栏的颜色
    data.setWindowSystemBarProperties(sysBarProps, (err) => {
      if (err.code) {
        MLog.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
        return;
      }
      MLog.info('Succeeded in setting the system bar properties.');
    });
  })
}