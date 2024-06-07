import { promptAction } from '@kit.ArkUI';

let rawfileTotalContent: string = "";

@Preview
@Entry({ routeName: 'nativerawfile/NativeRawfileDemo' })
@Component
export struct NativeRawfileDemo {
  @State buttonEnabledStatus: boolean = true;
  @State ReadStartPos: number = 2;
  @State readLength: number = 5;
  @State rawfileContent: string = '';

  build() {
    Column() {
      Row() {
        Text("Rawfile内容")
          .width("35%")
          .align(Alignment.End)
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Normal)
          .margin(10)

        Text(rawfileTotalContent)
          .width("50%")
          .fontWeight(FontWeight.Normal)
          .margin(10)
      }.width("100%")

      Row() {
        Text("读取位置")
          .width("35%")
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Normal)
          .margin(10)
          .align(Alignment.End)

        TextInput({ text: this.ReadStartPos.toString() })
          .id("startPos")
          .width("50%")
          .type(InputType.Number)
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14 })
          .caretColor(Color.Blue)
          .margin(10)
          .fontColor(Color.Black)
          .onChange((value: string) => {
            if (value === '') {
              this.buttonEnabledStatus = false
            } else {
              this.ReadStartPos = Number(value)
              if (rawfileTotalContent.length <= this.ReadStartPos) {
                promptAction.showToast({ message: `读取位置取值范围0-${rawfileTotalContent.length - 1}` })
                this.buttonEnabledStatus = false
              } else {
                this.buttonEnabledStatus = true
              }
            }
          })
      }.width("100%")

      Row() {
        Text("读取长度")
          .width("35%")
          .fontWeight(FontWeight.Normal)
          .margin(10)
          .textAlign(TextAlign.End)
          .align(Alignment.End)
        TextInput({ text: this.readLength.toString() })
          .id("contentLen")
          .width("50%")
          .type(InputType.Number)
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 4 })
          .caretColor(Color.Blue)
          .margin(10)
          .fontColor(Color.Black)
          .onChange((value: string) => {
            if (value === "") {
              this.buttonEnabledStatus = false
            } else {
              this.readLength = Number(value)
              if (rawfileTotalContent.length < this.readLength + this.ReadStartPos) {
                promptAction.showToast({ message: "读取位置和读取长度的和不能超过Rawfile内容长度" })
                this.buttonEnabledStatus = false
              } else {
                this.buttonEnabledStatus = true
              }
            }
          })
      }.width("100%")

      Row() {
        Text("读取结果")
          .width("35%")
          .fontWeight(FontWeight.Normal)
          .margin(10)
          .textAlign(TextAlign.End)
          .align(Alignment.Start)

        Text(this.rawfileContent).width("50%")
          .fontWeight(FontWeight.Normal)
          .margin(10)
          .align(Alignment.Start)
      }.width("100%")
      .margin(8)

      Button("开始读取")
        .onClick(() => {

        }).margin(10)
        .enabled(this.buttonEnabledStatus)
    }
    .backgroundColor("#ffffff")
    .border({
      width: 1,
      color: "#317af7",
      radius: 10,
      style: BorderStyle.Solid
    })
    .borderRadius(12)
    .padding(12)
    .margin(12)
  }
}
