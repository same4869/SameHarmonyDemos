// 选择图片的最大数量
import { MToast } from '@same/common/src/main/ets/utils/MToast';
import { common } from '@kit.AbilityKit';
import { cameraCapture } from '@same/common';
import { ImageListView } from './ImageListView';

const MAX_SELECT_IMAGE: number = 9;
const ID_TEXT_INPUT: string = "id_text_input";
const ID_IMAGE_CAMERA: string = "id_image_camera";
const ID_TEXT_PUSH: string = "id_text_publish";

@CustomDialog
export struct CommentInputDialog {
  controller?: CustomDialogController
  // 输入的文字
  @State text: string = "";
  // 选择的照片列表
  @State selectedImages: string[] = [];
  @Link textInComment: string;
  @Link imagesInComment: string[];
  // 发布接口，用于主页面更新评论数据
  publish: () => void = (): void => {
  }

  build() {
    Column() {
      RelativeContainer() {
        TextInput()
          .height(40)
          .padding({
            left: 10,
            right: 50,
            top: 3,
            bottom: 3
          })
          .margin({
            right: 10
          })
          .onChange((textInComment: string) => {
            this.text = textInComment
          })
          .defaultFocus(true)
          .alignRules({
            // 性能知识点：使用相对布局组件RelativeContainer，子组件通过alignRules接口将父组件或者其他组件设为锚点，可使布局扁平化，有利于性能提升
            top: { anchor: "__container__", align: VerticalAlign.Top },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            right: { anchor: ID_TEXT_PUSH, align: HorizontalAlign.Start }
          })
          .id(ID_TEXT_INPUT)

        Image($r("app.media.icon_comment_camera"))
          .height(30)
          .width(30)
          .onClick(async () => {
            if (this.selectedImages.length >= MAX_SELECT_IMAGE) {
              MToast.showToast("最多只能选择9张图片")
              return
            }
            //拉起相机
            const image: string = await cameraCapture(getContext(this) as common.UIAbilityContext);
            if (image !== "") {
              this.selectedImages.push(image);
            }
          })
          .margin({
            right: 10
          })
          .alignRules({
            top: { anchor: ID_TEXT_INPUT, align: VerticalAlign.Top },
            bottom: { anchor: ID_TEXT_INPUT, align: VerticalAlign.Bottom },
            right: { anchor: ID_TEXT_INPUT, align: HorizontalAlign.End }
          })
          .id(ID_IMAGE_CAMERA)

        Button("发布")
          .width(60)
          .height(30)
          .borderRadius(15)
          .backgroundColor("#be1d1d")
          .fontColor(Color.White)
          .onClick(() => {
            if (this.controller) {
              this.textInComment = this.text
              this.imagesInComment = this.selectedImages
              this.publish()
              this.controller.close()
              this.textInComment = ""
              this.imagesInComment = []
            }
          })
          .alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .id(ID_TEXT_PUSH)
      }
      .height(50)

      if (this.selectedImages.length > 0) {
        ImageListView({ selectedImages: this.selectedImages, imageEnableDelete: true })
      }
    }
    .padding(10)
    .backgroundColor(Color.White)
    .offset({
      y: 20
    }) // 添加y轴偏移量，否则弹窗和输入法间会有空白
  }
}