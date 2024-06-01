import { promptAction } from '@kit.ArkUI'
import { IconAndDescription, Size } from '../utils/Util';

@Preview
@Entry({ routeName: 'slidetohideanddisplace/SlideToHideAndDisplace' })
@Component
export struct SlideToHideAndDisplace {
  @State userNameOpacity: number = 1
  @State userRowOpacity: number = 1
  // 用户头像图片高度
  @State userImageHeight: number = 50;
  // 用户头像图片顶部与父组件Row的上边距
  @State userImageMarginTop: number = 0;
  // 用户头像图片左侧与父组件Row的左边距
  @State userImageMarginLeft: number = 0;
  // Scroll组件顶部与上方Row组件(个人信息栏)的上边距
  @State scrollMarginTop: number = 0;
  // 可滑动容器组件的控制器
  scroller: Scroller = new Scroller();
  // 订单相关的图标和描述的数据列表
  iconsAndDescriptions1: IconAndDescription[] = [
    new IconAndDescription($r("app.media.slidetohideanddisplace_payment"), "待支付"),
    new IconAndDescription($r("app.media.slidetohideanddisplace_payment"), "待收货"),
    new IconAndDescription($r("app.media.slidetohideanddisplace_payment"), "待评价"),
    new IconAndDescription($r("app.media.slidetohideanddisplace_payment"), "更多")
  ]
  // 粉丝/收藏/关注/历史相关的栏目的图标和描述的数据列表
  iconsAndDescriptions2: IconAndDescription[] = [
    new IconAndDescription($r("app.media.slidetohideanddisplace_payment"), "粉丝"),
    new IconAndDescription($r("app.media.slidetohideanddisplace_payment"), "收藏"),
    new IconAndDescription($r("app.media.slidetohideanddisplace_payment"), "关注"),
    new IconAndDescription($r("app.media.slidetohideanddisplace_payment"), "历史")
  ]
  // 商品会场的图标和描述的数据列表
  merchandiseVenue: IconAndDescription[] = [
    new IconAndDescription($r("app.media.slidetohideanddisplace_arc_of_light"), "主会场"),
    new IconAndDescription($r("app.media.slidetohideanddisplace_arc_of_light"), "抢神券"),
    new IconAndDescription($r("app.media.slidetohideanddisplace_arc_of_light"), "直播主会场"),
    new IconAndDescription($r("app.media.slidetohideanddisplace_arc_of_light"), "十亿补贴"),
  ]

  /**
   * 创建一个Row组件，用来显示用户信息，然后在下面创建一个Scroll组件，用来显示其他内容，
   * 当Scroll滑动时，Row组件隐藏且里面的子组件渐隐
   */
  build() {
    Column() {
      Row() {
        Text("返回")
          .onClick(() => {
            promptAction.showToast({ message: "返回" })
          })

        Text("蝙蝠侠").margin({ left: 30 }).opacity(this.userNameOpacity)

        Blank()

        Text("设置").opacity(this.userNameOpacity)
          .onClick(() => {
            if (this.userNameOpacity > 0.2) {
              promptAction.showToast({ message: "设置" })
            }
          })

        Text("客服").opacity(this.userNameOpacity)
          .onClick(() => {
            if (this.userNameOpacity > 0.2) {
              promptAction.showToast({ message: "客服" })
            }
          })
          .margin({ left: 10 })
      }.width("100%")
      .alignItems(VerticalAlign.Center)

      Row() {
        Image($r("app.media.slidetohideanddisplace_batman"))
          .width(this.userImageHeight)
          .height(this.userImageHeight)
          .margin({ top: this.userImageMarginTop, left: this.userImageMarginLeft })

        Column() {
          Text("蝙蝠侠")
          Button("身份选择").size({ width: 80, height: 20 }).fontColor(Color.White)
            .margin({ top: 5 }).onClick(() => {
            promptAction.showToast({ message: "身份选择" })
          })
        }
        .alignItems(HorizontalAlign.Start)
        .opacity(this.userRowOpacity)
        .padding(10)

        Blank()

        Row() {
          this.iconAndDescription($r("app.media.slidetohideanddisplace_setting"), "设置", new Size(24, 24))
          this.iconAndDescription($r("app.media.slidetohideanddisplace_dialog"), "客服", new Size(24, 24))
        }.width(80)
        .justifyContent(FlexAlign.SpaceBetween)
        .opacity(this.userRowOpacity)
      }.height(100).width("100%")
      .hitTestBehavior(this.userRowOpacity < 0.2 ? HitTestMode.Block : HitTestMode.Default)

      Scroll(this.scroller) {
        Column() {
          this.memberBanner()

          // 订单信息栏目
          this.customRow(this.iconsAndDescriptions1)
          // 粉丝/收藏/关注/历史栏目
          this.customRow(this.iconsAndDescriptions2)

          this.shoppingVenue()
        }
        .height("100%")
        .width("100%")
      }
      .height("120%")
      .margin({ top: this.scrollMarginTop })
      .scrollBar(BarState.Off)
      .onScroll(() => {
        // TODO: 知识点: Scroll组件绑定onScroll事件，然后在此方法里改变该组件的margin和opacity属性值的大小实现组件移动和隐显
        // 性能知识点: onScroll属于频繁回调，不建议在onScroll做耗时和冗余操作
        const yOffset: number = this.scroller.currentOffset().yOffset
        this.userRowOpacity = yOffset < 60 ? 1 - yOffset / 60 : 0

        if(yOffset < 76){
          this.scrollMarginTop = -yOffset
          this.userImageHeight = 50 * (1-(yOffset/130))
          this.userImageMarginTop = -yOffset * 1.56
          this.userImageMarginLeft = 20 * (yOffset / 60) * 1.56;
          if (yOffset > 40) {
            this.userNameOpacity = (yOffset - 40) / 40;
          } else {
            this.userNameOpacity = 0;
          }
        }else {
          this.userImageHeight = 50 * (1 - (76 / 130));
          this.userImageMarginTop = -76 * 1.56;
          this.userImageMarginLeft = 20 * (76 / 60) * 1.56;
          this.userNameOpacity = 1;
        }
      })

    }.width("100%")
    .height("100%")
    .padding(12)
    .linearGradient({
      angle: 180,
      colors: [[0xffffff, 0.0], [0xfff1f1, 0.2], [0xffdddd, 0.8], [0xffffff, 1.0]]
    })
  }

  @Builder
  iconAndDescription(icon: Resource, description: ResourceStr, iconSize?: Size, radius?: number) {
    Column() {
      Image(icon)
        .size(iconSize === undefined ? {
          width: 32,
          height: 32
        } : iconSize)
        .borderRadius(radius)
      Text(description)
        .margin({ top: 5 })
    }
    .onClick(() => {
      promptAction.showToast({ message: description })
    })
  }

  @Builder
  memberBanner() {
    Row() {
      Column() {
        Text("开通会员")
          .fontSize(20)
          .fontColor("#ffdd00")
        Text("购物享首单立减")
          .margin({ top: 5 })
          .fontColor("#cd9900")
      }
      .alignItems(HorizontalAlign.Start)
      .padding(10)

      Blank() // 在容器主轴方向上自动填充容器空余部分

      Column() {
        Image($r("app.media.slidetohideanddisplace_crown"))
          .size({ width: 32, height: 32 })
        Text("权益中心")
          .margin({ top: 5 })
          .fontColor("ffd247")
      }
      .padding(10)
    }
    .height(80)
    .width("100%")
    .borderRadius(8)
    .linearGradient({
      angle: 45,
      colors: [[0x30fa908a, 0.0], [0x44aaaaa, 0.5], [0x30c2b1fa, 1.0]]
    })
    .onClick(() => {
      promptAction.showToast({ message: "会员服务" });
    })
  }

  @Builder
  customRow(iconsAndDesc: IconAndDescription[]) {
    Row() {
      ForEach(iconsAndDesc, (item: IconAndDescription) => {
        Column() {
          this.iconAndDescription(item.icon, item.description)
        }.width((100 / iconsAndDesc.length).toString() + "%")
      })
    }
    .width("100%")
    .padding(10)
    .margin({ top: 10 })
    .backgroundColor("#aaffffff")
    .borderRadius(8)
  }

  @Builder
  shoppingVenue() {
    Column() {
      Text("橘子购物节")
        .fontSize(20)
        .fontColor("#ffa4750d")
        .width("100%")
        .margin({ left: 10, top: 10 })

      Grid() {
        ForEach(this.merchandiseVenue, (item: IconAndDescription) => {
          GridItem() {
            this.iconAndDescription(item.icon, item.description, new Size(200, 150), 8)
          }
        })
      }
      .columnsTemplate("1fr 1fr")
      .rowsGap(10)
      .width("100%")
      .height(460)
      .margin({ top: 10 })
    }
    .backgroundColor("#55ffffff")
    .margin({ top: 10, bottom: 10 })
    .borderRadius(8)
  }
}