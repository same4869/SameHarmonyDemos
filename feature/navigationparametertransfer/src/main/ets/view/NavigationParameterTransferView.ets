import { AppRouter, DynamicsRouter } from '@ohos/dynamicsRouter'
import { MToast } from '@same/common'
import { plainToClass } from 'class-transformer';
import { UserBookingInfo } from '../model/UserBookingInfo';

@Preview
@Component
@AppRouter({ name: "navigationparametertransfer/NavigationParameterTransferView", hasParam: true })
export struct NavigationParameterTransferView {
  @State userName: string = '';
  @State userID: string = '';
  @State seatNo: string = "";
  private userBooking: UserBookingInfo = new UserBookingInfo('', '', '')
  pageStack: NavPathStack = DynamicsRouter.navPathStack;

  getParams() {
    const bookingString: string =
      this.pageStack.getParamByName("navigationparametertransfer/NavigationParameterTransferView")[0] as string
    // 转化成普通对象
    const userBookingTmp: UserBookingInfo = JSON.parse(bookingString);
    // TODO：知识点：通过调用第三方插件class-transformer的plainToClass方法转换成类对象, 不进行转换直接使用userBookingTmp调用getUserInfo方法会造成crash
    this.userBooking = plainToClass(UserBookingInfo, userBookingTmp);
    this.userName = this.userBooking.userName;
    this.userID = this.userBooking.userID;
    // TODO：知识点：调用转换后的类对象的方法
    this.seatNo = this.userBooking.generateRandSeatNo().toString();
  }

  aboutToAppear(): void {
    this.getParams()
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text("您的购票信息为：")
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Normal)
            .margin(10)
            .align(Alignment.Start)
        }

        Row() {
          Text("出发时间")
            .fontSize(18)
            .width("35%")
            .textAlign(TextAlign.End)
            .fontWeight(FontWeight.Normal)
            .margin(5)
            .align(Alignment.End)
          Text("aaaaaaa")
            .width("55%")
            .margin(5)
            .fontSize(14)
        }

        Row() {
          Text("座位号：")
            .fontSize(18)
            .width("35%")
            .fontWeight(FontWeight.Normal)
            .margin(5)
            .textAlign(TextAlign.End)
            .align(Alignment.End)
          Text(this.seatNo)
            .width("20%")
            .margin(5)
            .textAlign(TextAlign.JUSTIFY)
            .fontSize(14)
          Text("换个座位")
            .width("35%")
            .fontColor("#0A59F7")
            .fontSize(14)
            .backgroundColor("#ffffff")
            .onClick(() => {
              // 调用主页传过来的类对象的generateRandSeatNo方法
              this.seatNo = this.userBooking.generateRandSeatNo().toString();
            })
        }

        Row() {
          Text("价格")
            .fontSize(18)
            .width("35%")
            .fontWeight(FontWeight.Normal)
            .margin(5)
            .textAlign(TextAlign.End)
            .align(Alignment.End)

          Text("cccccccc")
            .width("55%")
            .margin(5)
            .fontSize(14)
        }

        Row() {
          Text("用户姓名")
            .fontSize(18)
            .width("35%")
            .textAlign(TextAlign.End)
            .fontWeight(FontWeight.Normal)
            .margin(5)
            .align(Alignment.End)
          Text(this.userName)
            .width("55%")
            .margin(5)
            .fontSize(14)
        }

        Row() {
          Text("身份证号：")
            .fontSize(18)
            .width("35%")
            .fontWeight(FontWeight.Normal)
            .margin(5)
            .textAlign(TextAlign.End)
            .align(Alignment.End)
          Text(this.userID)
            .width("55%")
            .margin(5)
            .fontSize(14)
        }

        Row() {
          Button("提交订单")
            .onClick(() => {
              MToast.showToast("暂未实现")
            })
            .margin(5)
        }
      }
      .backgroundColor("#ffffff")
      .border({
        width: 1,
        color: "#317af7",
        radius: 10,
        style: BorderStyle.Solid
      })
    }
    .padding(12)
  }
}