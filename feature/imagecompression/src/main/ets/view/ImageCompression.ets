/**
 * @Author: xwang
 * @Date: 2024/7/16 09:36
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';

@AppRouter({ name: "imagecompression/ImageCompression" })
@Component
export struct ImageCompression {
  @State strMaxCompressedImageSize: string = ''; // 指定图片压缩目标大小,string类型
  @State beforeCompressionSize: string = ''; // 压缩前的图片大小,单位kb
  @State afterCompressionSize: string = ''; // 压缩后的图片大小,单位kb
  @State compressedImageSrc: string | Resource = ''; // 压缩后的图片路径

  build() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text("输入图片压缩目标大小kb").fontSize(20)
        TextInput({ text: $$this.strMaxCompressedImageSize })// $$运算符为系统内置组件提供TS变量的引用，使得TS变量和系统内置组件的内部状态保持同步。
          .type(InputType.NUMBER_DECIMAL)// 带小数点的数字输入模式。支持数字，小数点（只能存在一个小数点）。
          .fontSize(20)
          .width("20%")
          .onChange((value: string) => {

          })
      }

      Button("图片压缩").onClick(() => {

      })
        .fontSize(20)
        .width("50%")

      Row() {
        Text("压缩前图片大小(kb)")
          .fontSize(20)
        Text(this.beforeCompressionSize)
          .fontSize(20)
      }

      Image($rawfile("image_compression_before.jpeg"))
        .width("100%")
        .height("30%")

      Row() {
        Text("压缩后图片大小(kb)")
          .fontSize(20)
        Text(this.afterCompressionSize)
          .fontSize(20)
      }

      Image(this.compressedImageSrc)
        .width("100%")
        .height("30%")
    }
    .alignItems(HorizontalAlign.Start)
    .padding(20)
  }
}