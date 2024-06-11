/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@ohos.base';
import { FaultDataSource } from './FaultDataSource';
import { MLog } from '@same/common/Index';

// TODO：知识点：初始化Preferences实例，用于异常信息的持久化存储以及获取持久化数据功能
let dataPreferencesManager: dataPreferences.Preferences = {} as dataPreferences.Preferences;

export class PreferencesManager {
  // 获取Preferences实例
  public static async getPreferences(faultDataSource: FaultDataSource): Promise<void> {
    MLog.info('getPreferences start.');
    try {
      let val: dataPreferences.Preferences = await (dataPreferences.getPreferences(AppStorage.get('context'),
        'myStore') as Promise<dataPreferences.Preferences>);
      dataPreferencesManager = val;
      MLog.info('Succeeded in getting preferences.');
      // 获取异常信息
      await PreferencesManager.getFaultMessage(faultDataSource);
      await PreferencesManager.getFaultSign();
    } catch (err) {
      MLog.error("Failed to get preferences");
    }
  }

  /**
   * 存储数据异常信息
   * @param faultMessage 异常信息集合
   */
  public static async putFaultMessage(faultMessage: Array<string>): Promise<void> {
    MLog.info(`putMessage start`);
    try {
      // TODO：知识点：通过 dataPreferencesManager.put方法存储数据
      dataPreferencesManager.put('faultMessage', JSON.stringify(faultMessage), async (err: BusinessError) => {
        if (err) {
          MLog.error("Failed to put value of 'faultMessage'. code =" + err.code + ", message =" + err.message);
          return;
        }
        MLog.info('Succeeded in putting value of faultMessage.');
        dataPreferencesManager.flush();
      })
    } catch (err) {
      const code = (err as BusinessError).code;
      const message = (err as BusinessError).message;
      MLog.error("Failed to put value of 'catch err'. code =" + err.code + ", message =" + err.message);
    }
  }

  /**
   * 获取数据异常信息
   * @param faultMessage 异常信息集合
   */
  public static async getFaultMessage(faultDataSource: FaultDataSource): Promise<void> {
    MLog.info(`getFaultMessage start`);
    try {
      // TODO：知识点：通过dataPreferencesManager.get方法获取异常信息数据
      const data: dataPreferences.ValueType = await dataPreferencesManager.get('faultMessage', []);
      if (typeof data === 'string') {
        const faultData: Array<string> = JSON.parse(data);
        // 将异常数据添加到懒加载数据源中
        faultData.forEach((item: string) => {
          faultDataSource.pushData(item);
        })
        // 双向数据绑定懒加载数据源长度，更新数据源长度
        AppStorage.setOrCreate('faultDataSourceLength', faultDataSource.totalCount())
        MLog.info('Succeeded in getting value of faultMessage.');
      }
    } catch (err) {
      MLog.error("Failed to get value of 'catch err'. code =" + err.code + ", message =" + err.message);
    }
  }

  /**
   * 存储数据标识
   */
  public static async putFaultSign(): Promise<void> {
    MLog.info(`putMessage start`);
    try {
      // TODO：知识点：通过 dataPreferencesManager.put方法存储数据
      dataPreferencesManager.put('faultSign', JSON.stringify(true), async (err: BusinessError) => {
        if (err) {
          MLog.error("Failed to put value of 'faultSign'. code =" + err.code + ", message =" + err.message);
          return;
        }
        MLog.info('Succeeded in putting value of faultSign.');
        dataPreferencesManager.flush();
      })
    } catch (err) {
      MLog.error("putFaultSign Failed to put value of 'catch err'. code =" + err.code + ", message =" + err.message);
    }
  }

  /**
   * 获取数据异常信息
   */
  public static async getFaultSign(): Promise<void> {
    MLog.info(`getFaultMessage start`);
    let faultSign: boolean = false;
    try {
      // TODO：知识点：通过dataPreferencesManager.get方法获取异常标识
      const data: dataPreferences.ValueType = await dataPreferencesManager.get('faultSign', faultSign);
      if (typeof data === 'string') {
        faultSign = JSON.parse(data);
        AppStorage.setOrCreate('faultSign', faultSign);
      }
    } catch (err) {
      MLog.error("getFaultSign Failed to get value of 'catch err'. code =" + err.code + ", message =" + err.message);
    }
  }
}