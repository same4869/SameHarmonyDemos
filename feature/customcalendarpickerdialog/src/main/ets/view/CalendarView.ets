/**
 * @Author: xwang
 * @Date: 2024/7/5 15:38
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import { MToast } from '@same/common';
import { CustomCalendarPickerDialog } from './CustomCalendarPickerDialog';
import { DateModel } from '../model/DateModel';
import { getRealTimeDate } from '../utils/GetData';

/**
 * 自定义日历选择器
 * 通过Date对象获取当前年月日等具体时间数据，用于日历数据的显示
 * 通过CustomDialogController类显示自定义弹窗，自定义弹窗内容显示为自定义日历
 * 点击主页面当前时间，弹出自定义日历，可以选择日历时间，主页面的时间随之改变
 */

const ELEMENTS_MARGIN_L = 24;
const ELEMENTS_MARGIN_M = 8;

@AppRouter({ name: "customcalendarpickerdialog/CalendarView" })
@Component
export struct CalendarView {
  private week: string[] = ['日', '一', '二', '三', '四', '五', '六']; // 设置日历周，从周日开始
  @State currentMonth: number = 1; // 当前月份
  @State currentDay: number = 1; // 当前日
  @State currentYear: number = 1; // 当前年分
  @StorageLink('selectedDate') dateModel: DateModel = new DateModel(0, 0, 0, 0); // 初始化dateModel数据

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomCalendarPickerDialog({
      currentMonth: this.currentMonth,
      currentDay: this.currentDay,
      currentYear: this.currentYear,
      cancel: this.onCancel
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  // 获取当前日期
  aboutToAppear(): void {
    let dateModel: DateModel = getRealTimeDate(); // 获取当前年月日信息
    this.currentMonth = dateModel.month; // 获取当前月份
    this.currentDay = dateModel.day; // 获取当前日
    this.currentYear = dateModel.year; // 获取当前年份
  }

  // 点击遮障层退出时的回调
  onCancel() {
    MToast.showToast("dialog onCancel")
  }

  build() {
    Column() {
      this.calendarMainView()
    }
    .backgroundColor("#f1f3f5")
    .width("100%")
    .height("100%")
    .padding(12)
  }

  @Builder
  calendarMainView() {
    Column({ space: ELEMENTS_MARGIN_L }) {
      Row() {
        Text("北京")
          .fontSize(20)
        Image($r("app.media.customcalendarpickerdialog_train_transport_icon"))
          .height(20)
          .width(20)
        Text("上海")
          .fontSize(20)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width("100%")

      Row({ space: ELEMENTS_MARGIN_M }) {
        Text(`${this.dateModel.month}月${this.dateModel.day}日`)
          .fontSize(20)
        Text(`星期${this.week[this.dateModel.week]}`)
          .fontSize(14)
      }.justifyContent(FlexAlign.Start)
      .width("100%")
      .onClick(() => {
        // 点击当前日期后打开自定义弹窗显示日历
        this.dialogController.open()
      })

      Button("检查车票")
        .fontSize(20)
        .height(40)
        .width("100%")
        .type(ButtonType.Normal)
        .borderRadius(12)
        .onClick(() => {
          MToast.showToast("没有实现")
        })
    }
    .backgroundColor("#ffffff")
    .padding(16)
    .borderRadius(12)
  }
}