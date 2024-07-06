import { CommonLazyDataSourceModel } from '@same/common';

export interface Month {
  month: string; // 具体年月
  num: number; // 月份
  days: number[]; // 该月日期
}

export class MonthDataSource extends CommonLazyDataSourceModel<Month>{

}