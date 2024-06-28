/**
 * @Author: xwang
 * @Date: 2024/6/28 11:16
 * @Description:
 **/
import { Comment, CommentData } from '../model/CommentModel';

const ID_IMAGE: string = "id_image";
const ID_TEXT_TITLE: string = "id_text_title";
const ID_LIST: string = "id_list";
const ID_TEXT_EMPTY: string = "id_text_empty";
const ID_ROW_PUBLISH: string = "id_row_publish";

export function mockData(): CommentData {
  const commentList: CommentData = new CommentData();
  commentList.pushData(new Comment('Cloud', "这里的风景很好", $r("app.media.icon_comment_app_logo1"), [$r("app.media.icon_comment_landscape5")], '02-07 13:25'));
  commentList.pushData(new Comment('晨风', "下次还会再来！", $r("app.media.icon_comment_app_logo2"), [$r("app.media.icon_comment_launch_advert"),$r("app.media.icon_comment_arc_of_light")], '01-03 14:55'));
  commentList.pushData(new Comment('来自星星', "风景这边独好", $r("app.media.icon_comment_app_logo3"), [$r("app.media.icon_comment_landscape1"),$r("app.media.icon_comment_landscape2"),$r("app.media.icon_comment_landscape3"),$r("app.media.icon_comment_landscape4")], '01-31 07:23'));
  return commentList;
}

@Preview
@Component
export struct ImageCommentView {
  // 评论列表
  @State commentList: CommentData = new CommentData();
  // 评论数量，用于刷新列表
  commentCount: number = 0;
  private scroller: ListScroller = new ListScroller();

  aboutToAppear(): void {
    // 添加模拟数据
    this.commentList = mockData();
    this.commentCount = this.commentList.totalCount();
  }

  build() {
    Column() {
      RelativeContainer() {
        Image($r("app.media.icon_comment_launch_advert"))
          .height("30%")
          .alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .id(ID_IMAGE)

        Text("热门评论")
          .height(40)
          .width("100%")
          .padding({
            left: 10
          })
          .border({
            width: {
              bottom: 1
            },
            color: {
              bottom: "#eeeeee"
            }
          })
          .alignRules({
            top: { anchor: ID_IMAGE, align: VerticalAlign.Bottom },
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .id(ID_TEXT_TITLE)

        if (this.commentCount > 0) {
          List({ scroller: this.scroller }) {
            // TODO：知识点：使用LazyForEach加载评论列表，可以按需加载，解决一次性加载全部列表数据引起的卡顿问题，提高页面响应速度
            LazyForEach(this.commentList, (comment: Comment) => {

            })
          }
          .scrollBar(BarState.Off)
          .width("100%")
          .margin({
            bottom: 50
          })
          .alignRules({
            top: { anchor: ID_TEXT_TITLE, align: VerticalAlign.Bottom },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .id(ID_LIST)
        } else {
          Text("还没有评论，快来添加评论吧")
            .textAlign(TextAlign.Center)
            .width("100%")
            .margin({
              bottom: 50
            })
            .alignRules({
              top: { anchor: ID_TEXT_TITLE, align: VerticalAlign.Bottom },
              bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
              left: { anchor: "__container__", align: HorizontalAlign.Start },
              right: { anchor: "__container__", align: HorizontalAlign.End }
            })
            .id(ID_TEXT_EMPTY)
        }

        Row() {
          Text('请文明发言')
            .borderRadius(30)
            .height(40)
            .width("95%")
            .padding({
              left: 15
            })
            .backgroundColor("#f6f7f9")
            .onClick(() => {

            })
            .border({
              width: 1,
              color: "#eeeeee"
            })
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height(50)
        .width("100%")
        .border({
          width:{
            top:1
          },
          color:{
            top:"#eeeeee"
          }
        })
        .alignRules({
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
          left: { anchor: "__container__", align: HorizontalAlign.Start },
          right: { anchor: "__container__", align: HorizontalAlign.End }
        })
        .id(ID_ROW_PUBLISH)
      }
      .width("100%")
      .height("100%")
    }
    .width("100%")
    .height("100%")
  }
}