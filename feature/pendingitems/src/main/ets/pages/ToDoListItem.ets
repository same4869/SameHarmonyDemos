import { ToDo } from '../model/ToDo';

@Component
export struct ToDoListItem {
  @Link achieveData: ToDo[]; // 已完成列表项
  @Link toDoData: ToDo[]; // 未完成列表项
  @ObjectLink toDoItem: ToDo; // item数据项
  @State isEdited: boolean = false; // 编辑状态

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row({ space: 4 }) {
        if (!this.isEdited) {
          Row() {
            if (this.toDoItem.isFinished) {
              Image($r('app.media.pendingitems_ic_public_ok_filled'))
                .width(15)
                .aspectRatio(1)
                .borderRadius(Color.White)
                .transition(TransitionEffect.IDENTITY)
            }
          }
          .width(20)
          .justifyContent(FlexAlign.Center)
          .aspectRatio(1)
          .borderRadius(20)
          .backgroundColor(this.toDoItem.isFinished ? $r('sys.color.ohos_id_color_floating_button_bg_normal') :
          Color.Transparent)
          .borderWidth(1)
          .borderColor($r('sys.color.ohos_id_color_focused_content_tertiary'))
          .onClick(() => {
            this.addAchieveData()
          })

          Text(`${this.toDoItem.name}`)
            .fontSize($r('sys.float.ohos_id_text_size_headline9'))
            .maxFontSize(18)
            .minFontSize(14)
            .layoutWeight(1)
            .maxLines(3)
            .textAlign(TextAlign.JUSTIFY)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .decoration({ type: this.toDoItem.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None })
        } else {
          TextInput({ text: `${this.toDoItem.name}` })
            .maxLines(1)
            .fontSize($r('sys.float.ohos_id_text_size_headline9'))
            .layoutWeight(1)
            .backgroundColor(Color.Transparent)
            .id('textEdit')
            .onChange((value: string) => {
              this.toDoItem.name = value // 更新待办事项数据
            })
            .onAppear(() => {
              focusControl.requestFocus('textEdit')
            })

          Blank()

          if (this.isEdited) {
            Image($r('app.media.pendingitems_ic_public_ok_filled'))
              .width(24)
              .aspectRatio(1)
              .onClick(() => {
                this.isEdited = false
              })
          } else {
            Text("编辑")
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              .onClick(() => {
                this.isEdited = true
              })
          }
        }
      }
      .width("100%")
      .gesture(
        LongPressGesture()
          .onAction(() => {
            if (!this.isEdited) {
              this.isEdited = true
            }
          })
      )
    }
    .width("100%")
    .height(80)
    .padding({
      left: $r('sys.float.ohos_id_default_padding_start'),
      right: $r('sys.float.ohos_id_default_padding_end'),
      top: 4,
      bottom: 4
    })
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
    .backgroundColor(Color.White)
  }

  /**
   * 添加已完成数据项
   */
  addAchieveData() {
    this.toDoItem.isFinished = true;
    if (this.toDoItem.isFinished) {
      animateTo({ duration: 600 }, () => {
        const tempData = this.toDoData.filter(item => item.key !== this.toDoItem.key);
        this.toDoData = tempData;
        this.achieveData.push(this.toDoItem);
      })
    }
  }
}