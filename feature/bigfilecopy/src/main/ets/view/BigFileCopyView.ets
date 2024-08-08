/**
 * @Author: xwang
 * @Date: 2024/8/5 14:50
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import { BigFileCopyConstants } from '../constants/BigFileCopyConstants';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import { resourceManager } from '@kit.LocalizationKit';

@Extend(Button)
function customButtonStyle() {
  .width(BigFileCopyConstants.COMPONENT_SIZE)
  .fontSize($r("sys.float.ohos_id_text_size_body1"))
  .margin({ top: $r("sys.float.ohos_id_elements_margin_vertical_m") })
}

@AppRouter({ name: "bigfilecopy/BigFileCopyView" })
@Component
export struct BigFileCopyView {
  @State progress: number = BigFileCopyConstants.PROGRESS_MIN;
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  fileName: string = BigFileCopyConstants.TEST_FILE_NAME;
  targetFilePath: string = "";
  @State isCopyFinished: boolean = false;
  @State isEnableSmooth: boolean = true;
  @State isPreview: boolean = false;

  // TODO 文件复制较为耗时，可放在子线程进行
  copyFile2Sandbox() {
    this.isCopyFinished = false;
    // TODO：知识点：这里获取到的fd并不是目标文件的fd，而是文件所属hap包的fd
    const data: resourceManager.RawFileDescriptor = this.context.resourceManager.getRawFdSync(this.fileName);
    const targetPath: string = this.context.filesDir + "/" + this.fileName;
    const destFile: fs.File = fs.openSync(targetPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    let buffSize: number = BigFileCopyConstants.BUFF_SIZE;
    const buffer: ArrayBuffer = new ArrayBuffer(Math.min(buffSize, data.length));
    let off: number = 0; // 记录读取位置的偏移（相较于文件起始偏移）
    let len: number = 0; // 本次读取内容的实际长度
    let readedLen: number = 0; // 记录已读文件长度
    // TODO：知识点：因为获取的是所属hap包的fd，这里需要通过目标文件的大小和偏移进行复制
    while (len = fs.readSync(data.fd, buffer, { offset: data.offset + off, length: buffSize })) {
      readedLen += len;
      fs.writeSync(destFile.fd, buffer, { offset: off, length: len });
      this.progress = Math.floor((readedLen / data.length) * 100); // 小数转换成百分比
      off = off + len;
      if ((data.length - readedLen) < buffSize) {
        buffSize = data.length - readedLen;
      }
    }
    this.targetFilePath = targetPath;
    fs.close(destFile.fd);
    this.isCopyFinished = true;
  }

  setIsPreview(status: boolean): void {
    animateTo({ duration: BigFileCopyConstants.ANIMATION_DURATION, curve: Curve.Friction }, () => {
      this.isPreview = status;
    })
  }

  build() {
    Column() {
      Stack() {
        if (!this.isPreview) {
          Progress({
            value: this.progress,
            total: BigFileCopyConstants.PROGRESS_MAX,
            type: ProgressType.Eclipse
          }).size({ width: BigFileCopyConstants.COMPONENT_SIZE, height: BigFileCopyConstants.COMPONENT_SIZE })
            .style({
              strokeWidth: $r("app.integer.bigfilecopy_progress_stroke_width"),
              enableSmoothEffect: this.isEnableSmooth
            })
        } else {
          // TODO：知识点：Image组件加载沙箱路径需要加前缀 file://
          Image(BigFileCopyConstants.SANDBOX_PREFIX + this.targetFilePath)
            .width(BigFileCopyConstants.COMPONENT_SIZE)
            .height(BigFileCopyConstants.COMPONENT_SIZE)
            .borderRadius($r("sys.float.ohos_id_corner_radius_default_m"))
        }
      }

      Text(`当前复制进度：${this.progress}%`)
        .margin({ top: $r("sys.float.ohos_id_elements_margin_vertical_m") })
      Button($r("app.string.bigfilecopy_copy_button_msg"))
        .customButtonStyle()
        .enabled(!this.isCopyFinished)
        .onClick(() => {
          this.copyFile2Sandbox();
        })
      Button($r("app.string.bigfilecopy_reset_button_msg"))
        .customButtonStyle()
        .enabled(this.isCopyFinished)
        .onClick(() => {
          this.progress = BigFileCopyConstants.PROGRESS_MIN;
          this.isCopyFinished = false;
          this.setIsPreview(false);
        })
      Button($r("app.string.bigfilecopy_preview_button_msg"))
        .customButtonStyle()
        .enabled(this.isCopyFinished)
        .onClick(() => {
          this.setIsPreview(true);
        })
    }
  }
}