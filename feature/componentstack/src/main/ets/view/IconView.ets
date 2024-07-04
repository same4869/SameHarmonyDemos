/**
 * @Author: xwang
 * @Date: 2024/7/4 10:31
 * @Description:
 **/
import { MToast } from '@same/common';
import { ICON_DATA1, ICON_DATA2 } from '../mock/IconMock';
import { IconDataModel } from '../model/IconModel';

const ICONVIEWSPACE: number = 10; // 图标之间间距
const ASPECT_RATIO: number = 1; // 图片的宽高比
const ICONLISTCOLUMNS1: number = 4; // 列表1的列数
const ICONLISTCOLUMNS2: number = 5; // 列表2的列数
const SPAN: number = 1; // 占列数

// 上图下文字白色背景样式
@Component
struct iconView1 {
  icon: ResourceStr = '';
  title: ResourceStr = '';

  build() {
    Column({ space: ICONVIEWSPACE }) {
      Image(this.icon)
        .width(40)
        .aspectRatio(ASPECT_RATIO)
        .objectFit(ImageFit.Contain)

      Text(this.title)
        .fontSize(16)
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
    }
    .width("100%")
    .height(90)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .onClick(() => {
      MToast.showToast("仅演示")
    })
  }
}

// 左文右图字白色背景样式
@Component
struct iconView2 {
  icon: ResourceStr = '';
  title: ResourceStr = '';

  build() {
    Row() {
      Text(this.title)
        .fontSize(18)
        .fontColor(Color.Black)

      Image(this.icon)
        .width(50)
        .aspectRatio(ASPECT_RATIO)
        .objectFit(ImageFit.Contain)
        .margin({ left: 20 })
    }
    .width("100%")
    .height(85)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .onClick(() => {
      MToast.showToast("仅演示")
    })
  }
}

// 上图下文字透明背景样式
@Component
struct iconView3 {
  icon: ResourceStr = '';
  title: ResourceStr = '';

  build() {
    Column({ space: ICONVIEWSPACE }) {
      Image(this.icon)
        .width(40)
        .aspectRatio(ASPECT_RATIO)
        .objectFit(ImageFit.Contain)

      Text(this.title)
        .fontSize(16)
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
    }
    .width("100%")
    .height(95)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      MToast.showToast("仅演示")
    })
  }
}


@Component
export struct IconList1 {
  build() {
    GridRow({ columns: ICONLISTCOLUMNS1, gutter: { x: ICONVIEWSPACE, y: ICONVIEWSPACE } }) {
      // GridRow组件不支持LazyForEach方法
      ForEach(ICON_DATA1, (item: IconDataModel) => {
        GridCol({ span: item.span }) {
          if (item.span == SPAN) {
            iconView1({ icon: item.icon, title: item.title })
          } else {
            iconView2({ icon: item.icon, title: item.title })
          }
        }
      }, (item: IconDataModel) => item.id.toString())
    }
    .width("100%")
    .height(90)
  }
}

@Component
export struct IconList2 {
  @Prop ratio: number;

  build() {
    GridRow({ columns: ICONLISTCOLUMNS2, gutter: { x: ICONVIEWSPACE, y: ICONVIEWSPACE } }) {
      // GridRow组件不支持LazyForEach方法
      ForEach(ICON_DATA2, (item: IconDataModel) => {
        GridCol({ span: item.span }) {
          iconView3({ icon: item.icon, title: item.title })
        }
        .scale({ x: this.ratio, y: this.ratio })
      }, (item: IconDataModel) => item.id.toString())
    }
  }
}

@Component
export struct IconList3 {
  scroller: Scroller = new Scroller();
  @Prop marginSpace: number;

  build() {
    List({ space: this.marginSpace }) {
      // 当前是固定菜单列表，数量少，不需要使用LazyForEach做性能优化
      ForEach(ICON_DATA1, (item: IconDataModel) => {
        ListItem() {
          iconView1({ icon: item.icon, title: item.title })
            .width(90)
        }
      }, (item: IconDataModel) => item.id.toString())
    }
    .height(90)
    .width('100%')
    .listDirection(Axis.Horizontal)
    .scrollBar(BarState.Off)
  }
}