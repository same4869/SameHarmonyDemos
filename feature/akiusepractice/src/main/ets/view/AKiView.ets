import { FunctionDescription } from '@same/common/Index'
import libaki from 'libaki_use_practice.so'; // 导入自定义AKI插件

@Entry({ routeName: 'akiusepractice/AkiView' })
@Component
export struct AkiView {
  @StorageLink("akiViewValue") akiViewValue: number = 0
  @State title: ResourceStr = "AKI使用实践"
  @State content: ResourceStr = "本示例使用AKI编写C++跨线程调用JS函数场景。通过点击按钮，调用C++全局函数创建子线程来调用JS函数，实现每次点击后对变量value做加10操作。"

  build() {
    Column() {
      //场景描述
      FunctionDescription({ title: this.title, content: this.content })

      Text(this.akiViewValue.toString())
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin(30)

      Button("AKI跨线程调用JS函数")
        .width("80%")
        .height(60)
        .fontSize(20)
        .onClick(() => {
          // TODO：知识点：使用AKI的JSBind.bindFunction绑定JavaScript全局函数。这里第一个参数"akiAccumulate"用于指定绑定的JavaScript函数名，用于Native索引。第二个参数是被绑定的JavaScript函数体。
          libaki.JSBind.bindFunction("akiAccumulate", (values: number) => {
            // 对变量value做加10操作，刷新Text组件的value值。
            values += 10;
            AppStorage.setOrCreate('akiViewValue', values);
          });
          // TODO：知识点：使用AKI调用C++全局函数AkiThreadsCallJs，并传入参数value。
          libaki.AkiThreadsCallJs(this.akiViewValue);
        })
    }
    .height("100%")
    .padding(12)
    .width("100%")
  }
}