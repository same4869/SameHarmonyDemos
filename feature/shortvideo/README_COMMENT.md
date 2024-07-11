# 评论组件案例实现

### 介绍

评论组件在目前市面上的短视频app中是一种很常见的场景，本案例使用[全局状态保留能力弹窗](../../common/utils/src/main/ets/component/README.md)来实现评论组件。点击评论按钮弹出评论组件，点击空白处隐藏该组件，再次点击评论按钮则会恢复上一次浏览的组件状态。

### 效果图预览

<img src="../../product/entry/src/main/resources/base/media/short_video_comment.gif" height="600">

**使用说明**

1. 点击评论按钮打开评论组件。
2. 上下滑动可以浏览评论。
3. 点击空白处或者关闭按钮可以关闭评论组件。
4. 再次点击评论按钮则恢复上一次浏览评论位置。

### 实现思路
1. 使用GlobalStateDialogManager来操作全局状态保留能力弹窗的布局内容以及显隐。源码参考[Side.ets](src/main/ets/view/Side.ets)。
首先导入GlobalStateDialogManager，如下：
```typescript
import { GlobalStateDialogManager } from '@ohos/base';
```
2. 初始化及评论内容更改时，使用operateGlobalStateDialog函数配置弹窗内容布局，如下：
```typescript
  @Link @Watch('changeCommentData') commentData: CommentDataSource; // 当评论内容更改时刷新全局弹窗

  changeCommentData() {
    GlobalStateDialogManager.operateGlobalStateDialog({
      wrapBuilder: wrapBuilder(commentBuilder),
      params: this.commentData
    });
  }

  aboutToAppear(): void {
    this.changeCommentData();
  }
  
  @Builder
  function commentBuilder(commentData: CommentDataSource): void {
    CommentComponent({ commentData: commentData })
  }
```
3. 按钮点击时通过operateGlobalStateDialog函数配置弹窗显示，如下：
```typescript
  build() {
    、、、
    
      Column() {
        Image($r("app.media.short_video_new_icon"))
          .height($r("app.integer.short_video_fabulous_height"))
          .width($r("app.integer.short_video_fabulous_width"))
          .objectFit(ImageFit.ScaleDown)
          .margin({ bottom: $r("app.integer.short_video_fabulous_margin_bottom") })
        Text(this.commentCount)
          .fontSize($r("app.integer.short_video_fabulous_font_size"))
          .fontColor(Color.White)
          .opacity($r("app.float.short_video_fabulous_opacity"))
      }.width('60%')
      .height($r("app.integer.short_video_all_fabulous_height"))
      .onClick(() => {
        // 开启全局弹窗
        GlobalStateDialogManager.operateGlobalStateDialog({ isShowGlobalStateDialog: true });
      })
      
      、、、
  }
```

### 高性能知识点

本示例使用了[LazyForEach](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-rendering-control-lazyforeach-0000001524417213-V3)进行数据懒加载，LazyForEach懒加载可以通过设置cachedCount属性来指定缓存数量，同时搭配[组件复用](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/best-practices-long-list-0000001728333749#section36781044162218)能力以达到性能最优效果。


### 工程结构&模块类型

   ```
   shortvideo                             // har类型
   |---model
   |   |---BasicDataSource.ets            // 模型层-懒加载数据源
   |   |---DataModel.ets                  // 数据模型层-视频数据
   |---view
   |   |---ShortVideo.ets                 // 视图层-主页
   |   |---Side.ets                       // 视图层-视频右侧页面操作栏与左侧信息栏
   |   |---VideoSwiper.ets                // 视图层-短视频切换
   |   |---CommentView.ets                // 视图层-评论组件
   ```

### 模块依赖
1. [路由模块](../../common/routermodule)：供entry模块实现路由导航
2. [公共模块](../../common/utils)：全局状态保留能力弹窗

### 参考资料
[全局状态保留能力弹窗](../../common/utils/src/main/ets/component/README.md)