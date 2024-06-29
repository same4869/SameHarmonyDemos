/**
 * @Author: xwang
 * @Date: 2024/6/28 14:02
 * @Description:
 **/
import { Comment } from '../model/CommentModel';
import { ImageListView } from './ImageListView';

@Component
export struct CommentItemView {
  // 评论
  private comment: Comment = new Comment('', '', '', [], '');

  build() {
    Column() {
      Row() {
        Image(this.comment.avatar)
          .width(50)
          .height(50)
          .borderRadius(25)

        Column() {
          Text(this.comment.name)
          Text(this.comment.time)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({
          left: 5
        })
      }
      .width("100%")

      Text(this.comment.comment)
        .width("100%")
        .margin({
          top: 5
        })

      if (this.comment.images.length > 0) {
        ImageListView({ selectedImages: this.comment.images })
          .margin({
            top: 5
          })
      }
    }
    .width("100%")
    .padding(10)
  }
}