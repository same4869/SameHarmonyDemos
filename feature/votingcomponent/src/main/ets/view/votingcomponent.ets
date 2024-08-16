import { AppRouter } from '@ohos/dynamicsRouter';

@AppRouter({
  name: "votingcomponent/votingcomponent"
})
@Component
export struct votingcomponent {
  // 投票组件下方提示的内容
  @State notice: string = '点击上方按钮，选择你的观点';
  // 左选项的长度
  @State leftOptionWidth: string = '50%';
  // 右选项的长度
  @State rightOptionWidth: string = '50%';
  // 是否已投票
  @State isClick: boolean = false;
  // 绘制中间切割的平行四边形的坐标点
  @State points: number[][] = [[20, 0], [90, 0], [80, 80], [10, 80]];
  // 填充选项的透明度
  @State fillOpacity: number = 1
  // 左右选项选择人数，目前是写死，真实业务场景通过请求获取
  leftOptionChoose: number = 4;
  rightOptionChoose: number = 13;
  // 定义动画
  animateParam: AnimateParam = {
    duration: 500,
    curve: Curve.EaseOut
  }

  /**
   * 投票后改变属性
   *
   * @param option 投了左边还是右边
   */
  changeState(option: string) {
    // 投票后将点击状态置为已点击，实现投票只能投一次的效果
    this.isClick = true;
    // 左下角文字提示投票已选择的选项
    this.notice = '已选择"' + option + '"';
    // 投票后设置透明度，实现颜色变浅的效果
    this.fillOpacity = 0.2
    // 根据投票人数来计算选项两边的比例
    const leftOptionPercent: number = this.leftOptionChoose / (this.leftOptionChoose + this.rightOptionChoose) * 100
    // TODO：知识点1：使用显式动画，只有在宽度变化时生效
    animateTo(this.animateParam, () => {
      this.leftOptionWidth = leftOptionPercent.toFixed(0) + '%';
      this.rightOptionWidth = (100 - leftOptionPercent).toFixed(0) + '%';
      this.points = [[50, 0], [60, 0], [50, 80], [40, 80]];
    });
  }

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.Start
      }) {
        Image($r("app.media.voting_component_avatars"))
          .width(10)
          .height(20)
          .margin({
            left: 10,
            right: 3
          })
        Text("大家冬天喜欢早起还是晚起呀")
          .fontSize(17)
      }

      Stack() {
        Flex({
          direction: FlexDirection.Row,
          justifyContent: FlexAlign.Center
        }) {
          Stack() {
            Column()
              .borderRadius({
                topLeft: 40,
                bottomLeft: 40,
                topRight: 0,
                bottomRight: 0
              })
              .backgroundColor(Color.Red)
              .opacity(this.fillOpacity)
              .width(this.leftOptionWidth)
              .height(40)

            Stack() {
              if (!this.isClick) {
                Text("早起")
                  .fontColor(Color.White)
                  .margin({
                    right: 25
                  })
              } else {
                Column() {
                  Text(this.leftOptionWidth)
                    .fontColor(Color.Red)
                    .fontSize(11)
                  Text("早起")
                    .fontColor(Color.Red)
                    .fontSize(11)
                }
              }
            }
          }
          .onClick(() => {
            if (this.isClick) {
              return
            }
            this.leftOptionChoose++
            this.changeState("早起");
          })

          Stack() {
            Column()
              .borderRadius({
                topLeft: 0,
                bottomLeft: 0,
                topRight: 40,
                bottomRight: 40
              })
              .backgroundColor(Color.Blue)
              .opacity(this.fillOpacity)
              .width(this.rightOptionWidth)
              .height(40)
            Stack() {
              if (!this.isClick) {
                Text("晚起")
                  .fontColor(Color.White)
                  .margin({ left: 25 })
              } else {
                Column() {
                  Text(this.rightOptionWidth)
                    .fontColor(Color.Blue)
                    .fontSize(11)
                  Text("晚起")
                    .fontColor(Color.Blue)
                    .fontSize(11)
                }
              }
            }
          }
          .onClick(() => {
            if (this.isClick) {
              return
            }
            this.rightOptionChoose++
            this.changeState("晚起");
          })
        }

        Stack() {
          // TODO：知识点4：因为Polygon是以一个矩形框为基准来绘制的，因此会受到这个矩形框的影响，使用position以及markAnchor来偏移，以抵消前述影响
          Polygon()
            .points(this.points)
            .fill("#f1f1f1")
            .antiAlias(true)
            .width(100)
            .height(80)

          // 点击前，空隙宽度稍微大一些，且其中有PK二字
          Stack() {
            if (!this.isClick) {
              Text() {
                Span("P").fontColor(Color.Red)
                Span("K").fontColor(Color.Blue)
              }
              .fontSize(35)
              .fontStyle(FontStyle.Italic)
              .fontWeight(900)
              .textAlign(TextAlign.Center)
            }
          }
        }
        .position({ x: this.leftOptionWidth })
        .markAnchor({ x: 50 })
      }
      .width("80%")

      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween
      }) {
        Text(this.notice)
          .fontSize(10)
          .margin(15)
        Stack() {
          if (this.isClick) {
            Text(this.leftOptionChoose + this.rightOptionChoose + "人参与")
              .fontSize(10)
              .margin({ right: 15 })
          }
        }
      }
    }
    .height("100%")
    .width("100%")
    .justifyContent(FlexAlign.Center)
  }
}