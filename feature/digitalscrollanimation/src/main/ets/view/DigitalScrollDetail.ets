/**
 * @Author: xwang
 * @Date: 2024/7/26 15:55
 * @Description:
 **/

/**
 * 实现步骤：
 *  1. 通过双重ForEach循环分别横向、纵向渲染数字。
 *  2. 通过Math.random()生成随机数，并更新到currentData数组中。
 *  3. 使用显示动画animateTo，对currentData数组中的每个数字执行不同的滚动动效。
 *  4. 设置数字所在容器属性.clip(true)，将多余的数字裁剪。
 */

@Component
export struct DigitalScrollDetail {
  private dataItem: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]; // 数据项
  @State scrollYList: number[] = []; // 数字Y轴滚动位移集合
  private currentData: number[] = new Array(7).fill(0); // 当前数据值
  private preData: number[] = new Array(7).fill(0); // 上一次数据值
  @Prop @Watch('onDataRefresh') isRefresh: boolean; // 是否刷新

  build() {
    Row() {
      ForEach(this.currentData, (item: number, index: number) => {
        if ((7 - index) % 3 === 0 && index !== 0) {
          Text(",")
            .fontColor($r('sys.color.ohos_id_color_palette9'))
        }

        Column() {
          ForEach(this.dataItem, (subItem: number) => {
            Text(subItem.toString())
              .fontColor(Color.Orange)
              .fontWeight(FontWeight.Bold)
              .height("100%")
              .textAlign(TextAlign.Center)
              .translate({ x: 0, y: this.scrollYList[index] })
          })
        }
        .height(26)
        .clip(true) // 裁剪超出容器的视图
      })
    }
  }

  onDataRefresh() {
    if (this.isRefresh === false) {
      this.refreshData();
    }
  }

  refreshData() {
    const tempArr: number[] = []
    for (let i = 0; i < 7; i++) {
      tempArr.push(Math.floor(Math.random() * 10)); // 向数组添加随机数
    }
    this.currentData = tempArr
    // 性能知识点：forEach场景下，每个列表项都会创建animateTo对象，要注意不能进行大数据量的遍历创建过多动画对象导致内存占用问题
    this.currentData.forEach((item: number, index: number) => {
      animateTo({
        // TODO:知识点：1.根据上一次数据值，计算差值。差值越大，执行动画时长越长。
        duration: Math.abs(item - this.preData[index]) * 200,
        curve: Curve.LinearOutSlowIn, // 减速曲线
        onFinish: () => {
          this.preData = this.currentData; // 动画执行结束后，更新上一次数据值
          this.isRefresh = false; // 刷新完毕
        }
      }, () => {
        this.scrollYList[index] = -item * 26
      })
    })
  }
}