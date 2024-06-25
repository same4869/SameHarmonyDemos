# Navigation页面跳转对象传递案例

### 介绍

本示例主要介绍在使用Navigation实现页面跳转时，如何在跳转页面得到转入页面传的类对象的方法。实现过程中使用了第三方插件class-transformer，传递对象经过该插件的plainToClass方法转换后可以直接调用对象的方法，

### 效果图预览

![](../../entry/src/main/resources/base/media/navigationParameterTransfer.gif)

**使用说明**

1. 从首页进入本页面时，会传递一个类对象UserBookingInfo。点击“换个座位”按钮会调用该类对象的generateRandSeatNo()方法，该方法随机生成一个座位号。

### 实现思路

1. 在oh-package.json5中添加第三方插件class-transformer的依赖

   ```typescript
   "dependencies": {
       "class-transformer": "^0.5.1"
   }
   ```

2. 在使用第三方插件class-transformer的页面导入class-transformer库。

   ```typescript
   import { plainToClass } from "class-transformer";
   ```
   
3. 定义要传递的类

   ```typescript
   // 定义一个用户类
   export class UserBookingInfo {
     userName: string = '张山'; // 姓名
     userID: string = '332045199008120045'; // 证件号
     date: string = '1月1日' // 日期
     seatNo: number = 0; // 座位号
     price: number = 200; // 价格
     constructor(name: string, id: string, date: string) {
       this.userName = name;
       this.userID = id;
       this.date = date;
     }
   
     // 获取随机座位号
     generateRandSeatNo(): number {
       this.seatNo = Math.floor(Math.random() * (200 - 1) + 1);  // 获取200以内随机号
       return this.seatNo;
     }
   }
   ```

4. 将传递过来的参数通过class-transformer的plainToClass方法转化为类对象。

   ```typescript
   let bookingString:string = this.pageStack.getParamByName('NavigationParameterTransfer')[0] as string;
   // 转化成普通对象
   let userBookingTmp: UserBookingInfo = JSON.parse(bookingString);
   // TODO：知识点：通过调用第三方插件class-transformer的plainToClass方法转换成类对象, 不进行转换直接使用userBookingTmp调用getUserInfo方法会造成crash
   this.userBooking = plainToClass(UserBookingInfo, userBookingTmp);
   ```

### 高性能知识点

**不涉及**

### 工程结构&模块类型

   ```
   navigationparametertransfer                        // har类型
   |---src\main\ets\components
   |   |---UserBookingInfo.ets                        // 要传递的类对象
   |---src\main\ets\view
   |   |---NavigationParameterTransferView.ets        // 视图层-Navigation主页面
   ```

### 模块依赖

1. 本实例依赖[class-transformer三方库](https://github.com/pleerock/class-transformer-demo)。
### 参考资料

[class-transformer三方库](https://github.com/pleerock/class-transformer-demo)