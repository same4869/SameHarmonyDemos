/**
 * @Author: xwang
 * @Date: 2024/8/5 14:22
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import web_webview from '@ohos.web.webview';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { MLog } from '@same/common';

const ACTION_IMAGE_CAPTURE: string = "ohos.want.action.imageCapture";
const TAG_CAMERA_ERROR: string = "Camera error : ";
const LOCAL_HTML_PATH: string = "camera.html";

// HTML页面中input标签调用ArkTS方法的返回结果
class FileResult {
  // 用于通知Web组件文件选择的结果
  result: FileSelectorResult;
  // 文件选择器的相关信息
  fileSelector: FileSelectorParam;

  constructor(result: FileSelectorResult, fileSelector: FileSelectorParam) {
    this.result = result;
    this.fileSelector = fileSelector;
  }
}

@AppRouter({ name: "webgetcameraimage/WebGetCameraImageView" })
@Component
export struct WebGetCameraImageView {
  controller: web_webview.WebviewController = new web_webview.WebviewController();

  build() {
    // TODO：知识点：Web组件通过onShowFileSelector接口，处理具有“文件”输入类型的HTML表单，响应用户按下的“选择文件”按钮，并通过event对象，将选择的图片/文件路径返回给input标签中onchange属性调用的js方法。onShowFileSelector接口的用法，可参考官方文档 https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-web-0000001774281246#ZH-CN_TOPIC_0000001774281246__onshowfileselector9
    Web({ src: $rawfile(LOCAL_HTML_PATH), controller: this.controller })
      .onShowFileSelector((event: FileResult) => { // event表示文件选择事件，其中result可以存储选择的图片/文件片路径，fileSelector可以设置文件选择器的部分属性
        // 调用invokeCamera接口，拉起原生相机进行拍照，并将照片路径放到uri中返回
        this.invokeCamera(((uri: string) => {
          // 将照片路径uri放到一个数组中，通过系统接口handleFileList将图片/文件的选择结果通知给Web组件，可参考官方文档 https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-web-0000001774281246#ZH-CN_TOPIC_0000001774281246__handlefilelist9
          event?.result.handleFileList([uri]);
        }))
        // 当返回值为true时，用户可以调用系统提供的弹窗能力。当回调返回false时，绘制的自定义弹窗无效。
        return true;
      })
  }

  /**
   * 调用系统相机，拍照后返回图片地址
   *
   * @param callback 回调接口，返回照片的路径
   */
  invokeCamera(callback: (uri: string) => void) {
    const context = getContext(this) as common.UIAbilityContext;
    const want: Want = {
      action: ACTION_IMAGE_CAPTURE,
      parameters: {
        "callBundleName": context.abilityInfo.bundleName,
      }
    };
    const result: (error: BusinessError, data: common.AbilityResult) => void = (error: BusinessError, data: common.AbilityResult) => {
      if (error && error.code !== 0) {
        MLog.error(`${TAG_CAMERA_ERROR} ${JSON.stringify(error.message)}`);
        return;
      }
      // 获取相机拍照后返回的图片地址
      const resultUri: string = data.want?.parameters?.resourceUri as string;
      if (callback && resultUri) {
        callback(resultUri);
      }
    }
    context.startAbilityForResult(want, result);
  }
}