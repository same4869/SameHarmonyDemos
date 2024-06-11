import { FunctionDescription } from '@same/common/Index'

import picker from '@ohos.file.picker';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct SelectPictures {
  @State uris: Array<string> = []; // 全局变量保存图库选择的结果uri
  @State photoCount: number = 0; // 全局变量控制选择图片的显示

  // 接口采用promise异步返回形式，传入可选参数DocumentSelectOptions对象，返回选择文件的uri数组。
  async getFileAssetsFromType() {
    const photoSelectOptions = new picker.PhotoSelectOptions()
    photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
    photoSelectOptions.maxSelectNumber = 2
    const photoViewPicker = new picker.PhotoViewPicker
    photoViewPicker.select(photoSelectOptions)
      .then((photoSelectResult) => {
        this.uris = photoSelectResult.photoUris
        this.photoCount = this.uris.length
      })
      .catch((err: BusinessError) => {
        return
      })
  }

  build() {
    Column() {
      FunctionDescription({
        title: "选照片",
        content: "本示例介绍使用PhotoViewPicker选择图片预览的场景,点击“+”从图库中选择图片，并在当前当前页面显示选择的图片。"
      })

      Column() {
        Image(this.photoCount > 0 ? this.uris[0] : $r("app.media.photopickandsave_add"))
          .objectFit(this.photoCount > 0 ? ImageFit.Contain : ImageFit.None)
          .width("50%")
          .height("30%")
          .onClick(() => {
            // TODO：知识点：通过调用getFileAssetsFromType()中的photoViewPicker.select()拉起图库界面进行图片选择。
            this.getFileAssetsFromType()
          })
          .margin(8)

        Image(this.photoCount > 1 ? this.uris[1] : "")
          .visibility(this.photoCount > 1 ? Visibility.Visible : Visibility.None)
          .objectFit(this.photoCount > 1 ? ImageFit.Contain : ImageFit.None)
          .width("50%")
          .height("30%")
          .onClick(() => {
            // TODO：知识点：通过调用getFileAssetsFromType()中的photoViewPicker.select()拉起图库界面进行图片选择。
            this.getFileAssetsFromType()
          })
      }
      .margin(12)
    }.height("100%")
  }
}