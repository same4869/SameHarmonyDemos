import {
  BarChart,
  BarChartModel,
  BarData,
  BarDataSet,
  BarEntry,
  ChartColor,
  Description,
  IAxisValueFormatter,
  IBarDataSet,
  JArrayList,
  Legend,
  LimitLabelPosition,
  LimitLine,
  XAxis,
  XAxisPosition,
  YAxis
} from '@ohos/mpchart'

@Component
export struct NewBarChart {
  @Prop calorieData: Array<number | null> = [233, 285, 458, 268, 237, 278, 407]; // 卡路里数据
  model: BarChartModel | null = null
  limitLine: LimitLine | null = null; // 限制线类型
  data: BarData | null = null; // 柱状图数据
  private leftAxis: YAxis | null = null; // 左侧Y轴数据
  private rightAxis: YAxis | null = null; // 右侧Y轴数据
  private xAxis: XAxis | null = null; // X轴数据

  aboutToAppear(): void {
    this.model = new BarChartModel()
    this.model.setPinchZoom(false)

    // 获取图表描述部件，设置图表描述部件不可用，即图表不进行绘制描述部件
    const desc: Description | null = this.model.getDescription()
    if (desc) {
      desc.setEnabled(false)
    }

    // 获取图表图例部件，设置图表图例部件不可用
    const legend: Legend | null = this.model.getLegend()
    if (legend) {
      legend.setEnabled(false)
    }

    // 设置图表数据最大的绘制数，如果超过该数值，则不进行绘制图表的数值标签
    this.model.setMaxVisibleValueCount(7)
    // 是否绘制图表的背景色，绘制范围为图表柱状图的绘制范围，不包含轴线之外的部分
    this.model.setDrawGridBackground(true)
    // 设置图表的背景色，颜色的规格需要满足CanvasRenderingContext2D.fillstyle/strokestyle规格
    this.model.setGridBackgroundColor("#FFFBF9EC")
    // 设置不绘制柱状图的柱体阴影背景
    this.model.setDrawBarShadow(false)
    // 设置柱状图的数值在柱体上方
    this.model.setDrawValueAboveBar(true)
    // 设置柱状图的高亮范围是否为整个柱体，只在堆叠柱状图中有区别
    this.model.setHighlightFullBarEnabled(true);
    // 为左Y轴设置LimitLine,可设置限制线的宽度，线段样式，限制标签的位置，标签字体大小等
    this.limitLine = new LimitLine(250, "目标 250");
    // 设置限制线的宽度
    this.limitLine.setLineWidth(2);
    // 设置限制线虚线类型的长度
    this.limitLine.enableDashedLine(20, 3, 0);
    // 设置限制线的颜色
    this.limitLine.setLineColor(Color.Gray);
    // 设置限制线的位置
    this.limitLine.setLabelPosition(LimitLabelPosition.RIGHT_TOP);
    // 设置限制线上文本的大小
    this.limitLine.setTextSize(16);
    // 设置图表左Y轴信息
    this.leftAxis = this.model.getAxisLeft();
    if (this.leftAxis) {
      // 设置图表左Y轴最小值
      this.leftAxis.setAxisMinimum(0);
      // 设置图表左Y轴是否在数据后绘制限制线
      this.leftAxis.setDrawLimitLinesBehindData(false);
      // 设置图表左Y轴数据的格式转换器
      this.leftAxis.setValueFormatter(new YValueFormatter());
      // 添加LimitLines
      this.leftAxis.addLimitLine(this.limitLine);
    }
    // 设置图表右Y轴信息
    this.rightAxis = this.model.getAxisRight();
    if (this.rightAxis) {
      // 设置图表右Y轴是否显示
      this.rightAxis.setEnabled(false);
      // 设置图表右Y轴最小值
      this.rightAxis.setAxisMinimum(0);
    }
    // 设置X轴信息
    this.xAxis = this.model.getXAxis();
    if (this.xAxis) {
      // 设置X轴是否绘制网格线
      this.xAxis.setDrawGridLines(false);
      // 设置绘制标签个数
      this.xAxis.setLabelCount(7, false);
      //设置标签位置
      this.xAxis.setPosition(XAxisPosition.BOTTOM);
      // 设置数据的格式转换器
      this.xAxis.setValueFormatter(new XValueFormatter());
    }
    // //设置是否支持双击放大
    this.model.setDoubleTapToZoomEnabled(false);

    // 生成单一颜色数据
    this.data = this.getNormalData();
    // TODO 知识点：将数据与图表配置类绑定
    this.model.setData(this.data);
  }

  private getNormalData(): BarData {
    const values: JArrayList<BarEntry> = new JArrayList()
    for (let i = 0; i < this.calorieData.length; i++) {
      values.add(new BarEntry(i, this.calorieData[i]))
    }
    const dataSet: BarDataSet = new BarDataSet(values, "卡路里")
    dataSet.setHighLightColor(Color.Gray)
    dataSet.setDrawIcons(false)
    dataSet.setDrawValues(true)
    dataSet.setHighlightEnabled(false)
    // 为柱体添加颜色信息
    dataSet.setColorByColor(ChartColor.rgb(34, 177, 48))
    const dataSetList: JArrayList<IBarDataSet> = new JArrayList()
    dataSetList.add(dataSet)
    const barData: BarData = new BarData(dataSetList)
    barData.setBarWidth(0.3)
    return barData
  }

  build() {
    BarChart({ model: this.model })
      .width("100%")
      .height("40%")
      .margin({ bottom: 20 })
  }
}

// 设置X轴数据的格式转换器
class XValueFormatter implements IAxisValueFormatter {
  getFormattedValue(value: number): string {
    return `1/${(value + 1).toFixed(0)}`;
  }
}

// 设置Y轴数据的格式转换器
class YValueFormatter implements IAxisValueFormatter {
  getFormattedValue(value: number): string {
    return value.toFixed(0);
  }
}
