/**
 * @Author: xwang
 * @Date: 2024/7/15 09:21
 * @Description:
 **/
import { CommonLazyDataSourceModel, FunctionDescription } from '@same/common'

@Component
export struct SideBarView {
  memberArray: CommonLazyDataSourceModel<string> = new CommonLazyDataSourceModel()

  aboutToAppear(): void {
    for (let i = 0; i < 10; i++) {
      this.memberArray.pushData("成员" + i)
    }
  }

  build() {
    Column() {
      FunctionDescription({ content: "请再次点击三角按钮收起侧边栏" })
      Divider()
        .padding($r("sys.float.ohos_id_card_margin_start"))

      List() {
        LazyForEach(this.memberArray, (item: string, index: number) => {
          ListItem() {
            Row() {
              Image(null)
                .backgroundColor("#83bcbcbc")
                .width(40)
                .height(40)
                .borderRadius(20)

              Row()
                .margin($r("sys.float.ohos_id_card_margin_start"))
                .height(20)
                .width("100%")
                .backgroundColor("#83bcbcbc")
            }
          }
        })
      }
      .padding($r('sys.float.ohos_id_card_margin_start'))
    }
    .backgroundColor("#f1f3f5")
    .width("100%")
    .height("100%")
  }
}