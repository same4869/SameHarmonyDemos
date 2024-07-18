/**
 * @Author: xwang
 * @Date: 2024/7/18 09:18
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';

const COLOR_HEALTHY: string = '#00CC00';
const COLOR_NORMAL: string = '#7EBEDE';
const COLOR_WARN: string = '#FF0000';
const COLOR_TRANSPARENT: string = '#00000000';
const DIAMETER: number = 200;
const RADIUS_IN_PX: number = vp2px(DIAMETER / 2.0);

@AppRouter({ name: "paintcomponent/PaintComponent" })
@Component
export struct PaintComponent {
  // 绘制封闭曲线的命令
  @State pathCommands: string = '';
  // 随着进度填充封闭曲线的颜色
  @State colorBackgroundFill: string = COLOR_NORMAL;
  // 进度
  @State progressNum: number = 0;
  // 进度是否在变化
  isRunning: boolean = false;
  // 背景颜色
  @State bgColor: string = COLOR_TRANSPARENT;

  aboutToAppear(): void {
    this.pathCommands = this.getPathCommands(this.progressNum);
    this.changeColor();
  }

  /**
   * 改变进度
   *
   * @param isIncrease 是否增加
   */
  changeProgressNum(isIncrease: boolean) {
    // 根据isIncrease来决定是对progressNum自增还是自减
    isIncrease ? this.progressNum += 0.5 : this.progressNum -= 0.5
    this.changeColor()
    this.pathCommands = this.getPathCommands(this.progressNum);
  }

  /**
   * 根据不同进度设置不同颜色
   */
  changeColor() {
    if (this.progressNum === 100) {
      // 进度为100时，封闭曲线不生效，此时将内心圆背景色设为COLOR_HEALTHY
      this.bgColor = COLOR_HEALTHY;
    } else {
      // 其他进度则将内心圆背景色设为透明色，防止影响进度填充色
      this.bgColor = COLOR_TRANSPARENT;
    }

    if (this.progressNum >= 80) {
      // 当进度达到HEALTHY_PROGRESS时将进度填充色设为COLOR_HEALTHY
      this.colorBackgroundFill = COLOR_HEALTHY;
    } else if (this.progressNum <= 20) {
      // 当进度达到WARN_PROGRESS时，将进度填充色设为WARN_PROGRESS
      this.colorBackgroundFill = COLOR_WARN;
    } else {
      // 其他进度将进度填充色设为COLOR_NORMAL
      this.colorBackgroundFill = COLOR_NORMAL;
    }
  }

  /**
   * 根据进度拿到水位线的端点的纵坐标
   *
   * @param progressPercent 进度百分比
   * @returns 水位线的端点的纵坐标
   */
  getOrdinate(progressPercent: number): number {
    return (1 - progressPercent) * (RADIUS_IN_PX + RADIUS_IN_PX)
  }

  /**
   * 根据圆心，以及纵坐标拿到水位线两个端点的距离的平方
   *
   * @param ordinate 纵坐标
   * @returns 端点间距离的平方
   */
  getDistanceSquare(ordinate: number): number {
    return RADIUS_IN_PX * RADIUS_IN_PX - (ordinate - RADIUS_IN_PX) * (ordinate - RADIUS_IN_PX);
  }

  /**
   * 拼接绘制闭合曲线的commands
   *
   * @param firstAbscissa
   * @param secondAbscissa
   * @param ordinate
   * @param radius
   * @returns
   */
  formatPathCommands(firstAbscissa: number, secondAbscissa: number, ordinate: number, radius: number): string {
    return `M${firstAbscissa} ${ordinate} A${radius} ${radius} 0 ${ordinate > RADIUS_IN_PX ? 0 :
      1} 0 ${secondAbscissa} ${ordinate}`
      + `Q${(firstAbscissa + 3 * secondAbscissa) / 4} ${ordinate +
        12.5 * (secondAbscissa - firstAbscissa) / radius}, ${(firstAbscissa + secondAbscissa) /
        2} ${ordinate} T${firstAbscissa} ${ordinate}`;
  }

  /**
   * 计算闭合曲线
   *
   * @param progressNum 进度
   * @returns 绘制闭合曲线的commands
   */
  getPathCommands(progressNum: number): string {
    // 拿到水位线的端点的纵坐标
    const ordinate: number = this.getOrdinate(progressNum / 100.0);
    // 拿到端点之间的距离的平方
    const distanceSquare: number = this.getDistanceSquare(ordinate);
    if (distanceSquare >= 0) {
      // 开平方得到端点间的距离
      const distance: number = Math.sqrt(distanceSquare);
      // 计算得出第一个端点的横坐标
      const firstAbscissa: number = RADIUS_IN_PX - distance;
      // 计算得到第二个端点的横坐标
      const secondAbscissa: number = RADIUS_IN_PX + distance;
      return this.formatPathCommands(firstAbscissa, secondAbscissa, ordinate, RADIUS_IN_PX);
    }
    return "";
  }

  build() {
    Column() {
      Text("电池电量")
        .fontSize(20)
        .textAlign(TextAlign.Center)
        .margin({
          bottom: 100
        })
        .fontColor("#7EBEDE")

      Stack() {
        // 外框圆环
        Circle({
          width: 220,
          height: 220
        })
          .fill("#00000000")
          .stroke("#7EBEDE")
          .strokeWidth(5)

        // 进度展示
        Circle({
          width: 200,
          height: 200
        })
          .fill("#00000000")

        // TODO:知识点:使用Path组件绘制封闭曲线，实现水位线效果
        Path()
          .width(200)
          .height(200)
          .commands(this.pathCommands)
          .fill(this.colorBackgroundFill)
          .antiAlias(true)
          .stroke(this.colorBackgroundFill)
          .strokeWidth(1)

        //进度百分比
        Row() {
          Text("⚡")
            .fontColor(COLOR_NORMAL)
            .fontSize(30)

          Text(this.progressNum.toFixed(0) + "%")
            .fontSize(60)
        }

      }
      .width(220)
      .height(220)
      .margin({
        bottom: 120
      })

      Row() {
        Button("充电")
          .type(ButtonType.Capsule)
          .margin({
            right: 50
          })
          .onClick(() => {
            if (this.progressNum >= 100 || this.isRunning) {
              // 此为充电按钮，若进度达到100，或者正在进行进度变化，则按钮不生效，提前退出
              return
            }
            // 将进度变换状态置为运行中
            this.isRunning = true;
            // 开启定时器对进度进行自增
            const id = setInterval(() => {
              this.changeProgressNum(true);
              if (this.progressNum >= 100) {
                // 此为充电按钮，若进度达到100，则取消定时器并将进度变化状态置为停止
                this.isRunning = false;
                clearInterval(id)
              }
            }, 100)
          })

        Button("耗电")
          .type(ButtonType.Capsule)
          .backgroundColor("#FF0000")
          .onClick(() => {
            if (this.progressNum <= 0 || this.isRunning) {
              // 此为耗电按钮，若进度达到0，或者正在进行进度变化，则按钮不生效，提前退出
              return;
            }
            // 将进度变换状态置为运行中
            this.isRunning = true;
            // 开启定时器对进度进行自减
            const id = setInterval(() => {
              this.changeProgressNum(false);
              if (this.progressNum <= 0) {
                this.isRunning = false;
                // 此为耗电按钮，若进度达到0，则取消定时器并将进度变化状态置为停止
                clearInterval(id)
              }
            }, 100)
          })
      }
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }
}