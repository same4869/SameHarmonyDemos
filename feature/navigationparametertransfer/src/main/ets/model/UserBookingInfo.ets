export class UserBookingInfo{
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