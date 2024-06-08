import { CommonLazyDataSourceModel, FunctionDescription } from '@same/common/Index'
import { promptAction } from '@kit.ArkUI'
import axios, { Axios, AxiosResponse } from '@ohos/axios';
import { util } from '@kit.ArkTS';

const URL: string =
  'https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/gbktranscoding/src/main/ets/resources/rawfile/mockData.txt'

@Preview
@Entry({ routeName: 'gbktranscoding/FriendsBook' })
@Component
export struct FriendsBook {
  private friendsListData: FriendListData = new FriendListData();

  build() {
    Column() {
      Row() {
        FunctionDescription({
          title: "功能描述",
          content: "使用Axios获取编码格式为GBK的数据，使用TextDecoder解码成UTF-8。"
        })
      }

      Text("通讯录")
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .lineHeight(33)
        .fontColor("#182431")
        .fontFamily("HarmonyHeiTi")
        .size({ width: "100%", height: 56 })

      Row() {
        Search({ placeholder: "搜索" })
          .enableKeyboardOnFocus(false)
          .placeholderFont({ size: 16 })
          .searchIcon({
            src: $r("app.media.gbk_search_svg"),
            size: 18
          })
          .placeholderColor("rgba(24,36,49,0.20)")
          .backgroundColor(Color.White)
          .height(40)
          .width("100%")
          .textFont({ size: 16 })
          .border({
            width: 1.5,
            color: "rgba(24,36,49,0.20)"
          })
          .borderRadius(20)
          .id("search")
          .onClick(() => {
            promptAction.showToast({ message: "此样式仅为案例展示" })
          })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height(56)
      .width("100%")
      .backgroundColor("#ffffff")
      .margin({ top: 10 })

      Column() {
        List({
          space: 0, initialIndex: 0
        }) {
          LazyForEach(this.friendsListData, (msg: FriendData) => {
            ListItem() {
              ChatContactItemView({ text: msg.userName })
            }
          })
        }
        .layoutWeight(1)
        .divider({
          strokeWidth: 1,
          color: "0c000000",
          startMargin: 56
        })
      }
      .layoutWeight(1)
    }
    .backgroundColor("#ffffff")
    .width("100%")
    .height("100%")
    .padding({
      left: 24,
      right: 24
    })
  }

  aboutToAppear(): void {
    // TODO: 知识点: 使用Axios获取Response.data为GBK格式的网络数据。
    axios<string, AxiosResponse<string>, null>({
      method: "get",
      url: URL,
      // 在使用util.TextDecoder方法时，编码和解码格式要一致，所以在获取时需将数据类型设置为ARRAY_BUFFER，否则会出现乱码。
      responseType: "ARRAY_BUFFER"
    })
      .then((res: AxiosResponse) => {
        // TODO: 知识点: 使用util.TextDecoder解码。
        // 首先使用create构造TextDecoder实例，将编码格式设置为gbk。
        const textDecoder = util.TextDecoder.create('gbk', { ignoreBOM: true })
        // 其次使用decodeWithStream方法通过解码输入的参数，输出对应UTF-8格式的文本字符串。其中传入的参数必须为Uint8Array格式，因此需将获取的数据使用Uint8Array方法转换数组类型。
        const result = new Uint8Array(res.data)
        const resultString = textDecoder.decodeWithStream(result, { stream: false });
        //解析json字符串
        const jsonResult = JSON.parse(resultString) as JsonResult
        const jsonObj: Array<FriendData> = jsonResult.ListModel;
        // 映射json数据为friendsListData对象。
        for (let i = 0; i < jsonObj.length; i++) {
          const contactTemp = new FriendData(jsonObj[i].userId, jsonObj[i].userName);
          this.friendsListData.pushData(contactTemp);
        }
      })
  }
}

class JsonResult {
  ListModel: Array<FriendData> = [];
}

@Component
export struct ChatContactItemView {
  private text: ResourceStr = ""

  build() {
    Row() {
      Image($r("app.media.gbk_userImage"))
        .width(40)
        .height(40)
        .borderRadius(20)
      Text(this.text)
        .width(248)
        .height(22)
        .fontSize(16)
        .fontFamily("HarmonyHeiTi")
        .fontColor("#182431")
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16 })
    }
    .width("100%")
    .height(64)
    .backgroundColor(Color.White)
  }
}

class FriendData {
  userId: string
  userName: ResourceStr

  constructor(userId: string, userName: ResourceStr) {
    this.userId = userId;
    this.userName = userName;
  }

  toString(): string {
    return this.userId + '  ' + this.userName
  }
}

class FriendListData extends CommonLazyDataSourceModel<FriendData> {
}