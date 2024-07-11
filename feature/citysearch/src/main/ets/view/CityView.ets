/**
 * @Author: xwang
 * @Date: 2024/7/10 16:04
 * @Description:
 **/
import { MToast } from '@same/common';
import { CityType, CITY_DATA, HOT_CITY, TAB_VALUE } from '../model/DetailData';

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

        List({ space: 14, initialIndex: 0, scroller: this.scroller }) {
          ForEach(CITY_DATA, (index: CityType) => {
            ListItem() {
              Column() {
                Text(`${index.name}`)
                  .height(30)
                  .fontSize(16)
                  .fontColor("#000000")
                  .width('100%')
                ForEach(index.city, (item: string) => {
                  Text(item)
                    .height(30)
                    .fontSize(14)
                    .width('100%')
                    .onClick(() => {
                      // 调用Toast显示提示:此样式仅为案例展示
                      MToast.showToast("仅演示")
                    })
                })
              }
            }
          })
        }
        .width('100%')
        .margin({
          left: 5,
          bottom: 50
        })
        .layoutWeight(1)
        .edgeEffect(EdgeEffect.None)
        .divider({
          strokeWidth: 2,
          color: "#f5f5f5",
          startMargin: 0,
          endMargin: 20
        })
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .onScrollIndex((firstIndex: number, lastIndex: number) => {
          this.stabIndex = firstIndex;
        })
      }
      .alignItems(HorizontalAlign.Start)

      /* TODO：知识点：可以与容器组件联动用于按逻辑结构快速定位容器显示区域的组件，arrayValue为字母索引字符串数组，selected为初始选中项索引值。
 * 1. 当用户滑动List组件，list组件onScrollIndex监听到firstIndex的改变，绑定赋值给AlphabetIndexer的selected属性，从而定位到字母索引。
 * 2. 当点击AlphabetIndexer的字母索引时，通过scrollToIndex触发list组件滑动并指定firstIndex，从而实现List列表与AlphabetIndexer组件
 * 首字母联动吸顶展示。
 */
      AlphabetIndexer({ arrayValue: TAB_VALUE, selected: this.stabIndex })
        .height('100%')
        .selectedColor("#ffffff")// 选中项文本颜色
        .popupColor("#a9a9a9")// 弹出框文本颜色
        .selectedBackgroundColor("#5dabff")// 选中项背景颜色
        .popupBackground("#f1f3f5")// 弹出框背景颜色
        .popupPosition({ x: 50, y: 350 })
        .usingPopup(true)// 是否显示弹出框
        .selectedFont({ size: 16, weight: FontWeight.Bolder })// 选中项字体样式
        .popupFont({ size: 30, weight: FontWeight.Bolder })// 弹出框内容的字体样式
        .alignStyle(IndexerAlign.Right)// 弹出框在索引条左侧弹出
        .itemSize(20)// 每一项的尺寸大小
        .margin({ right: -8 })
        .onSelect((tabIndex: number) => {
          this.scroller.scrollToIndex(tabIndex);
        })
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