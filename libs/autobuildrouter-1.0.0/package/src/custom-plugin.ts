import { HvigorNode, HvigorPlugin } from '@ohos/havigor'

const PLUGIN_ID = "customPlugin";
const ROUTER_BUILDER_PATH = "src/main/ets/generated";
const ROUTER_BUILDER_NAME = "RouterBuilder.ets";
const ROUTER_MAP_PATH = "src/main/resources/rawfile/routerMap";
const ROUTER_ANNOTATION_NAME = "AppRouter";
const ROUTER_BUILDER_TEMPLATE = "viewBuilder.tpl";

//路由代码生成器
export function customPlugin(pluginConfig: PluginConfig): HvigorPlugin {
  pluginConfig.annotation = ROUTER_ANNOTATION_NAME;
  pluginConfig.builderTpl = ROUTER_BUILDER_TEMPLATE;
  pluginConfig.routerMapDir = ROUTER_MAP_PATH;
  pluginConfig.builderDir = ROUTER_BUILDER_PATH;
  pluginConfig.builderFileName = ROUTER_BUILDER_NAME;
  return {
    pluginId: PLUGIN_ID,
    apply(node: HvigorNode) {
      console.log('222222hello customPlugin 233333444!');
      console.log(`Exec ${PLUGIN_ID}...${__dirname}`);
      console.log(`node:${node.getNodeName},nodePath:${node.getNodePath()}`);

      //获取模块名
      pluginConfig.moduleName = node.getNodeName()
      //获取模块路径
      pluginConfig.modulePath = node.getNodePath()

    }
  }
}

// 配置文件，在hvigor中配置
export class PluginConfig {
  //注册路由的方法的文件名
  builderFileName?: string
  //注册路由的方法的文件路径
  builderDir?: string
  //路由表所在路径
  routerMapDir?: string
  //模块名
  moduleName?: string
  //模块路径
  modulePath?: string
  //装饰器名称
  annotation?: string
  //扫描的文件路径
  scanFiles?: string[]
  //查找生成struct的关键字
  viewKeyword?: string[]
  //生成代码模版
  builderTpl: string
}