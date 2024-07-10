/**
 * @Author: xwang
 * @Date: 2024/7/10 16:04
 * @Description:
 **/
import { HOT_CITY } from '../model/DetailData';

@Component
export struct CityView {
  private scroller: Scroller = new Scroller();
  @State stabIndex: number = 0;
  @State location: boolean = true;
  @Link isSearchState: boolean;
  @Link changeValue: string;
  curCity: string = '';
  controller: SearchController = new SearchController();

  build() {
    Stack({ alignContent: Alignment.End }) {
      Column() {
        Text($r('app.string.citysearch_hotCity'))
          .fontSize(14)
          .fontColor("#000000")
          .opacity(0.6)
          .margin({ left: 5, bottom: 14 })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
          ForEach(HOT_CITY, (item: string) => {
            // 这里规定每行占四个城市
            Text(`${item}`)
              .margin({ bottom: 12, left: 6 })
              .width('22%')
              .height(28)
              .textAlign(TextAlign.Center)
              .fontSize(14)
              .maxLines(3)
              .fontColor("#191919")
              .backgroundColor("#d9d8d8")
              .borderRadius(18)
              .onClick(() => {
                this.changeValue = item;
              })
          })
        }
        .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
    }
    .flexShrink(1)
    .flexGrow(1)
    .padding({ bottom: 10 })
    /* 性能知识点：由于需要通过搜索按钮频繁的控制自定义组件的显隐状态，因此推荐使用显隐控制替代条件渲染，
     * 参考合理选择条件渲染和显隐控制文章：
     * https://gitee.com/harmonyos-cases/cases/blob/master/docs/performance/proper-choice-between-if-and-visibility.md
     */
    .visibility(this.isSearchState ? Visibility.None : Visibility.Visible)
  }
}