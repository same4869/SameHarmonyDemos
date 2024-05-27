@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button("地址交换动画").onClick(() => {
        
      })
    }
    .height('100%')
    .width('100%')
  }
}