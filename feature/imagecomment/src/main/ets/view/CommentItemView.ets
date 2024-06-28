/**
 * @Author: xwang
 * @Date: 2024/6/28 14:02
 * @Description:
 **/
import { Comment } from '../model/CommentModel';

@Component
export struct CommentItemView {
  // 评论
  private comment: Comment = new Comment('', '', '', [], '');

  build() {
    Column() {
      Row() {

      }
      .width("100%")

      Text()
    }
    .width("100%")
    .padding(10)
  }
}