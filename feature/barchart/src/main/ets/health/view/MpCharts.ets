import { NewBarChart } from './BarChart'
import { LineCharts } from './LineCharts'

// 心跳当日数据
const HEART_RATE_TODAY_DATA: Array<number> = [75, 70, 85, 75, 83, 72, 79, 80, 83, 86, 79, 86, 93, 80, 76, 78, 85, 91, 81, 78, 85, 93, 87, 79, 73];
// 心跳参考数据
const HEART_RATE_REFERENCE_DATA: Array<number> = [78, 73, 78, 71, 79, 76, 83, 85, 79, 86, 89, 75, 84, 87, 79, 75, 83, 79, 85, 83, 77, 84, 73, 71, 79, 86, 88, 79];
// 步数当日数据
const STEP_NUMBER_TODAY_DATA: Array<number> = [0, 0, 0, 0, 0, 0, 0, 580, 1309, 820, 103, 86, 1715, 1235, 76, 155, 168, 268, 2045, 405, 404, 21, 582, 144, 0];
// 步数参考数据
const STEP_NUMBER_REFERENCE_DATA: Array<number> = [0, 0, 0, 0, 0, 0, 230, 706, 809, 450, 166, 186, 708, 304, 31, 166, 188, 406, 1405, 155, 303, 122, 0, 0, 0, 0, 0, 0];

@Entry({ routeName: 'barchart/MpCharts' })
@Preview
@Component
export struct MpCharts {
  build() {
    List() {
      ListItem() {
        Column() {
          Row() {
            Row() {
              Text("健身记录").fontColor("#1f1f1f").fontSize(20)
              Text("1/1 - 1/7").fontColor("#2f2f2f").fontSize(16)
                .margin({ left: 5 })
            }

            Blank()
            Text("近7天：达标71%").fontColor("#2f2f2f").fontSize(16)
          }.width("100%")

          NewBarChart()
        }
      }.margin({ bottom: 20 })

      ListItem() {
        Column() {
          Row() {
            Text("健康数据")
              .font({ size: 24, weight: FontWeight.Bold, family: "HarmonyHeiTi" })

            Text("1/7")
              .font({ size: 20, weight: FontWeight.Bold, family: "HarmonyHeiTi" })
              .fontColor(Color.Gray)
              .margin({ left: 10 })
              .alignSelf(ItemAlign.End)
          }
          .width("100%")
          .alignItems(VerticalAlign.Bottom)
          .margin({ bottom: 20 })

          Divider().margin({ bottom: 20 }).color("#2c182431")

          Text("心率")
            .font({
              size:20,
              weight:FontWeight.Bold,
              family: "HarmonyHeiTi"
            })
            .alignSelf(ItemAlign.Start)

          // 曲线图组件
          LineCharts({
            type: "heartRate",
            todayData: HEART_RATE_TODAY_DATA,
            referenceData: HEART_RATE_REFERENCE_DATA
          })


          Text("步数")
            .font({
              size: 20,
              weight: FontWeight.Bold,
              family: "HarmonyHeiTi"
            })
            .alignSelf(ItemAlign.Start)

          // 曲线图组件
          LineCharts({
            type: "stepNumber",
            todayData: STEP_NUMBER_TODAY_DATA,
            referenceData: STEP_NUMBER_REFERENCE_DATA
          })
        }
        .width("95%")
        .border({ radius: 15 })
        .shadow({ radius: 10, color: Color.Gray })
        .padding(10)
        .margin({ left: 5, right: 5 })
      }
    }
    .height("100%")
    .width("100%")
    .alignListItem(ListItemAlign.Center)
    .backgroundColor(Color.White)
    .padding(10)
  }
}