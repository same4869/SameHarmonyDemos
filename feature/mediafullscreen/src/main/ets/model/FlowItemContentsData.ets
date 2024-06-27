/**
 * @Author: xwang
 * @Date: 2024/6/27 14:19
 * @Description:
 **/
import { CommonLazyDataSourceModel } from '@same/common';

export class UserItem {
  userId: string;
  userName: string | Resource;
  userImage: string | Resource;

  toString(): string {
    return this.userId + '  ' + this.userName + '  ' + this.userImage;
  }

  constructor(id: string, name: string | Resource, image?: string | Resource) {
    this.userId = id;
    this.userName = name;
    this.userImage = $r("app.media.media_full_screen_profile_photo");
    if (image != null) {
      this.userImage = image;
    };
  }
}

export class FlowItemContent {
  id: string;
  user: UserItem;
  text: string;
  imageList: Array<string> = [];
  media: string = ''; // media为需要获取的视频url
  mediaPreview: string = ''; // mediaPreview为需要获取的视频预览图url

  constructor(id: string, user: UserItem, text: string, media: string, mediaPreview: string) {
    this.id = id;
    this.user = user;
    this.media = media;
    this.mediaPreview = mediaPreview;
    this.text = text;
  }

  toString(): string {
    return this.id + '  ' + this.user.toString() + '  ' + this.text;
  }
}


export class FlowItemContentsData extends CommonLazyDataSourceModel<FlowItemContent>{

}