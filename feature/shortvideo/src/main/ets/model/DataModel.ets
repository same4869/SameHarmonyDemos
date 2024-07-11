/**
 * @Author: xwang
 * @Date: 2024/7/11 13:08
 * @Description:
 **/
import { CommonLazyDataSourceModel } from '@same/common';

export class TopTabContent extends CommonLazyDataSourceModel<string> {
  protected dataArray: string[] = ['关注', '精选', '推荐', '放映厅']
}

// 视频数据结构
export interface VideoData {
  video: Resource | string;
  name: string;
  description: string;
  time: string;
  controller: VideoController;
  auto: boolean;
  duration: number; // 视频时长
  head: Resource;
  likeCount: string;
  commentCount: string;
  favoriteCount: string;
  shareCount: string;
  hotspot: string;
  play: boolean;
  index: number;
  commentDataSource: CommentDataSource;
}

/**
 * 评论属性
 */
@Observed
export class Comment {
  id?: string; // 评论id
  avatar?: Resource; // 评论人头像
  name?: string; // 评论人昵称
  commentContent?: string; // 评论内容
  timeAgo?: string; // 评论时间
  address?: string; // 评论地址
  likeCount?: string; // 评论的点赞人数
}


@Observed
export class CommentDataSource extends CommonLazyDataSourceModel<Comment> {
}

export let videoData: Array<VideoData> = [
  {
    video: $r("app.media.shortvideo_short_video1"),
    name: '@北大是只猫',
    description: '欢迎来到霍格莫德村',
    time: '2024-1-3 14:52',
    controller: new VideoController(),
    auto: true,
    duration: 0,
    head: $r("app.media.shortvideo_photo33"),
    likeCount: '1234',
    commentCount: '2234',
    favoriteCount: '3234',
    shareCount: '4234',
    hotspot: '猫长藓要多晒太阳',
    play: false,
    index: 0,
    commentDataSource: new CommentDataSource()
  },
  {
    video: $r("app.media.shortvideo_short_video2"),
    name: '@谭 雪',
    description: '#栈桥',
    time: '2024-1-2 10:52',
    controller: new VideoController(),
    auto: false,
    duration: 0,
    head: $r("app.media.shortvideo_photo35"),
    likeCount: '7890',
    commentCount: '8890',
    favoriteCount: '9990',
    shareCount: '9991',
    hotspot: '栈桥海鸥',
    play: false,
    index: 1,
    commentDataSource: new CommentDataSource()
  },
  {
    video: $r("app.media.shortvideo_short_video3"),
    name: '@刘格格',
    description: '生活不止眼前的苟且，还有诗和远方',
    time: '2024-1-2 16:03',
    controller: new VideoController(),
    auto: false,
    duration: 0,
    head: $r("app.media.shortvideo_photo37"),
    likeCount: '4567',
    commentCount: '5567',
    favoriteCount: '6667',
    shareCount: '7667',
    hotspot: '社恐',
    play: false,
    index: 2,
    commentDataSource: new CommentDataSource()
  }
]