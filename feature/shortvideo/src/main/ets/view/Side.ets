/**
 * @Author: xwang
 * @Date: 2024/7/11 15:24
 * @Description:
 **/
import { GlobalStateDialogManager } from '@same/common';
import { MToast } from '@same/common/src/main/ets/utils/MToast';
import { CommentDataSource } from '../model/DataModel';
import { CommentComponent } from './CommentView';

@Builder
function commentBuilder(commentData: CommentDataSource): void {
  CommentComponent({ commentData: commentData })
}

// 展示视频播放界面右侧用户头像、视频评论数量、收藏数量、分享数量、作者是否被用户关注等信息
@Component
export struct Side {
  @State head: Resource = $r("app.media.shortvideo_app_icon"); // 头像
  @State likeCount: string = ''; // 点赞数量
  @State commentCount: string = ''; // 评论数量
  @State favoriteCount: string = ''; // 收藏数量
  @State shareCount: string = ''; // 分享数量
  @State isFocus: boolean = true; // 是否关注
  @State isLike: boolean = false; // 是否点赞
  @State isFavorite: boolean = true; // 是否收藏
  @State index: number = 0; // 用户下标
  @ObjectLink @Watch('changeCommentData') commentData: CommentDataSource; // 当评论内容更改时刷新全局弹窗

  changeCommentData() {
    GlobalStateDialogManager.operateGlobalStateDialog({
      wrapBuilder: wrapBuilder(commentBuilder),
      params: this.commentData
    });
  }

  aboutToAppear(): void {
    this.changeCommentData();
  }

  // 点击点赞按钮的回调函数
  private changeLikeCount(isAdd: boolean) {
    let likeCountNum = Number(this.likeCount);
    if (isAdd) {
      likeCountNum++;
    } else {
      likeCountNum--;
    }
    this.likeCount = '' + likeCountNum;
    animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
      this.isLike = !this.isLike;
    })
  }

  // 点击收藏按钮的回调函数
  private changefavoriteCount(isIncrease: boolean) {
    let favoriteCountNum = Number(this.favoriteCount);
    if (isIncrease) {
      favoriteCountNum++;
    } else {
      favoriteCountNum--;
    }
    this.favoriteCount = '' + favoriteCountNum;
    animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
      this.isFavorite = !this.isFavorite;
    })
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Image(this.head)
          .width(45)
          .height(45)
          .borderRadius(22.5)
          .border({
            width: 1,
            color: Color.White
          })
          .onClick(() => {
            MToast.showToast("金岩石 头像")
          })

        if (this.isFocus) {
          Image($r("app.media.shortvideo_img"))
            .width(20)
            .height(20)
            .borderRadius(10)
            .margin({ bottom: -8 })
            .onClick(() => {
              animateTo({ duration: 500, curve: Curve.EaseInOut }, () => {
                this.isFocus = !this.isFocus;
              })
            })
        } else {
          Image($r("app.media.shortvideo_follow1"))
            .width(20)
            .height(20)
            .borderRadius(10)
            .margin({ bottom: -8 })
            .onClick(() => {
              animateTo({ duration: 500, curve: Curve.EaseInOut }, () => {
                this.isFocus = !this.isFocus;
              })
            })
        }
      }
      .width("100%")
      .height(100)
      .padding({ bottom: 30 })

      Column() {
        if (!this.isLike) {
          Image($r("app.media.shortvideo_fabulous"))
            .height(30)
            .width(35)
            .objectFit(ImageFit.ScaleDown)
            .onClick(() => {
              this.changeLikeCount(true);
            })
            .margin({ bottom: 5 })
          Text(this.likeCount)
            .fontSize(10)
            .fontColor(Color.White)
            .opacity(0.7)
        } else {
          Image($r("app.media.shortvideo_fabulo"))
            .height(30)
            .width(35)
            .objectFit(ImageFit.ScaleDown)
            .onClick(() => {
              this.changeLikeCount(false);
            })
            .margin({ bottom: 5 })
          Text(this.likeCount)
            .fontSize(10)
            .fontColor(Color.White)
            .opacity(0.7)
        }
      }.width('60%')
      .height(60)

      Column() {
        Image($r("app.media.shortvideo_new_icon"))
          .height(30)
          .width(35)
          .objectFit(ImageFit.ScaleDown)
          .margin({ bottom: 5 })
        Text(this.commentCount)
          .fontSize(10)
          .fontColor(Color.White)
          .opacity(0.7)
      }.width('60%')
      .height(60)
      .onClick(() => {
        // 开启全局弹窗
        GlobalStateDialogManager.operateGlobalStateDialog({ isShowGlobalStateDialog: true });
      })

      Column() {
        if (this.isFavorite) {
          Image($r("app.media.shortvideo_ic_public_highlightsed_white"))
            .height(30)
            .width(35)
            .onClick(() => {
              this.changefavoriteCount(true);
            })
            .margin({ bottom: 5 })
          Text(this.favoriteCount)
            .fontSize(10)
            .fontColor(Color.White)
            .opacity(0.7)
        } else {
          Image($r("app.media.shortvideo_ic_public_highlightsed_yellow"))
            .height(30)
            .width(35)
            .onClick(() => {
              this.changefavoriteCount(false);
            })
            .margin({ bottom: 5 })
          Text(this.favoriteCount)
            .fontSize(10)
            .fontColor(Color.White)
            .opacity(0.7)
        }
      }.width('60%')
      .height(60)

      Column() {
        Image($r("app.media.shortvideo_share1"))
          .height(25)
          .width(25)
          .objectFit(ImageFit.ScaleDown)
          .onClick(() => {
            // 调用Toast显示提示：此样式仅为案例演示
            MToast.showToast("金岩石 分享1")
          })
        Text("分享")
          .fontSize(10)
          .fontColor(Color.White)
          .opacity(0.7)
          .onClick(() => {
            // 调用Toast显示提示：此样式仅为案例演示
            MToast.showToast("金岩石 分享1")
          })
      }.width('60%')
      .height(50)
    }
    .margin({ top: 220 })
    .height("60%")
    .width(60)
    .justifyContent(FlexAlign.End)
  }
}

// 展示视频相关信息，比如视频作者的昵称、视频文案、搭配的音乐以及发布时间
@Component
export struct VideoDes {
  @State name: string = ''; // 昵称
  @State description: string = ''; // 文案
  @State hotspot: string = ''; // 上升热点
  @State time: string = ''; // 发布时间

  build() {
    Column() {
      Text(this.name)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .margin({ bottom: 8 })
        .onClick(() => {
          // 调用Toast显示提示：此样式仅为案例演示
          MToast.showToast("仅演示 名字")
        })

      Text(this.description)
        .fontSize(14)
        .fontColor(Color.White)
        .width('70%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .onClick(() => {
          // 调用Toast显示提示：此样式仅为案例演示
          MToast.showToast("仅演示 描述")
        })

      Row() {
        Text(this.time)
          .fontSize(10)
          .fontColor("#bbbbbb")
      }
    }
    .padding({ left: 10 })
    .alignItems(HorizontalAlign.Start)
    .width('80%')
  }
}