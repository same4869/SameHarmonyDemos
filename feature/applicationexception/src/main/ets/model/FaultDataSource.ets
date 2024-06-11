import { BaseDataSource } from '@same/common/Index';
import { PreferencesManager } from './PreferencesManager';

export class FaultDataSource extends BaseDataSource<string>{
  // 懒加载数据
  private faultMessage: Array<string> = [];

  // TODO：知识点：获取懒加载数据源的数据长度
  totalCount(): number {
    return this.faultMessage.length;
  }

  // 获取指定数据项
  getData(index: number): string {
    return this.faultMessage[index];
  }

  // TODO：知识点：存储数据到懒加载数据源中
  pushData(data: string): void {
    this.faultMessage.unshift(data);
    // 在数组头部添加数据
    this.notifyDataAdd(0);
    AppStorage.setOrCreate('faultDataSourceLength', this.totalCount());
  }

  // TODO：知识点：持久化存储异常信息集合
  persistenceStorage(): void {
    PreferencesManager.putFaultMessage(this.faultMessage);
  }
}