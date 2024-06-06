import { ToDo } from '../model/ToDo';
import { promptAction } from '@kit.ArkUI';
import { ToDoListItem } from './ToDoListItem';

@Extend(Image)
function imageStyle() {
  .aspectRatio(1)
  .width(32)
  .margin(4)
}

@Preview
@Component
@Entry({ routeName: 'pendingitems/ToDoList' })
export struct ToDoList {
  @State toDoData: ToDo[] = []; // 待办事项
  @State achieveData: ToDo[] = []; // 已完成事项
  private availableThings: string[] = ['读书', '运动', '旅游', '听音乐', '看电影', '唱歌']; // 待办可选事项

  build() {
    Column() {
      Row({ space: 12 }) {
        Text("待办").fontSize($r('sys.float.ohos_id_text_size_headline7'))
        Blank()
        Image($r('app.media.pendingitems_ic_public_add_filled'))
          .width(24)
          .aspectRatio(1)
          .onClick(() => {
            // TODO：知识点：1.根据文本选择的选择结果，向待办事项数组中添加数据
            TextPickerDialog.show({
              range: this.availableThings,
              onAccept: (value: TextPickerResult) => {
                this.toDoData.unshift(new ToDo(this.availableThings[Number(value.index)]))
              }
            })
          })
      }
      .height("12%")
      .width("100%")
      .padding({
        left: $r('sys.float.ohos_id_max_padding_start'),
        right: $r('sys.float.ohos_id_max_padding_end'),
      })
      .backgroundColor(Color.White)

      // TODO：知识点：2.待办数据显示列表组件绑定数据变量toDoData
      List({ initialIndex: 0, space: 12 }) {
        // 未完成列表项
        if (this.toDoData.length != 0) {
          ListItem() {
            Text("未完成")
              .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          }
        }
        // 性能知识点：ForEach主要用于循环数据量小的数据，数据量大建议使用LazyForEach
        ForEach(this.toDoData, (toDoItem: ToDo, index: number) => {
          ListItem() {
            ToDoListItem({
              toDoItem: toDoItem,
              achieveData: $achieveData,
              toDoData: $toDoData
            })
          }
          // TODO：知识点：3.设置ListItem的swipeAction属性，左滑时，显示自定义UI视图
          .swipeAction({ end: this.itemEnd(toDoItem), edgeEffect: SwipeEdgeEffect.Spring })
        }, (toDoItem: ToDo, index: number) => toDoItem.key)

        // 已完成列表项
        if (this.achieveData.length !== 0) {
          ListItem() {
            Text("已完成")
              .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          }
        }

        ForEach(this.achieveData, (toDoItem: ToDo, index: number) => {
          ListItem() {
            ToDoListItem({
              toDoItem: toDoItem,
              achieveData: $achieveData,
              toDoData: $toDoData
            })
          }
          .swipeAction({ end: this.itemEnd(toDoItem), edgeEffect: SwipeEdgeEffect.Spring })
        }, (toDoItem: ToDo, index: number) => toDoItem.key)
      }
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .padding({
        top: $r('sys.float.ohos_id_default_padding_top'),
        left: $r('sys.float.ohos_id_default_padding_start'),
        right: $r('sys.float.ohos_id_default_padding_end'),
      })
    }
    .backgroundColor("#f1f3f5")
    .size({ width: "100%", height: "100%" })
  }

  @Builder
  itemEnd(item: ToDo) {
    Row({ space: 4 }) {
      Image($r('app.media.pendingitems_ic_public_settings_filled')).imageStyle()
        .onClick(() => {
          promptAction.showToast({ message: "待完善" });
        })
      Image($r('app.media.pendingitems_ic_public_detail_filled')).imageStyle()
        .onClick(() => {
          promptAction.showToast({ message: "待完善" });
        })
      Image($r('app.media.pendingitems_ic_public_delete_filled')).imageStyle()
        .onClick(() => {
          this.deleteTodoItem(item);
        })
    }
  }

  /**
   * 删除待办/已完成事项
   */
  deleteTodoItem(item: ToDo) {
    if (item.isFinished) {
      this.achieveData = this.achieveData.filter(todoItem => item.key !== todoItem.key);
    } else {
      this.toDoData = this.toDoData.filter(todoItem => item.key !== todoItem.key);
    }
    promptAction.showToast({ message: "删除成功" });
  }
}