import { appTasks } from '@ohos/hvigor-ohos-plugin';

export default {
    system: appTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[
        customPlugin()
    ]         /* Custom plugin to extend the functionality of Hvigor. */
}

// 导入接口
import { HvigorPlugin, HvigorNode } from '@ohos/hvigor';

function customPlugin(): HvigorPlugin {
    return {
        pluginId: '111customPlugin',
        apply(node: HvigorNode) {
            console.log("111111111customPlugin!")
        }
    }
}
