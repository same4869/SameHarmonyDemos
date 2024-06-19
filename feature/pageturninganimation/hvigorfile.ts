import { harTasks } from '@ohos/hvigor-ohos-plugin';
import { PluginConfig, customPlugin } from '@app/ets-generator';

const config: PluginConfig = {
    scanFiles: ["src/main/ets/view/PageTurningAnimation"],
}

export default {
    system: harTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins: [customPlugin(config)]         /* Custom plugin to extend the functionality of Hvigor. */
}
