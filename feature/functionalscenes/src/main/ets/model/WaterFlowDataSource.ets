import { SceneModuleInfo } from './SceneModuleInfo';

export class WaterFlowDataSource implements IDataSource {
  private dataArray: SceneModuleInfo[] = []
  private listeners: DataChangeListener[] = []

  constructor(dataArray: SceneModuleInfo[]) {
    for (let i = 0; i < dataArray.length; i++) {
      this.dataArray.push(dataArray[i]);
    }
  }

  totalCount(): number {
    return this.dataArray.length
  }

  getData(index: number): SceneModuleInfo {
    return this.dataArray[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }
}