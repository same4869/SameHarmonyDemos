import { FunctionDescription } from '@same/common/Index'
import { CustomDataType, ListIndexPosition, MyDataSource } from '../model/DataTypes';

const TAG_LIST_LENGTH = 12; // TagList长度
const CONTENT_PER_TAG = 6; // 每个TAG对应多少个元素

@Preview
@Component
@Entry({ routeName: "secondarylinkage/SecondaryLinkExample" })
export struct SecondaryLinkExample {
  @State @Watch("onIndexChange") currentTagIndex: number = 0
  private classifyScroller: Scroller = new Scroller()
  private scroller: Scroller = new Scroller(); // 二级列表Scroller对象
  private tagIndexPosition: ListIndexPosition = { start: 0, end: 0 }; // 一级列表可视区域的起始索引和终点索引
  private tagLists: Array<string> = []; // 一级列表数据
  @State contentData: MyDataSource = new MyDataSource(); // 二级列表数据
  private records: Array<number> = [] // 二级列表分组count数量
  private isClickTagList: boolean = false; // 是否点击一级列表

  aboutToAppear(): void {
    for (let i = 0; i < TAG_LIST_LENGTH; i++) {
      this.tagLists.push(`类别${i + 1}`)
      const tempData: Array<CustomDataType> = new Array(CONTENT_PER_TAG).fill({
        desc: "内容数据",
        tag: `类别${i + 1}`
      })
      this.records.push(i * CONTENT_PER_TAG)
      this.contentData.pushData(tempData)
    }
    this.records.push(CONTENT_PER_TAG * TAG_LIST_LENGTH)
  }

  @Builder
  tagListItemBuilder(item: string, index: number) {
    ListItem() {
      Text(item)
        .width("100%")
        .height(75)
        .fontWeight(FontWeight.Regular)
        .fontColor(Color.Gray)
        .textAlign(TextAlign.Center)
        .backgroundColor(this.currentTagIndex == index ? Color.Blue : Color.Yellow)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.isClickTagList = true;
          }
        })
        .onClick(() => {
          // TODO:知识点: 3.点击一级列表后，通过一级列表索引获取二级列表索引，分别操作不同的Scroller对象使列表滚动到指定位置
          this.currentTagIndex = index
          const itemIndex = this.findItemIndex(index)
          this.scroller.scrollToIndex(itemIndex, true)
        })
    }
  }

  @Builder
  contentListItemBuilder(item: CustomDataType, index: number) {
    ListItem() {
      Row({ space: 12 }) {
        Text()
          .aspectRatio(1)
          .height("100%")
          .backgroundColor($r('sys.color.ohos_id_color_component_normal'))
          .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))

        Column({ space: 7 }) {
          Text(item.desc + index)
          Text(item.tag)
            .fontColor("#ff3cc824")
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
        }.width('100%')
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceEvenly)
        .height('100%')
      }
      .backgroundColor("#ffffff")
      .height(96)
    }
    .padding({
      left: $r('sys.float.ohos_id_card_margin_start'),
      right: $r('sys.float.ohos_id_card_margin_end')
    })
  }

  build() {
    Column() {
      FunctionDescription({
        title: "二级联动",
        content: "当前界面主要展示了通过选择一个列表（一级列表），来更新另一个列表（二级列表）的选项的效果"
      })

      Row() {
        // TODO:知识点: 2.一级列表绑定Scroller对象
        List({ scroller: this.classifyScroller, initialIndex: 0 }) {
          ForEach(this.tagLists, (item: string, index: number) => {
            this.tagListItemBuilder(item, index)
          })
        }
        .onScrollIndex((start: number, end: number) => {
          this.tagIndexPosition = { start, end }
        })
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .height("100%")
        .width("27%")

        //二级列表
        List({ scroller: this.scroller, space: 12 }) {
          LazyForEach(this.contentData, (item: CustomDataType, index: number) => {
            this.contentListItemBuilder(item, index)
          })

        }
        .scrollBar(BarState.Off)
        .listDirection(Axis.Vertical)
        .flexShrink(1)
        .divider({
          strokeWidth: 1,
          color: $r('sys.color.ohos_id_color_list_separator'),
          startMargin: $r('sys.float.ohos_id_card_margin_start'),
          endMargin: $r('sys.float.ohos_id_card_margin_end')
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.isClickTagList = false; // 当前点击的非一级列表
          }
        })
        .onScrollIndex((start: number) => {
          // TODO:知识点: 4.滑动二级列表触发组件滚动事件后，返回列表可视区域的第一个item对应的索引值，当前通过二级列表索引获取一级列表索引，操作一级列表Scroller对象使列表滚动到指定位置
          const currentClassIndex = this.findClassIndex(start)
          if (currentClassIndex !== this.currentTagIndex && this.isClickTagList !== true) {
            this.currentTagIndex = currentClassIndex
            this.classifyScroller.scrollToIndex(currentClassIndex, true)
          }
        })

      }.width("100%")
      .layoutWeight(1)
    }
  }

  /**
   * 根据一级列表索引值获取二级列表索引值
   *
   * @param {number} index - 一级列表索引值
   * @returns {number} 二级列表索引值
   */
  findItemIndex(index: number): number {
    return this.records[index];
  }

  /**
   * 根据二级列表索引值获取对应一级列表索引
   *
   * @param {number} index - 二级列表索引值
   * @returns {number} 一级列表索引值
   */
  findClassIndex(index: number): number {
    let ans = 0;
    for (let i = 0; i < this.records.length; i++) {
      if (index >= this.records[i] && index < this.records[i + 1]) {
        ans = i;
        break;
      }
    }
    return ans;
  }

  /**
   * 监听一级列表获焦索引变化
   * 这个具体是干啥的没太搞清楚
   */
  onIndexChange() {
    const start = this.tagIndexPosition.start;
    const end = this.tagIndexPosition.end;
    if ((this.currentTagIndex === end || this.currentTagIndex === end - 1)) {
      let leftScrollCount: number = this.currentTagIndex + 1;
      leftScrollCount = leftScrollCount >= this.tagLists.length - 1 ? this.tagLists.length - 1 : leftScrollCount;
      /**
       * scrollToIndex(value: number, smooth?: boolean, align?: ScrollAlign)
       * 性能知识点：开启smooth动效时，会对经过的所有item进行加载和布局计算，当大量加载item时会导致性能问题。
       */
      this.classifyScroller.scrollToIndex(leftScrollCount, true); // 使获焦item向左滚动
    }
    if (this.currentTagIndex === start || this.currentTagIndex === start + 1) {
      let rightScrollCount: number = this.currentTagIndex - 1;
      rightScrollCount = rightScrollCount <= 0 ? 0 : rightScrollCount;
      this.classifyScroller.scrollToIndex(rightScrollCount, true); // 使获焦item向右滚动
    }
  }
}