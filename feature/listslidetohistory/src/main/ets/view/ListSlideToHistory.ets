/**
 * @Author: xwang
 * @Date: 2024/7/22 16:51
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import { CommonLazyDataSourceModel } from '@same/common';
import { OneMoment } from './OneMoment';
import { util } from '@kit.ArkTS';

/**
 * 附近的人主题数据
 */
export class FriendMoment {
  id: string; // 唯一id
  userName: string; // 用户名
  avatar: string; // 头像
  text: string; // 文字
  image?: string; // 文字配图

  constructor(id: string, userName: string, avatar: string, text: string, image?: string) {
    this.id = id;
    this.userName = userName;
    this.avatar = avatar;
    this.text = text;
    if (image !== undefined) {
      this.image = image;
    }
  }
}

export class FriendMomentsData extends CommonLazyDataSourceModel<FriendMoment> {
}

const momentData: FriendMomentsData = new FriendMomentsData(); // 公共常亮存放LazyForEach数据实体

/** 附近的人主页面
 * 实现步骤：
 * 1.使用LazyForEach+cacheCount+@Reusable实现懒加载列表。
 * 2.创建ListScroller对象，将ListScroller对象绑定到List组件内。
 * 3.在需要记录当前位置时通过currentOffset方法存储当前偏移量historyOffset，在需要跳转时用scrollTo方法跳转。
 */

@AppRouter({ name: "listslidetohistory/ListSlideToHistory" })
@Component
export struct ListSlideToHistory {
  listScroller: ListScroller = new ListScroller(); // scroller控制器
  @State firstIndex: number = 0; // 当前显示在屏幕上的子组件索引值，用来控制下方按钮跳转
  historyOffset: number = 0; // 上次浏览到列表距离顶端的偏移量offset

  aboutToAppear(): void {
    // 一个函数加载10个，为保证初始页面跳转，因此加载20个列表。
    getFriendMomentFromRawfile();
    getFriendMomentFromRawfile();
  }

  build() {
    Column() {
      Row() {
        Text("附近的人")
          .fontSize(20)
          .fontColor("#182431")
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
          .fontFamily("HarmonyHeiTi")
          .lineHeight(24)
          .layoutWeight(1)
      }
      .alignItems(VerticalAlign.Center)
      .height(50)
      .width("100%")
      .padding({
        left: 24,
        right: 24,
        top: 13,
        bottom: 9
      })

      List({ space: 8, scroller: this.listScroller }) {
        LazyForEach(momentData, (moment: FriendMoment) => {
          ListItem() {
            OneMoment({ moment: moment })
          }
        }, (moment: FriendMoment) => moment.id)
      }
      // TODO：高性能知识点：为保证滑动流畅，采用cachedCount缓存前后节点。
      .cachedCount(3)
      .width("100%")
      .height("100%")
      .listDirection(Axis.Vertical)
      .divider({
        strokeWidth: 1,
        color: "#0c000000",
        startMargin: 12,
        endMargin: 12
      })
      .onScrollIndex((first: number) => {
        this.firstIndex = first
      })

      Button(this.firstIndex < 3 ? "跳转到上次浏览历史" : "跳转到顶部", {
        type: ButtonType.Normal,
        stateEffect: true
      })
        .fontColor("#000")
        .height(40)
        .borderRadius(20)
        .backgroundColor("#ffaeaeae")
        .opacity(0.8)
        .width(200)
        .position({ x: "50%", y: "90%" })
        .markAnchor({ x: "50%" })
        .onClick(() => {
          // 当前显示的index值小于设定的SWITCH_BUTTON时，按钮为跳转到上次浏览记录，否则为跳转到顶部
          if (this.firstIndex < 3) {
            this.listScroller.scrollTo({
              xOffset: 0,
              yOffset: this.historyOffset === 0 ? 1000 : this.historyOffset,
              animation: { duration: 500, curve: Curve.LinearOutSlowIn }
            });
          } else {
            this.historyOffset = this.listScroller.currentOffset().yOffset;
            this.listScroller.scrollTo({
              xOffset: 0,
              yOffset: 0,
              animation: { duration: 500, curve: Curve.LinearOutSlowIn }
            });
          }
        })
    }
    .height("100%")
    .width("100%")
  }
}

/**
 * 从Rawfile获取json数据，并通过momentData里的pushData方法放入列表数据。
 * @returns: Promise<void>
 */
async function getFriendMomentFromRawfile(): Promise<void> {
  const resourceManager = getContext().resourceManager;
  const res = await resourceManager.getRawFileContent("list_slide_to_history_mock_data.json");

  interface MyJsonModel {
    friendMoments: FriendMoment[];
  }

  const textDecoder = util.TextDecoder.create();
  const friendMomentArray = (JSON.parse(textDecoder.decodeWithStream(res)) as MyJsonModel).friendMoments;

  friendMomentArray.forEach(item => {
    // 由于获取的json的id是固定0-9，所以使用当前列表数量totalCount的十位部分加上json的id生成新的不重复id。
    item.id = Math.floor(momentData.totalCount() / 10) + item.id;
    item.text =
      resourceManager.getStringSync($r('app.string.list_slide_to_history_jump_text_one'), parseInt(item.id) + 1) +
      item.text;
    momentData.pushData(item);
  })
}