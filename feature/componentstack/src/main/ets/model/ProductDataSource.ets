/**
 * @Author: xwang
 * @Date: 2024/7/4 14:03
 * @Description:
 **/
import { CommonLazyDataSourceModel } from '@same/common';

export class ProductDataSource extends CommonLazyDataSourceModel<ProductDataModel>{

}

/**
 * 商品的数据类
 */
export class ProductDataModel {
  id: number;
  uri: ResourceStr;
  title: ResourceStr;
  price: ResourceStr;
  insurance: ResourceStr;

  constructor(id: number, uri: ResourceStr, title: ResourceStr, price: ResourceStr, insurance: ResourceStr) {
    this.id = id;
    this.uri = uri;
    this.title = title;
    this.price = price;
    this.insurance = insurance;
  }

  toString(): string {
    return this.id.toString() + '  ' + this.title;
  }
}