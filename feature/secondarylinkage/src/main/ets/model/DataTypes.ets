/**
 * 一级列表可视区域的起始索引和终点索引。
 *
 * @interface
 * @property {number} start - 可视区域起点索引。
 * @property {number} end - 可视区域终点索引。
 */
import { BaseDataSource, CommonLazyDataSourceModel } from '@same/common/Index';

export interface ListIndexPosition {
  start: number,
  end: number,
}

/**
 * 代表自定义类型数据的接口。
 *
 * @interface
 * @property {string} desc - 描述。
 * @property {string} tag - 类别。
 */
export interface CustomDataType {
  desc: string,
  tag: string,
}

export class MyDataSource extends CommonLazyDataSourceModel<CustomDataType> {
}