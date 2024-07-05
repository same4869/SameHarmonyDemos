/**
 * @Author: xwang
 * @Date: 2024/7/5 16:01
 * @Description:
 **/

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

  build() {
    Column({ space: ELEMENTS_MARGIN }) {
      Text("出发时期")
        .fontSize(20)



    }
    .padding({ top: ELEMENTS_MARGIN })
    .width("100%")
    .height("85%")
    .transition(TransitionEffect.translate({ x: 0, y: 800 }).animation({ duration: 200 }))
    .borderRadius("#ffffff")
    .alignItems(HorizontalAlign.Center)
  }
}