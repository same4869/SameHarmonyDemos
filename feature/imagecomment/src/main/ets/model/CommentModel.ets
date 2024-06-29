/**
 * @Author: xwang
 * @Date: 2024/6/28 13:03
 * @Description:
 **/
import { CommonLazyDataSourceModel } from '@same/common';

// 评论数据类
export class Comment {
  id: number = 0;
  // 发布者名字
  name: string = "";
  // 发布者头像
  avatar: ResourceStr = "";
  // 发布时间
  time: string = "";
  // 发布的评论
  comment: string = "";
  // 发布的图片
  images: ResourceStr[] = [];

  constructor(name: string, comment: string, avatar: ResourceStr, images: ResourceStr[], time: string) {
    this.name = name;
    this.comment = comment;
    this.avatar = avatar;
    this.images = images;
    this.time = time;
  }
}

export class CommentData extends CommonLazyDataSourceModel<Comment> {
  addDataFirst(data: Comment): void {
    this.dataArray.unshift(data);
    // 在数组头部添加数据
    this.notifyDataAdd(0);
  }
}
