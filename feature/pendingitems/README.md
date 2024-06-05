# 列表编辑实现

### 介绍

该场景多用于待办事项管理、文件管理、备忘录的记录管理等。

### 效果图预览

<img src="../../entry/src/main/resources/base/media/todo_list.gif" width="300">

**使用说明**：

* 点击添加按钮，选择需要添加的待办事项。
* 点击左侧checkbox按钮，待办事项状态变更为已完成。
* 左滑单个待办事项，点击删除按钮后，当前待办事项被删除。

## 实现思路

1. List组件绑定@State修饰的数组变量toDoData。
```javascript
@State toDoData: ToDo[] = []; // 待办事项

List({ initialIndex: 0, space: STYLE_CONFIG.LIST_ITEM_GUTTER }) {
   ForEach(this.toDoData, (toDoItem: ToDo, index: number) => {
      ...
   })
}
```
2. ListItem组件设置左滑动效[swipeAction](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-listitem-0000001821000905#ZH-CN_TOPIC_0000001821000905__%E5%B1%9E%E6%80%A7)
属性，使得单个ListItem可以进行左右滑动，并显示自定义的UIBuilder。
```javascript
@Builder
itemEnd(item: ToDo) {
   ...
}

ListItem(){
    ...
}
.swipeAction({ end: this.itemEnd(toDoItem), edgeEffect: SwipeEdgeEffect.Spring }) // 设置item左滑显示视图
```
属性。
3. 新增/删除列表项，更新数组变量toDoData，并同时更新List组件UI(MVVM)，具体可参考代码文件[ToDoList](src/main/ets/pages/ToDoList.ets)。
### 高性能知识点

不涉及

### 工程结构&模块类型

   ```
   pendingitems                                    // har
   |---model
   |   |---ToDo.ets                                // TODO类定义
   |   |---ConstData.ets                           // 常量数据
   |---pages
   |   |---ToDoList.ets                            // 列表项功能增删实现页面
   |   |---ToDoListItem.ets                        // 列表项页面
   ```

### 模块依赖

当前场景依赖以下模块
1. [动态路由模块](../routermodule/src/main/ets/router/DynamicsRouter.ets)，主要用于注册模块路由。

### 参考资料

[ListItem](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-listitem-0000001821000905#ZH-CN_TOPIC_0000001821000905__%E5%B1%9E%E6%80%A7)
