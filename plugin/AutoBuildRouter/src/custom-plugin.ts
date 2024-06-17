import { HvigorNode, HvigorPlugin } from '@ohos/havigor'

export function customPlugin(): HvigorPlugin {
  return {
    pluginId: '222customPlugin',
    apply(node: HvigorNode) {
      console.log('222222hello customPlugin!');
    }
  }
}