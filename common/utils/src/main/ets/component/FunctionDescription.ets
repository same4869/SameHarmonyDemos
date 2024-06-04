@Component
export struct FunctionDescription {
  private title: ResourceStr = '';
  private content: ResourceStr = '';

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }.margin({ bottom: 8 })

      Row() {
        Text(this.content)
          .wordBreak(WordBreak.BREAK_ALL)
      }
    }
    .width("100%")
    .backgroundColor("#f1f3f5")
    .borderRadius(12)
    .padding(12)
  }
}