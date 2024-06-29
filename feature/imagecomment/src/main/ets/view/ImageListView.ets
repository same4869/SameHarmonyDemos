const ID_IMAGE: string = 'image';
const ID_DELETE: string = 'delete';

@Component
export struct ImageListView {
  // 图片列表
  @State selectedImages: ResourceStr[] = [];
  // 是否可以删除列表中的图片
  imageEnableDelete: boolean = false;

  build() {
    List({ space: 10 }) {
      ForEach(this.selectedImages, (image: string, index: number) => {
        ListItem() {
          RelativeContainer() {
            Image(image)
              .height(100)
              .width(100)
              .borderRadius(5)
              .alignRules({
                bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
                left: { anchor: "__container__", align: HorizontalAlign.Start }
              })
              .id(ID_IMAGE + index)

            if (this.imageEnableDelete) {
              Image($r("app.media.icon_comment_ic_public_close_filled"))
                .height(20)
                .width(20)
                .onClick(() => {
                  if (this.imageEnableDelete) {
                    this.selectedImages.splice(index, 1)
                  }
                })
                .alignRules({
                  top: { anchor: "__container__", align: VerticalAlign.Top },
                  right: { anchor: "__container__", align: HorizontalAlign.End }
                })
                .id(ID_DELETE + index)
            }
          }
          .width(110)
          .height(110)
        }
      })
    }
    .height(120)
    .width("100%")
    .padding({
      bottom: 10
    })
    .listDirection(Axis.Horizontal)
    .alignSelf(ItemAlign.Start)
  }
}