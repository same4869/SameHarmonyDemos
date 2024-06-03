import { image } from '@kit.ImageKit';
import { matrix4 } from '@kit.ArkUI';

@Reusable
@Component
export struct ImageItemView {
  @Consume bgc: Color
  @State imagePixelMap: image.PixelMap | null = null; // 当前图片pixelMap，用于Image组件显示
  @State fitWH: "width" | "height" | undefined = undefined; // 表示当前图片是根据宽度适配还是高度适配
  imageWHRatio: number = 0; // 图片原始宽高比
  @State matrix: matrix4.Matrix4Transit = matrix4.identity().copy();
  // @State imageOffsetInfo: OffsetModel = new OffsetModel(0, 0);

  build() {
    Stack() {
      Image(this.imagePixelMap)// TODO：知识点：宽高只根据其尺寸设置一个，通过保持宽高比来设置另一个属性
        .width(this.fitWH == "width" ? "100%" : undefined)
        .height(this.fitWH == "height" ? "100%" : undefined)
        .aspectRatio(this.imageWHRatio)
        .objectFit(ImageFit.Cover)// TODO：知识点：保持宽高比进行缩放，可以超出父组件，以便实现多图切换的增强功能
        .autoResize(false)
        .transform(this.matrix)// TODO：知识点：通过matrix控制图片的缩放
        .defaultFocus(true)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .offset({
          // TODO：知识点：通过offset控制图片的偏移
          x: this.imageOffsetInfo.currentX,
          y: this.imageOffsetInfo.currentY
        })
    }
    .onBlur(() => {

    })
    .backgroundColor(this.bgc)
    .alignContent(Alignment.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .size({ width: "100%", height: "100%" })
    .gesture(
      GestureGroup(
        GestureMode.Exclusive,
        TapGesture({ count: 2 })
          .onAction(() => {

          })
      )
    )
  }
}