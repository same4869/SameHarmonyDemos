import { AppRouter } from '@same/routermodule/Index';

@Preview
@Component
  // @Entry({ routeName: 'pageturninganimation/PageTurningAnimation' })
@AppRouter({ name: 'pageturninganimation/PageTurningAnimation' })
export struct PageTurningAnimation {
  // 父组件变量设置，使用@State做状态管理
  @State originalAngle: number = 0; // 初始角度
  @State rotateAngleTextA: number = 0; // Text组件A的旋转角度
  @State rotateAngleTextB: number = 0; // Text组件B的旋转角度
  @State pageNumTextA: number = 0; // Text组件A的页面编号，用于刷新翻页动画结束时的页面编号
  @State animatePageNumTextB: number = 1; // Text组件B的页面编号，用于显示翻页动画的页面编号
  @State pageNumTextC: number = 0; // Text组件C的页面编号，用于占位不显示，在Text组件A的下层
  @State nextPageNumTextD: number = 0; // Text组件D的页面编号，用于刷新下一个翻页的页面编号
  @State leftX: string = '0%'; // 旋转中心点参数x,表示水平方向上旋转起始位置。本例中指定y轴作为旋转轴，所以这里设置'0%'表示旋转动效组件的左侧边缘位置作为旋转轴的水平起始点位置。
  @State leftY: string = '0%'; // 旋转中心点参数y,表示垂直方向上旋转起始位置。
  @State centerX: string = '50%'; // 旋转中心点参数x。本例中设置'50%'表示以组件的纵向中线为轴旋转。
  @State centerY: string = '50%'; // 旋转中心点参数y。

  // 在UI显示前，传入各项变量的具体值
  aboutToAppear(): void {
    // 通过setInterval函数每秒调用一次动画效果，实现连续翻页
    setInterval(() => {
      this.pageTurningAnimate();
    }, 1000) // 函数调用周期要大于每次动画持续的时长
  }

  private pageTurningAnimate() {
    // TODO: 知识点: 使用animateTo方法添加动画效果，同时控制动画的时长，以及动画过程中各元素状态的改变。
    animateTo({
      duration: 700, onFinish: () => {
        // 动画结束时，Text组件A显示的页面编号和B显示的页面编号相等
        this.pageNumTextA = this.animatePageNumTextB;
        // 动画结束时，Text组件A以中心线为轴旋转180度，用于显示左侧翻页动画结束时的页面编号
        this.rotateAngleTextA = 180;
        // 动画结束时，Text组件B的旋转角度重置为0度
        this.rotateAngleTextB = 0;
        // 动画结束时，Text组件B显示的页面编号加1
        this.animatePageNumTextB = (this.animatePageNumTextB + 1) % 8;
      }
    }, () => {
      // 动画开始，Text组件B的旋转角度设置为180度
      this.rotateAngleTextB = 180;
      //动画开始，Text组件D的页面编号加1，用于刷新显示下一个翻页的页面编号
      this.nextPageNumTextD = this.animatePageNumTextB + 1;
    })
  }

  build() {
    // TODO: 知识点: 创建父组件框架。由于文本组件分为上下两层，所以在父组件中采用Stack组件进行层叠布局。同时使用Divider组件作为书籍两个页面间的分隔线。
    Stack() {
      // 下层Row
      Row() {
        // Text组件C，用于占位不显示，在Text组件A的下层
        BookPage({
          pageNum: this.pageNumTextC,
          rotateAngle: this.originalAngle,
          positionX: this.leftX,
          positionY: this.leftY
        })
        // Text组件D，用于刷新下一个翻页的页面编号
        BookPage({
          pageNum: this.nextPageNumTextD,
          rotateAngle: this.originalAngle,
          positionX: this.leftX,
          positionY: this.leftY
        })
      }

      // 上层Row
      Row() {
        // Text组件A的页面编号，用于刷新翻页动画结束时的页面编号
        BookPage({
          pageNum: this.pageNumTextA,
          rotateAngle: this.rotateAngleTextA,
          positionX: this.centerX,
          positionY: this.centerY
        })
        // Text组件B的页面编号，用于显示翻页动画的页面编号
        BookPage({
          pageNum: this.animatePageNumTextB,
          rotateAngle: this.rotateAngleTextB,
          positionX: this.leftX,
          positionY: this.leftY
        })
      }

      //添加两个页面间的分割线
      Divider().strokeWidth(5).color(Color.White).height("26%").vertical(true)
    }
    .width("100%")
    .height("50%")
    .backgroundColor("#a4ae77")
  }
}

@Component
struct BookPage {
  // 为变量添加@Prop装饰器，用于接收父组件的动态传参
  @Prop pageNum: number; // 页面编号
  @Prop rotateAngle: number; // 旋转角度
  @Prop positionX: string; // 旋转中心点参数x,表示水平方向上旋转起始位置
  @Prop positionY: string; // 旋转中心点参数y,表示垂直方向上旋转起始位置

  build() {
    // TODO: 知识点: 创建文本组件。创建时添加rotate属性，用来控制组件旋转。
    Text(`${this.pageNum}`)
      .fontSize(80)
      .fontColor(Color.White)
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Center)
      .backgroundColor("#18183c")
      .width("35%")
      .height("30%")
      .borderRadius(20)
      .rotate({
        x: 0,
        y: 1,
        z: 0,
        angle: this.rotateAngle,
        centerX: this.positionX,
        centerY: this.positionY
      })
  }
}
