import {
  AxisBase,
  ChartColorStop,
  Description,
  EntryOhos,
  IAxisValueFormatter,
  ILineDataSet,
  JArrayList,
  Legend,
  LegendForm,
  LegendOrientation,
  LineChart,
  LineChartModel,
  LineData,
  LineDataSet,
  Mode,
  XAxis,
  XAxisPosition,
  YAxis,
  YAxisLabelPosition,
  LegendVerticalAlignment,
  LegendHorizontalAlignment,
} from '@ohos/mpchart'
import { CustomUiInfo } from '../model/BasicDataSource';
import { EventType } from '@ohos/mpchart/src/main/ets/components/listener/EventControl';

@Preview
@Component
export struct LineCharts {
  @Prop type: string = "heartRate"; // 设置线形图类型（心率或步数）
  @Prop referenceData: Array<number | null>; // 参考数据
  @Prop todayData: Array<number | null>; // 当日数据
  model: LineChartModel | null = null; // 线形图模型
  private leftAxis: YAxis | null = null; // 左侧Y轴数据
  private rightAxis: YAxis | null = null; // 右侧Y轴数据
  private xAxis: XAxis | null = null; // X轴数据
  @State lineData: LineData = new LineData(); // 线形图数据
  @State customUiInfo: CustomUiInfo = new CustomUiInfo("heartRate", 90, 50); // 图表的Marker(标志气泡)组件

  // 图表Marker(标志气泡)组件
  @Builder
  customUi() {
    // 是否在图表content内
    if (this.customUiInfo.isInbounds && this.customUiInfo.data) {
      Column() {
        Text(this.customUiInfo.getFormattedValue())
          .fontColor(Color.White)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
        Text(`${this.customUiInfo.type === "heartRate" ? "心率" : "步数"}： ${JSON.stringify(this.customUiInfo.data.getY())}`)
          .fontColor(Color.White)
          .fontSize(12)
      }
      .padding(4)
      .borderRadius(6)
      .border({
        width: 1,
        color: this.customUiInfo.type === "heartRate" ? Color.Orange : Color.Blue
      })
      .backgroundColor("#99000000")
      .width(this.customUiInfo.width)
      .height(this.customUiInfo.height)
      .margin({ left: this.customUiInfo.x, top: this.customUiInfo.y })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.customUiInfo.showUi = false;
      })
    }
  }

  aboutToAppear(): void {
    // 构建Marker组件
    this.customUiInfo = new CustomUiInfo(this.type, 90, 50);
    // TODO 知识点：必须初始化图表配置构建类
    this.model = new LineChartModel();
    this.model.setPinchZoom(false);
    this.model.setDrawGridBackground(false);
    // TODO 知识点：配置图表指定样式，各部件间没有先后之分
    // 获取图表描述部件，设置图表描述部件不可用，即图表不进行绘制描述部件
    const description: Description | null = this.model.getDescription();
    if (description) {
      description.setEnabled(false);
    }
    // 设置X轴信息
    this.xAxis = this.model.getXAxis();
    if (this.xAxis) {
      //设置标签位置
      this.xAxis.setPosition(XAxisPosition.BOTTOM);
      // 设置X轴是否绘制网格线
      this.xAxis.setDrawGridLines(true);
      this.xAxis.setGranularity(1);
      // 设置数据的格式转换器
      this.xAxis.setValueFormatter(new XValueFormatter());
      // 设置绘制标签个数
      this.xAxis.setLabelCount(10);
      this.xAxis.enableGridDashedLine(2, 2, 0);
    }
    // 设置图表左Y轴信息
    this.leftAxis = this.model.getAxisLeft();
    if (this.leftAxis) {
      this.leftAxis.setLabelCount(4, true);
      this.leftAxis.setDrawGridLines(true);
      // 设置图表左Y轴是否在数据后绘制限制线
      this.leftAxis.setDrawGridLinesBehindData(true);
      this.leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART);
      this.leftAxis.setAxisMinimum(0);
      // 设置图表左Y轴数据的格式转换器
      this.leftAxis.setValueFormatter(new YValueFormatter());
      this.leftAxis.setEnabled(true);
      this.leftAxis.enableGridDashedLine(2, 2, 0);
    }
    // 设置图表右Y轴信息
    this.rightAxis = this.model.getAxisRight();
    if (this.rightAxis) {
      // 设置图表右Y轴是否显示
      this.rightAxis.setEnabled(false);
    }
    // 获取图表图例部件，设置图表图例部件不可用
    const legend: Legend | null = this.model.getLegend();
    if (legend) {
      legend.setEnabled(true);
      // 设置图例类型
      legend.setForm(LegendForm.LINE);
      // 设置图例文本大小
      legend.setTextSize(14);
      // 设置图例方向为水平
      legend.setOrientation(LegendOrientation.HORIZONTAL);
      // 设置图例垂直对齐方式为顶部
      legend.setVerticalAlignment(LegendVerticalAlignment.TOP);
      // 设置图例水平对齐方式为左对齐
      legend.setHorizontalAlignment(LegendHorizontalAlignment.LEFT);
    }
    // TODO 知识点：将数据与图表配置类绑定
    this.model.setData(this.lineData);
    // 设置模型是否可缩放
    this.model.setScaleEnabled(false);

    this.lineData = this.getLineData();
    if (this.model) {
      this.model.setData(this.lineData);
      this.model.invalidate();
    }
  }

  // 生成线形图数据
  private getLineData(): LineData {
    const START: number = 0;
    const values: JArrayList<EntryOhos> = new JArrayList<EntryOhos>();
    const values2: JArrayList<EntryOhos> = new JArrayList<EntryOhos>();
    for (let i = START; i < this.todayData.length; i++) {
      values.add(new EntryOhos(i, this.todayData[i]));
    }
    for (let i = START; i < this.referenceData.length; i++) {
      values2.add(new EntryOhos(i, this.referenceData[i]));
    }
    const dataSetList: JArrayList<ILineDataSet> = new JArrayList<ILineDataSet>();
    const dataSet = new LineDataSet(values, '今日');
    // 设置数据高亮颜色
    dataSet.setHighLightColor(Color.Red);
    // 设置数据高亮线的宽度
    dataSet.setHighlightLineWidth(0.1);
    // 不绘制数据值
    dataSet.setDrawValues(false);
    dataSet.setLineWidth(1.5);
    dataSet.setDrawIcons(false);
    // 设置曲线为贝塞尔曲线模式
    dataSet.setMode(Mode.CUBIC_BEZIER);
    // 折线点不画圆圈
    dataSet.setDrawCircles(false);
    // 设置曲线颜色
    dataSet.setColorByColor(this.customUiInfo.type === "heartRate" ? Color.Orange : Color.Blue);
    const gradientFillColor = new JArrayList<ChartColorStop>();
    gradientFillColor.add([this.customUiInfo.type === "heartRate" ? '#FFFAE8C2' : '#0099CC', 0.2]);
    gradientFillColor.add([this.customUiInfo.type === "heartRate" ? '#FFFBF4DE' : '#7F0099CC', 0.6]);
    gradientFillColor.add([this.customUiInfo.type === "heartRate" ? '#FFFDFCF5' : '#0C0099CC', 1.0]);
    // 设置渐变色填充
    dataSet.setGradientFillColor(gradientFillColor);
    dataSet.setDrawFilled(true);
    dataSetList.add(dataSet);
    const dataSet2 = new LineDataSet(values2, "参考");
    dataSet2.setHighLightColor(Color.Black);
    dataSet2.setHighlightLineWidth(0.1);
    dataSet2.setDrawValues(false);
    dataSet2.setLineWidth(1.5);
    dataSet2.setDrawIcons(false);
    dataSet2.setMode(Mode.CUBIC_BEZIER);
    dataSet2.setDrawCircles(false);
    dataSet2.setColorByColor(Color.Green);
    dataSetList.add(dataSet2);
    return new LineData(dataSetList);
  }

  build() {
    LineChart({
      model: this.model,
      // 自定义 ui: 传入 builder
      customUiBuilder: this.customUi,
      // 通过什么事件触发
      customUiTriggerEvent: EventType.SingleTap,
      // 自定义ui的位置信息
      customUiInfo: this.customUiInfo,
    })
      .width("100%")
      .height("40%")
      .margin({ top: 5, bottom: 20 })
  }
}

// 设置X轴数据的格式转换器
class XValueFormatter implements IAxisValueFormatter {
  getFormattedValue(value: number, axis: AxisBase): string {
    switch (value) {
      case 0:
        return '0:00';
      case 3:
        return '3:00';
      case 6:
        return '6:00';
      case 9:
        return '9:00';
      case 12:
        return '12:00';
      case 15:
        return '15:00';
      case 18:
        return '18:00';
      case 21:
        return '21:00';
      case 24:
        return '+1';
      case 27:
        return '3:00';
    }
    return value + '';
  }
}

// 设置Y轴数据的格式转换器
class YValueFormatter implements IAxisValueFormatter {
  getFormattedValue(value: number, axis: AxisBase): string {
    return value.toFixed(0);
  }
}