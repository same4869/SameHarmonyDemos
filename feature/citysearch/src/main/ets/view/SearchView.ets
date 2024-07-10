/**
 * @Author: xwang
 * @Date: 2024/7/10 15:47
 * @Description:
 **/
@Component
export struct SearchView {
  private scroller: Scroller = new Scroller(); // List组件里可以绑定的可滚动组件的控制器
  @Link searchList: string[];
  @Link isSearchState: boolean;
  @Link changeValue: string;

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      List({ space: 14, initialIndex: 0, scroller: this.scroller }) {
        ForEach(this.searchList, (item: string) => {
          ListItem() {
            Column() {
              Text(item)
                .height(30)
                .fontSize(14)
            }.onClick(() => {
              this.changeValue = item
            })
          }
        })
      }
      .layoutWeight(1)
      .edgeEffect(EdgeEffect.None)
      .divider({
        strokeWidth: 2,
        color: "#f5f5f5",
        startMargin: 0,
        endMargin: 20
      })
      .listDirection(Axis.Vertical)
      .sticky(StickyStyle.Header)
    }
    .width("100%")
    .height("100%")
    .layoutWeight(1)
    /* 性能知识点：由于需要通过搜索按钮频繁的控制自定义组件的显隐状态，因此推荐使用显隐控制替代条件渲染，
 * 参考合理选择条件渲染和显隐控制文章：
 * https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/proper-choice-between-if-and-visibility.md/
 */
    .visibility(this.isSearchState ? Visibility.Visible : Visibility.None)
  }
}