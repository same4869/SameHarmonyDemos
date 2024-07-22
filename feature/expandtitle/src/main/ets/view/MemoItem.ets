/**
 * @Author: xwang
 * @Date: 2024/7/22 10:09
 * @Description:
 **/
import { MemoInfo } from '../model/DataSource';
import { MEMO_DATA } from '../model/MockData';

@Component
export default struct MemoItem {
  @State memoItem: MemoInfo = MEMO_DATA[0];

  build() {
    Row() {
      Column({ space: 5 }) {
        Text(this.memoItem.title)
          .fontSize(17)
          .memoTextExpand()
          .fontColor("#182431")
        Text(this.memoItem.content)
          .fontSize(14)
          .memoTextExpand()
          .margin({ top: 10, bottom: 10 })
          .fontColor("#182431")
        Text(this.memoItem.time)
          .fontSize(14)
          .memoTextExpand()
          .fontColor(Color.Grey)
      }

      .alignItems(HorizontalAlign.Start)
      .width("70%")

      Image($r(this.memoItem.imageSrc))
        .width(90)
        .aspectRatio(1)
        .borderRadius(10)
    }
    .height(110)
    .backgroundColor("#ffffff")
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(24)
    .padding({ left: 12, right: 12 })
  }
}

@Extend(Text)
function memoTextExpand() {
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .maxLines(1)
}