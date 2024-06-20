import { HvigorNode, HvigorPlugin } from '@ohos/havigor'
import * as path from "path";
import { readFileSync, constants } from "node:fs";
import ts, { StringLiteral } from "typescript";

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
      console.log('hello etsGeneratorPlugin version 0.0.2!');
      console.log(`Exec ${PLUGIN_ID}...${__dirname}`);
      console.log(`node:${node.getNodeName()},nodePath:${node.getNodePath()}`);

      //获取模块名
      pluginConfig.moduleName = node.getNodeName()
      //获取模块路径
      pluginConfig.modulePath = node.getNodePath()

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
    const importPath = path.relative(`${config.modulePath}/${config.builderDir}`, sourcePath).replaceAll("\\", "/").replaceAll(".ets", "")
    console.log(`importPath -> ${importPath}`)
    const analyzer = new EtsAnalyzer(config, sourcePath);
    // 开始解析文件
    analyzer.start();
  })
}

//文件解析结果
class AnalyzeResult {
  //加载的组件名
  viewName?: string
  //组件注册方法名
  functionName?: string
  //路由中配置的路径
  name?: string
  //路由中传递的参数
  param?: string
}

// ets文件解析
export class EtsAnalyzer {
  //文件路径
  sourcePath: string
  //hvigor配置
  pluginConfig: PluginConfig
  //解析结果
  analyzeResult: AnalyzeResult = new AnalyzeResult()
  //关键字位置
  keywordPos: number = 0
  //是否存在装饰器
  routerAnnotationExisted: boolean = false

  constructor(pluginConfig: PluginConfig, sourcePath: string) {
    this.pluginConfig = pluginConfig
    this.sourcePath = sourcePath
  }

  start() {
    //读取文件
    const sourceCode = readFileSync(this.sourcePath, "utf-8")
    //解析文件，生成节点树信息
    const sourceFile = ts.creatSourceFile(this.sourcePath, sourceCode, ts.ScriptTarget.ES2021, false)
    //遍历节点信息
    ts.forEachChild(sourceFile, (node: ts.Node) => {
      //解析节点
      // this.resolveNode(node)
      console.log(`EtsAnalyzer start sourceFile:${sourceFile} node:${node}`);
    })
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