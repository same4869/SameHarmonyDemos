/**
 * @Author: xwang
 * @Date: 2024/8/5 13:08
 * @Description:
 **/
import { promptAction } from '@kit.ArkUI'
import { AppRouter, DynamicsRouter } from '@ohos/dynamicsRouter'
import { MToast } from '@same/common/src/main/ets/utils/MToast'

@AppRouter({ name: "listitemoverflow/AboutMe" })
@Component
export struct AboutMe {
  build() {
    // TODO 知识点：List占满整个窗口或者不可滚动的情况下，也可以可以在List外部使用Row占位
    List({ initialIndex: 0, space: 20 }) {
      // TODO 知识点：在List内部使用ListItem占位，包住超出的区域
      // 占位组件
      ListItem().height(40).selectable(false)

      //用户信息
      ListItemGroup({ style: ListItemGroupStyle.CARD }) {
        ListItem({ style: ListItemStyle.CARD }) {
          this.userInfoItem(
            $r("app.media.listitem_overflow_io_user_portrait"),
            "请设置昵称",
            "编辑功能暂未开放"
          )
        }.height(60)

        ListItem({ style: ListItemStyle.CARD }) {
          this.signItem("这个人很懒，没有签名", "编辑功能暂未开放")
        }
        .height(60)
      }
      .divider({ strokeWidth: 1, color: "#f1f3f5" })

      ListItemGroup({ style: ListItemGroupStyle.CARD }) {
        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_bank_cards"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)

        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_gift_cards"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)

        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_credit_card"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)

        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_payment"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)

        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_health"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)

        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_travel"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)

        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_ticket"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)
      }
      .divider({
        strokeWidth: 1,
        color: "#f1f3f5",
        startMargin: 60
      })

      ListItemGroup({ style: ListItemGroupStyle.CARD }) {
        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_highlightsed"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)

        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_settings"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)

        ListItem({ style: ListItemStyle.CARD }) {
          this.featureItem(
            $r("app.media.listitem_overflow_io_about"),
            "钱包",
            "未绑定银行卡"
          )
        }.height(60)
      }
      .divider({
        strokeWidth: 1,
        color: "#f1f3f5",
        startMargin: 60
      })

      //页脚
      ListItem() {
        Text("退出登录")
          .fontSize($r("sys.float.ohos_id_text_size_body2"))
          .fontColor(Color.Red)
          .margin(15)
          .onClick(() => {
            DynamicsRouter.popAppRouter()
          })
          .width('100%')
          .textAlign(TextAlign.Center)
      }.height(60)

    }
    .layoutWeight(1)
    .listDirection(Axis.Vertical)
    .edgeEffect(EdgeEffect.Spring)
    .backgroundColor("#f1f3f5")
    .width("100%")
    .height("100%")
  }

  @Builder
  userInfoItem(portrait: ResourceStr, username: ResourceStr, prompt: ResourceStr) {
    Row() {
      // TODO 知识点：通过设置负的margin值，移动头像框位置，使其超出父组件范围
      Image(portrait)
        .width(80)
        .height(80)
        .margin({
          top: -50,
          left: 15
        })
        .borderRadius(5)
        .clip(true)

      Text(username)
        .fontSize($r("sys.float.ohos_id_text_size_sub_title1"))
        .margin(15)
        .fontWeight(FontWeight.Bold)
    }
    .width("100%")
    .toastOnClick(prompt)
  }

  @Builder
  signItem(text: ResourceStr, prompt: ResourceStr) {
    Text(text)
      .width("100%")
      .fontSize($r("sys.float.ohos_id_text_size_body2"))
      .fontColor(Color.Grey)
      .margin(15)
      .width("100%")
      .clickEffect({ level: ClickEffectLevel.HEAVY })
      .onClick(() => {
        MToast.showToast(prompt)
      })
  }

  @Builder
  featureItem(icon: ResourceStr, text: ResourceStr, prompt: ResourceStr) {
    Row() {
      Image(icon).imageStyle()
      Text(text)
        .fontSize($r("sys.float.ohos_id_text_size_body1"))
        .margin(15)
    }
    .width("100%")
    .toastOnClick(prompt)
  }
}

@Extend(Row)
function toastOnClick(msg: ResourceStr) {
  .clickEffect({ level: ClickEffectLevel.HEAVY })
  .onClick(() => {
    promptAction.showToast({ message: msg })
  })
}

@Extend(Image)
function imageStyle() {
  .width(30)
  .height(30)
  .margin(15)
}