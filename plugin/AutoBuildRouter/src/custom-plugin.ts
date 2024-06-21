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

class NodeInfo {
  value?: any;
}

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
      console.log('hello etsGeneratorPlugin version 0.0.4!');
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
    const importPath = path.relative(`${config.modulePath}/${config.builderDir}`, sourcePath).replaceAll("\\", "/")
      .replaceAll(".ets", "")
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
    const sourceFile = ts.createSourceFile(this.sourcePath, sourceCode, ts.ScriptTarget.ES2021, false)
    //遍历节点信息
    ts.forEachChild(sourceFile, (node: ts.Node) => {
      //解析节点
      this.resolveNode(node)
    })
  }

  resolveNode(node: ts.Node): NodeInfo | undefined {
    console.log(`resolveNode node.kind -> ${node.kind}`)
    switch (node.kind) {
    // import节点（如 import * as path from "path";）
      case ts.SyntaxKind.ImportDeclaration:
        this.resolveImportDeclaration(node)
        break;
    //未知的节点声明
      case ts.SyntaxKind.MissingDeclaration:
        this.resolveMissDeclaration(node);
        break;
    // 装饰器节点
      case ts.SyntaxKind.Decorator:
        this.resolveDecoration(node);
        break;
    // 函数调用节点
      case ts.SyntaxKind.CallExpression:
        this.resolveCallExpression(node);
        break;
    // 表达式节点
      case ts.SyntaxKind.ExpressionStatement:
        this.resolveExpression(node);
        break;
    // 标识符节点
      case ts.SyntaxKind.Identifier:
        return this.resolveIdentifier(node);
    // 字符串节点
      case ts.SyntaxKind.StringLiteral:
        return this.resolveStringLiteral(node);
    // 对象赋值节点
      case ts.SyntaxKind.PropertyAssignment:
        return this.resolvePropertyAssignment(node);
      default:
        break;
    }
  }

  // import节点，不做操作
  resolveImportDeclaration(node: ts.Node) {
    let importDeclaration = node as ts.ImportDeclaration;
    // console.log(`resolveImportDeclaration --> ${importDeclaration.importClause}`)
  }

  // 未知节点，则继续解析子节点
  resolveMissDeclaration(node: ts.Node) {
    node.forEachChild((cnode) => {
      this.resolveNode(cnode);
    })
  }

  //解析装饰器
  resolveDecoration(node: ts.Node) {
    //转换为装饰器节点类型
    let decorator = node as ts.Decorator
    //判断表达式是否是函数调用
    console.log(`resolveDecoration decorator.expression.kind -> ${decorator.expression.kind}`)
    if (decorator.expression.kind === ts.SyntaxKind.CallExpression) {
      const callExpression = decorator.expression as ts.CallExpression
      console.log(`resolveDecoration callExpression.expression.kind -> ${callExpression.expression.kind}`)
      //表达式类型是否是标识符
      if (callExpression.expression.kind === ts.SyntaxKind.Identifier) {
        const identifier = callExpression.expression as ts.Identifier
        console.log(`resolveDecoration identifier.text -> ${identifier.text}`)
        //标识符是否是自定义的装饰器
        if (identifier.text === this.pluginConfig.annotation) {
          this.routerAnnotationExisted = true
          console.log(`resolveDecoration routerAnnotationExisted --> ${this.routerAnnotationExisted}`)
        }
      }
    }
  }

  //解析函数调用
  resolveCallExpression(node: ts.Node) {
    let args = node as ts.CallExpression
    let identifier = this.resolveNode(args.expression)
    console.log(`resolveCallExpression args.arguments --> ${args.arguments} identifier --> ${identifier?.value}`)
    this.parseRouterConfig(args.arguments, identifier);
  }

  // 解析函数
  resolveExpression(node: ts.Node) {
    let args = node as ts.ExpressionStatement;
    let identifier = this.resolveNode(args.expression);
    if (this.analyzeResult?.name?.endsWith(identifier?.value)) {
      this.analyzeResult.viewName = identifier?.value;
      let viewName: string = identifier?.value.toString();
      viewName = `${viewName.charAt(0).toLowerCase()}${viewName.slice(1, viewName.length)}`;
      this.analyzeResult.functionName = viewName;
      console.log(`resolveExpression viewName --> ${viewName}`)
    }
  }

  // 解析表达式
  resolveIdentifier(node: ts.Node): NodeInfo {
    let identifier = node as ts.Identifier;
    let info = new NodeInfo();
    info.value = identifier.escapedText.toString();
    console.log(`resolveIdentifier escapedText --> ${info.value}`)
    return info;
  }

  // 解析字符串
  resolveStringLiteral(node: ts.Node): NodeInfo {
    let stringLiteral = node as ts.StringLiteral;
    let info = new NodeInfo();
    info.value = stringLiteral.text;
    console.log(`resolveStringLiteral stringLiteral.text --> ${stringLiteral.text}`)
    return info;
  }

  // 解析属性赋值
  resolvePropertyAssignment(node: ts.Node): NodeInfo {
    let propertyAssignment = node as ts.PropertyAssignment;
    let propertyName = this.resolveNode(propertyAssignment.name)?.value;
    let propertyValue = this.resolveNode(propertyAssignment.initializer)?.value;
    let info = new NodeInfo();
    info.value = {
      key: propertyName,
      value: propertyValue
    }
    console.log(`resolvePropertyAssignment propertyName --> ${propertyName} propertyValue --> ${propertyValue}`)
    return info;
  }

  //解析路由配置
  parseRouterConfig(node: ts.NodeArray<ts.Expression>, nodeInfo?: NodeInfo) {
    if (nodeInfo?.value === this.pluginConfig.annotation) {
      node.flatMap((e: ts.Expression) => {
        ((e as ts.ObjectLiteralExpression).properties).forEach((e: ts.ObjectLiteralElementLike) => {
          this.parseConfig(e, this.analyzeResult);
        })
      })
    }
  }

  parseConfig(node: ts.ObjectLiteralElementLike, analyzeResult: AnalyzeResult) {
    let info = this.resolveNode(node);
    Reflect.set(analyzeResult, info?.value["key"], info?.value["value"]);
    console.log(`parseConfig key --> ${info?.value["key"]} value --> ${info?.value["value"]}`)
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