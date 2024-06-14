import inputMethod from '@ohos.inputMethod'
import { BusinessError } from '@ohos.base'
import { MLog } from '@same/common/Index'

@Extend(Text)
function verifyCodeUnitStyle() {
  .fontSize($r("sys.float.ohos_id_text_size_body1"))
  .fontWeight(60)
  .textAlign(TextAlign.Center)
  .width(60)
  .height('100%')
  .margin({ left: 5, right: 5 })
  .border({
    width: { bottom: 1 },
    color: { bottom: Color.Blue },
    style: { bottom: BorderStyle.Solid }
  })
}

@Preview
@Component
@Entry({ routeName: 'verifycode/VerifyCodeView' })
export struct VerifyCodeView {
  build() {
    Column() {
      VerifyCodeComponentWithoutCursor()
    }
    .height("100%")
    .width("100%")
    .justifyContent(FlexAlign.Center)
  }
}

@Component
struct VerifyCodeComponentWithoutCursor {
  @State codeText: string = ""
  private inputController: inputMethod.InputMethodController = inputMethod.getController()
  private textConfig: inputMethod.TextConfig = {
    inputAttribute: {
      textInputType: inputMethod.TextInputType.NUMBER,
      enterKeyType: inputMethod.EnterKeyType.GO
    },
  };
  private verifyCodeLength: number = 6;
  private codeIndexArray: Array<number> = Array.from([0, 1, 2, 3, 4, 5]);

  /**
   * TODO 知识点：绑定输入法并订阅输入法相关事件
   */
  async attach() {
    await this.inputController.attach(true, this.textConfig)
  }

  aboutToDisappear(): void {
    this.dettach()
  }

  /**
   * TODO：知识点：解绑
   */
  dettach(): void {
    this.inputController.off("insertText");
    this.inputController.off("deleteLeft");
    this.inputController.detach((err: BusinessError) => {
      if (err) {
      }
    })
  }

  /**
   * TODO 知识点：订阅输入法代插入、向左删除事件，从而获得键盘输入内容
   */
  listen() {
    this.inputController.on("insertText", (text: string) => {
      if (this.codeText.length >= this.verifyCodeLength || isNaN(Number(text)) || text === ' ') {
        return
      }
      this.codeText += text
      if (this.codeText.length === this.verifyCodeLength) {
        MLog.info("VerifyCode: %{public}s", this.codeText);
      }
      MLog.info("VerifyCode [insert]: %{public}s", this.codeText);
    })
    this.inputController.on("deleteLeft", (length: number) => {
      this.codeText = this.codeText.substring(0, this.codeText.length - 1);
      MLog.info("VerifyCode [delete left]: %{public}s", this.codeText);
    })
    MLog.info("listener added");
  }

  /**
   * TODO 知识点：部分验证码场景要完全禁止对输入验证码的选中、复制等功能，因此可以使用Text组件完成
   */
  @Builder
  buildVerifyCodeComponent() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceBetween
    }) {
      ForEach(this.codeIndexArray, (item: number, index: number) => {
        Text(this.codeText[item])
          .verifyCodeUnitStyle()
      }, (item: number, index: number) => item.toString())
    }
    /**
     * TODO：知识点：当可视面积变化时进行绑定注册与解绑
     */
    .onVisibleAreaChange([0.0, 1, 0], async (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio >= 1.0) {
        await this.attach();
        this.listen();
      }
      if (!isVisible && currentRatio <= 0.0) {
        this.dettach()
      }
    })
    .backgroundColor(Color.Transparent)
    .height(50)
    .margin({ left: $r("sys.float.ohos_id_card_margin_start"), right: $r("sys.float.ohos_id_card_margin_start") })
    .defaultFocus(true)
    .onClick(() => {
      // TODO 知识点：点击本组件时弹出输入法，因为这里使用的是Text组件，因此需要重新attach，而不能直接使用showSoftKeyboard
      this.attach();
      MLog.info("reattached");
    })
  }

  build() {
    Row() {
      this.buildVerifyCodeComponent()
    }
  }
}