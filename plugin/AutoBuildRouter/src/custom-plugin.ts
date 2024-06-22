import { HvigorNode, HvigorPlugin } from '@ohos/havigor'
import * as path from "path";
import { PluginConfig } from './PluginConfig';
import { EtsAnalyzer } from './EtsAnalyzer';
import { generateBuilder, generateRouterMap, generateIndex } from './GenerateFiles'

const PLUGIN_ID = "etsGeneratorPlugin";
const ROUTER_BUILDER_PATH = "src/main/ets/generated";
const ROUTER_BUILDER_NAME = "RouterBuilder.ets";
const ROUTER_MAP_PATH = "src/main/resources/rawfile/routerMap";
const ROUTER_ANNOTATION_NAME = "AppRouter";
const ROUTER_BUILDER_TEMPLATE = "viewBuilder.tpl";

//路由代码生成器
export function etsGeneratorPlugin(pluginConfig: PluginConfig): HvigorPlugin {
  pluginConfig.annotation = ROUTER_ANNOTATION_NAME;
  pluginConfig.builderTpl = ROUTER_BUILDER_TEMPLATE;
  pluginConfig.routerMapDir = ROUTER_MAP_PATH;
  pluginConfig.builderDir = ROUTER_BUILDER_PATH;
  pluginConfig.builderFileName = ROUTER_BUILDER_NAME;
  return {
    pluginId: PLUGIN_ID,
    apply(node: HvigorNode) {
      console.log('hello etsGeneratorPlugin version 0.0.11!');
      console.log(`Exec ${PLUGIN_ID}...${__dirname}`);
      console.log(`node:${node.getNodeName()},nodePath:${node.getNodePath()}`);

      //获取模块名
      pluginConfig.moduleName = node.getNodeName()
      //获取模块路径
      pluginConfig.modulePath = node.getNodePath()

      console.log(`moduleName -> ${pluginConfig.moduleName} modulePath --> ${pluginConfig.modulePath}`)
      pluginExec(pluginConfig)
    }
  }
}

function pluginExec(config: PluginConfig) {
  console.log("plugin exec...");
  const templateModel: TemplateModel = {
    viewList: []
  }
  const routerMap: RouterMap = {
    routerMap: []
  }
  //遍历需要扫描的文件列表
  config.scanFiles.forEach((file) => {
    //文件绝对路径
    let sourcePath = `${config.modulePath}/${file}`
    console.log(`sourcePath -> ${sourcePath}`);
    if (!sourcePath.endsWith('.ets')) {
      sourcePath += '.ets'
    }
    //获取文件相对路径
    const importPath = path.relative(`${config.modulePath}/${config.builderDir}`, sourcePath).replaceAll("\\", "/")
      .replaceAll(".ets", "")
    console.log(`importPath -> ${importPath}`)
    const analyzer = new EtsAnalyzer(config, sourcePath);
    // 开始解析文件
    analyzer.start();
    console.log(JSON.stringify(analyzer.analyzeResult));
    console.log(importPath);
    if (analyzer.routerAnnotationExisted) {
      console.log(`routerAnnotationExisted -> ${analyzer.routerAnnotationExisted}`)
      console.log(`viewName -> ${analyzer.analyzeResult.viewName}, importPath -> ${importPath}, functionName -> ${analyzer.analyzeResult.functionName}, param -> ${analyzer.analyzeResult.param}`)
      templateModel.viewList.push({
        viewName: analyzer.analyzeResult.viewName,
        importPath: importPath,
        functionName: analyzer.analyzeResult.functionName,
        param: analyzer.analyzeResult.param === undefined ? "" : analyzer.analyzeResult.param
      })
      console.log(`name -> ${analyzer.analyzeResult.name}, pageModule -> ${config.moduleName}, pageSourceFile -> ${config.builderDir}/${config.builderFileName}, registerFunction -> ${analyzer.analyzeResult.functionName}Register`)
      routerMap.routerMap.push({
        name: analyzer.analyzeResult.name,
        pageModule: config.moduleName,
        pageSourceFile: `${config.builderDir}/${config.builderFileName}`,
        registerFunction: `${analyzer.analyzeResult.functionName}Register`
      })
    }
  })

  //生成路由方法文件
  generateBuilder(templateModel, config)
  // 生成路由表文件
  generateRouterMap(routerMap, config);
  // 生成Index.ets文件
  generateIndex(config);
}

