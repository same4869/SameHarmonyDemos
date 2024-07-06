/**
 * @Author: xwang
 * @Date: 2024/7/5 16:01
 * @Description:
 **/
import { DateModel } from '../model/DateModel';
import { Month, MonthDataSource } from '../model/MonthDataSource';
import { DataManager } from '../utils/DataManager';
import { getMonthDate } from '../utils/GetData';

const MONTHS = 12;
const JANUARY = 1;
const WEEK_NUMBER = 7;
const MONTH_NUMBER = 35;
const GRID_HEIGHT_L = 360;
const GRID_HEIGHT_M = 300;
const ELEMENTS_MARGIN = 12;
const MONDAY = '一';
const TUESDAY = '二';
const WEDNESDAY = '三';
const THURSDAY = '四';
const FRIDAY = '五';
const SATURDAY = '六';
const SUNDAY = '日';

@CustomDialog
export struct CustomCalendarPickerDialog {
  controller: CustomDialogController; // 通过CustomDialogController类显示自定义弹窗
  private week: string[] = [SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY]; // 设置日历周，从周日开始
  @State initialIndex: number = 0; // List初次加载时视口起始位置
  @State contentData: MonthDataSource = new MonthDataSource(); // 列表数据
  @State currentMonthDay: number[] = []; // 初始化当前月的日期排列数组
  @Link currentMonth: number; // 当前月份
  @Link currentDay: number; // 当前日
  @Link currentYear: number; // 当前年份
  @State nextMonth: number = 1; // 初始化下一个月月份
  @State nextYear: number = 1; // 初始化下一个月年份
  @State nextMonthDay: number[] = []; // 初始化下一个月的日期排列数组
  @StorageLink('selectedDate') dateModel: DateModel = new DateModel(0, 0, 0, 0); // 初始化dateModel数据
  cancel: () => void = () => {
  }; //点击遮障层退出时的回调

  aboutToAppear(): void {
    this.currentMonthDay = getMonthDate(this.currentMonth, this.currentYear);
    // 如果下个月是在下一年，则下个月是1月份，年份要+1
    if (this.currentMonth === MONTHS) {
      this.nextMonth = JANUARY;
      this.nextYear = this.currentYear + 1;
    }
    // 如果下个月是还是当前年，则月份+1，年份不变
    else {
      this.nextMonth = this.currentMonth + 1;
      this.nextYear = this.currentYear;
    }
    this.nextMonthDay = getMonthDate(this.nextMonth, this.nextYear);
    // 获取当前月和下个月的日期数据
    let months: Month[] = [
      {
        month: `${this.currentYear}年 ${this.currentMonth}月`,
        num: this.currentMonth,
        days: this.currentMonthDay
      },
      {
        month: `${this.nextYear}年 ${this.nextMonth}月`,
        num: this.nextMonth,
        days: this.nextMonthDay
      }
    ]
    this.contentData.pushData(months);
    this.initialIndex = this.dateModel.month > this.currentMonth ? 1 : 0; // 设置List初次加载时视口起始位置显示的item的索引值
  }

  // 显示日历布局的每个月上方的年月信息
  @Builder
  itemHead(text: string) {
    Text(text)
      .backgroundColor("#f1f3f5")
      .width('100%')
      .height(40)
      .textAlign(TextAlign.Center)
  }

  build() {
    Column({ space: ELEMENTS_MARGIN }) {
      Text("出发时期")
        .fontSize(20)

      List() {
        ForEach(this.week, (weekInformation: string) => {
          ListItem() {
            Text(weekInformation)
              .textAlign(TextAlign.Center)
              .width("100%")
              .height(20)
              .fontColor(weekInformation == SUNDAY || weekInformation === SATURDAY ? "#e84026" : "#e5000000")
          }
          .width("14.3%")
        })
      }
      .width("100%")
      .height(20)
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)

      List({ initialIndex: this.initialIndex }) {
        LazyForEach(this.contentData, (monthItem: Month) => {
          // 设置ListItemGroup头部组件，显示年份和月份
          ListItemGroup({ header: this.itemHead(monthItem.month) }) {
            ListItem() {
              Grid() {
                ForEach(monthItem.days, (day: number) => {
                  GridItem() {
                    Text(day.toString())
                      .fontSize(20)
                      .fontColor(day < this.currentDay && monthItem.num ===
                      this.currentMonth ? "#99000000" : "#e5000000")
                  }
                  .borderRadius(12)
                  .backgroundColor(day === this.dateModel.day && monthItem.num ===
                  this.dateModel.month ? "#ed6f21" : "#ffffff")
                  .opacity(day === 0 ? 0 : 1) // 将日期数组中为0的都设置为不显示，即不显示上个月和下个月的内容
                  // 点击选定的日期后，关闭日历弹窗，显示日期改变为选择的日期
                  .onClick(() => {
                    if(day >= this.currentDay || monthItem.num > this.currentMonth){
                      let weekIndex = monthItem.days.indexOf(day) % WEEK_NUMBER // 将当前日转换成星期显示
                      this.dateModel.day = day;
                      this.dateModel.week = weekIndex;
                      this.dateModel.month = monthItem.num;
                      DataManager.setDate(getContext(this), this.dateModel, () => {});
                      this.controller.close(); // 关闭自定义弹窗
                    }
                  })
                })
              }
              .backgroundColor("#ffffff")
              .columnsTemplate("1fr 1fr 1fr 1fr 1fr 1fr 1fr")
              // 当前月显示的数组元素个数大于35则显示6行，否则显示5行
              .rowsTemplate(monthItem.days.length > MONTH_NUMBER ? '1fr 1fr 1fr 1fr 1fr 1fr' : '1fr 1fr 1fr 1fr 1fr')
              .height(monthItem.days.length > MONTH_NUMBER ? GRID_HEIGHT_L : GRID_HEIGHT_M)
            }
          }
        })
      }
      .height("90%")
      .width("100%")
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .sticky(StickyStyle.Header)
    }
    .padding({ top: ELEMENTS_MARGIN })
    .width("100%")
    .height("85%")
    .transition(TransitionEffect.translate({ x: 0, y: 800 }).animation({ duration: 200 }))
    .backgroundColor("#ffffff")
    .borderRadius(8)
    .alignItems(HorizontalAlign.Center)
  }
}