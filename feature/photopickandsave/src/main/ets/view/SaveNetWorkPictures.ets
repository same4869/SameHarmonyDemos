/**
 * 实现步骤：
 * 点击上部“下载”按钮进入”下载网络图片到手机相册”场景示例；点击下部“下载到指定路径”按钮进入”下载文件到指定用户目录”场景示例，
 * 从而实现手机相册并进行网络图片的下载和保存。
 * photoAccessHelper参考文档：
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-photoaccesshelper
 * saveButton参考文档
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/savebutton-0000001820999677
 */
import { FunctionDescription } from '@same/common/Index'
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import fs from '@ohos.file.fs';
import { promptAction } from '@kit.ArkUI';
import { picker } from '@kit.CoreFileKit';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import ResponseCode from '@ohos.net.http';
import { image } from '@kit.ImageKit';

const PERMISSIONS: Array<Permissions> = [
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA'
];

@Component
export struct SaveNetWorkPictures {
  @State image: PixelMap | undefined = undefined
  @State imageBuffer: ArrayBuffer | undefined = undefined // 图片ArrayBuffer

  async pickerSave(buffer: ArrayBuffer | string): Promise<void> {
    const photoSaveOptions = new picker.PhotoSaveOptions() //创建文件管理器保存选项实例
    photoSaveOptions.newFileNames = ['PhotoViewPicker ' + new Date().getTime() + '.jpg'] //保存文件名（可选）
    const photoViewPicker = new picker.PhotoViewPicker()
    photoViewPicker.save(photoSaveOptions)
      .then(async (photoSaveResult) => {
        const uri = photoSaveResult[0]
        const file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
        await fs.write(file.fd, buffer)
        await fs.close(file.fd)
        promptAction.showToast({
          message: "下载保存图片到指定路径成功",
          duration: 2000
        })
      })
  }

  /**
   * 保存ArrayBuffer到图库
   * @param buffer：图片ArrayBuffer
   * @returns
   */
  async saveImage(buffer: ArrayBuffer | string): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext
    const helper = photoAccessHelper.getPhotoAccessHelper(context)
    const uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, "jpg")
    const file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    await fs.write(file.fd, buffer)
    await fs.close(file.fd)
  }

  async aboutToAppear(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext
    const atManager = abilityAccessCtrl.createAtManager()
    await atManager.requestPermissionsFromUser(context, PERMISSIONS)
    this.getPicture()
  }

  async getPicture() {
    http.createHttp()
      .request('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/variablewatch/src/main/resources/base/media/variablewatch_grape.png',
        (error: BusinessError, data: http.HttpResponse) => {
          if (error) {
            // 下载失败时弹窗提示检查网络，不执行后续逻辑
            promptAction.showToast({
              message: "图片下载失败，请检查网络",
              duration: 2000
            })
            return;
          }

          this.transcodePixelMap(data);
          // 判断网络获取到的资源是否为ArrayBuffer类型
          if (data.result instanceof ArrayBuffer) {
            this.imageBuffer = data.result as ArrayBuffer;
          }
        }
      )
  }

  /**
   * 使用createPixelMap将ArrayBuffer类型的图片装换为PixelMap类型
   * @param data：网络获取到的资源
   */
  transcodePixelMap(data: http.HttpResponse) {
    if (ResponseCode.ResponseCode.OK === data.responseCode) {
      const imageData: ArrayBuffer = data.result as ArrayBuffer
      const imageSource: image.ImageSource = image.createImageSource(imageData)
      const options: image.InitializationOptions = {
        'alphaType': 0, // 透明度
        'editable': false, // 是否可编辑
        'pixelFormat': 3, // 像素格式
        'scaleMode': 1, // 缩略值
        'size': { height: 100, width: 100 }
      }; // 创建图片大小

      // 通过属性创建PixelMap
      imageSource.createPixelMap(options).then((pixelMap: PixelMap) => {
        this.image = pixelMap;
      });
    }
  }

  build() {
    Column() {
      FunctionDescription({
        title: "下载并保持网络图片",
        content: "本示例介绍使用http、photoAccessHelper、fs接口从网络下载图片的场景。"
      })

      Image(this.image)
        .objectFit(ImageFit.Contain)
        .width("50%")
        .height(300)

      SaveButton()
        .width(143)
        .onClick(async () => {
          if (this.imageBuffer !== undefined) {
            await this.saveImage(this.imageBuffer)
            promptAction.showToast({
              message: "图片下载到图库成功",
              duration: 2000
            })
          }
        })

      Button("下载到指定路径")
        .margin({ top: 8 })
        .height(43)
        .onClick(async () => {
          if (this.imageBuffer != undefined) {
            this.pickerSave(this.imageBuffer)
          }
        })
    }
    .height("100%")
    .margin(12)
  }
}