/**
 * @Author: xwang
 * @Date: 2024/7/11 13:43
 * @Description:
 **/
import { CommonLazyDataSourceModel, GlobalStateDialogManager, MLog, MToast } from '@same/common';
import { videoData, VideoData } from '../model/DataModel';
import { Side, VideoDes } from './Side';
import { curves } from '@kit.ArkUI';

// 视频下标
let videoIndex: number = 0;

@Component
export struct VideoSwiper {
  private swiperController: SwiperController = new SwiperController();
  private data: VideoNew = new VideoNew();
  @State playBoo: boolean = true; // 是否为播放状态
  @State index: number = 0; // 当前视频下标
  @StorageProp('isShowGlobalStateDialog') isShowGlobalStateDialog: boolean = false; // 是否展示全局弹窗

  aboutToAppear(): void {
    if (videoIndex) {
      this.index = videoIndex;
    }
    for (let i = 0; i < videoData.length; i++) {
      for (let j = 0; j < 50; j++) {
        videoData[i].commentDataSource.pushData({
          id: j + "",
          avatar: videoData[i].head,
          name: "精灵球收七龙珠" + j,
          commentContent: "我没有看到后续，但总有人会看到" + j,
          timeAgo: j + "小时前",
          address: "广州",
          likeCount: j + ""
        })
      }
      this.data.pushData(videoData[i]);
    }
  }

  aboutToDisappear(): void {
    if (this.isShowGlobalStateDialog) {
      GlobalStateDialogManager.operateGlobalStateDialog({ isShowGlobalStateDialog: false });
    }
  }

  build() {
    Column() {
      Swiper(this.swiperController) {
        /*
         *TODO 性能知识点：列表中数据较多且不确定的情况下，使用LazyForEach进行数据循环渲染。
         *当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用。
         *文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-rendering-control-lazyforeach-0000001524417213-V2
         */
        LazyForEach(this.data, (item: VideoData, index: number) => {
          Stack({ alignContent: Alignment.Center }) {
            Stack({ alignContent: Alignment.BottomStart }) {
              Stack({ alignContent: Alignment.TopEnd }) {
                // 使用Video组件实现播放视频并控制其播放状态
                Video({
                  src: item.video,
                  controller: item.controller
                })
                  .width("100%")
                  .height(this.isShowGlobalStateDialog ? "50%" : "100%")
                  .animation({ duration: 200 })
                  .objectFit(ImageFit.Contain)
                  .loop(true)
                  .autoPlay(true)
                  .controls(false)
                  .onPrepared((e) => { // 准备事件回调
                    item.duration = e.duration;
                    MLog.info('onPrepared index=' + item.index.toString() + ', isplay=' + item.play.toString() +
                      ', SwiperIndex=' + videoIndex.toString() + ', duration=' + e.duration.toString());
                  })
                  .onStart(() => {
                    MLog.info('onStart index=' + item.index.toString() + ', isplay=' + item.play.toString() +
                      ', SwiperIndex = ' + videoIndex.toString());
                    item.play = true;
                    this.playBoo = this.data.getData(this.index).play;
                  })
                  .onPause(() => {
                    MLog.info('onPause index=' + item.index.toString() + ', isplay=' + item.play.toString() +
                      ', SwiperIndex = ' + videoIndex.toString());
                    item.play = false;
                    this.playBoo = this.data.getData(this.index).play;
                  })
                  .onUpdate((e) => {
                    if (e !== undefined) {
                      const isPlayFinish: boolean = ((e.time === item.duration) ? true : false);
                      if (isPlayFinish) {
                        MLog.debug('onUpdate index=' + item.index.toString() + ', isplay=' + item.play.toString() +
                          ', SwiperIndex=' + videoIndex.toString() + ' duration=' + e.time.toString());
                      }
                    }
                  })
                  .onFinish(() => {
                    MLog.info('onFinish index=' + item.index.toString() + ', isplay=' + item.play.toString() +
                      ', SwiperIndex=' + videoIndex.toString());
                  })
                  .onError(() => {
                    MLog.error('onError, index=' + item.index.toString() + ', isplay=' + item.play.toString() +
                      ', SwiperIndex=' + videoIndex.toString());
                  })
                  .onClick(() => {
                    if (this.isShowGlobalStateDialog) {
                      GlobalStateDialogManager.operateGlobalStateDialog({ isShowGlobalStateDialog: false });
                      return;
                    }
                    if (item.play) {
                      item.controller.pause();
                    } else {
                      item.controller.start();
                    }
                  })// 组件可见区域变化事件
                  .onVisibleAreaChange([0.0, 1.0], (isVisisble: boolean, currentRatio: number) => {
                    // 通过设置ratios为[0.0, 1.0]，实现当组件完全显示或完全消失在屏幕中时触发回调
                    MLog.info('onVisibleAreaChange index=' + item.index.toString() + ', isplay=' +
                    item.play.toString() + ', SwiperIndex=' + videoIndex.toString() + ', visble=' +
                    isVisisble.toString());
                    if (isVisisble && currentRatio >= 1.0 && item.index === videoIndex) {
                      item.controller.start();
                    }
                  })

                // 展示视频播放界面右侧用户头像、视频评论数量、收藏数量、分享数量等信息
                Side({
                  head: item.head,
                  likeCount: item.likeCount,
                  commentCount: item.commentCount,
                  favoriteCount: item.favoriteCount,
                  shareCount: item.shareCount,
                  index: item.index,
                  commentData: item.commentDataSource
                })
              }
              .width("100%")
              .height("100%")
              .padding(0)

              // 展示视频播放界面左下角作者名字、作品描述等相关信息
              VideoDes({
                name: item.name,
                description: item.description,
                hotspot: item.hotspot,
                time: item.time
              })
                .margin({ bottom: 36 })

              Row() {
                Row() {
                  Image($r("app.media.shortvideo_ic_public_upgrade_filled"))
                    .height(14)
                    .width(14)
                  Text("上升热点")
                    .fontSize(14)
                    .fontColor("#ff3300")
                  Text(' · ' + item.hotspot)
                    .fontSize(12)
                    .maxLines(1)
                    .width(item.hotspot.length * 12)
                    .fontColor(Color.White)
                    .height(20)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .layoutWeight(1)
                }
                .width('66%')

                // 上升热点
                Row() {
                  Divider()
                    .vertical(true)
                    .color(Color.White)
                    .strokeWidth(1)
                    .height(14)
                    .margin({
                      left: 4,
                      right: 4
                    })
                  Text("98万人在看")
                    .fontSize(12)
                    .fontColor(Color.White)
                  Image($r("app.media.shortvideo_ic_arrow_right"))
                    .width(14)
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.End)
              }
              .width('100%')
              .height(36)
              .backgroundColor(Color.Gray)
              .opacity(0.7)
              .padding({
                left: 12,
                right: 12
              })
              .justifyContent(FlexAlign.Start)
              .onClick(() => {
                // 调用Toast显示提示：此样式仅为案例演示
                MToast.showToast("仅演示 箭头")
              })
            }
            .width("100%")
            .height("100%")
            .padding(0)

            if (!this.playBoo) {
              Image($r("app.media.shortvideo_pau"))
                .height(80)
                .width(80)
                .onClick(() => {
                  item.controller.start();
                  item.play = true;
                  this.playBoo = true;
                })
            }
          }
          .width("100%")
          .height("100%")
          .padding(0)
        }, (item: VideoData) => JSON.stringify(item))
      }
      .index(videoIndex) // 设置当前在容器中显示的子组件的索引值
      .displayCount(1)
      .width('100%')
      .height('100%')
      .autoPlay(false)
      .indicator(false)
      .loop(true)
      .duration(200) // 子组件切换的动画时长
      .cachedCount(0)
      .vertical(true)
      .itemSpace(0)
      /**
       * 弹性曲线产生自然的弹簧效果，四个参数分别对应附着在弹簧上的对象的初始速度、附着在弹簧上的对象的质量、单位形变量所需弹力的大小、
       * 弹簧在振动过程中的减震力，使得弹簧振幅逐渐减小直至停止在平衡位置
       */
      .curve(curves.interpolatingSpring(-1, 1, 328, 34))
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        MLog.info('onAnimationStart old index=' + index.toString() + ', isplay=' +
        this.data.getData(index).play.toString() + ', new index=' + targetIndex.toString());
        // 跳转之前停止当前视频
        this.data.getData(index).controller.pause();
      })
      .onChange(async (index) => {
        this.index = index;
        // 跳转成功之后播放当前视频
        this.data.getData(this.index).controller.start();
        this.playBoo = true;
        videoIndex = index;
        MLog.info('onChange New index=' + this.index.toString() + ', isplay=' +
        this.data.getData(this.index).play.toString() + ', SwiperIndex=' + videoIndex.toString());
      })
    }
    .width("100%")
    .height("100%")
  }
}

class VideoNew extends CommonLazyDataSourceModel<VideoData> {
}