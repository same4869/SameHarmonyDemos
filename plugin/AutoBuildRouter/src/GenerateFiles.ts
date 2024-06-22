import Handlebars from "handlebars";
import { accessSync, existsSync, mkdirSync, readdirSync, writeFileSync } from "fs";
import { PluginConfig } from "./PluginConfig";
import * as path from "path";
import { readFileSync, constants } from "node:fs";

//根据模版生成路由方法文件
export function generateBuilder(templateModel: TemplateModel, config: PluginConfig) {
  console.log("generateBuilder -> " + JSON.stringify(templateModel))
  const builderPath = path.resolve(__dirname, `../${config.builderTpl}`)
  const tpl = readFileSync(builderPath, { encoding: "utf-8" })
  const template = Handlebars.compile(tpl)
  const output = template({
    viewList: templateModel.viewList
  })

  const routerBuilderDir = `${config.modulePath}/${config.builderDir}`
  if (!existsSync(routerBuilderDir)) {
    mkdirSync(routerBuilderDir, { recursive: true })
  }
  console.log(`generateBuilder path -> ${routerBuilderDir}/${config.builderFileName}`)
  writeFileSync(`${routerBuilderDir}/${config.builderFileName}`, output, { encoding: "utf8" })
}

// 以json的格式生成路由表
export function generateRouterMap(routerMap: RouterMap, config: PluginConfig) {
  const jsonOutput = JSON.stringify(routerMap, null, 2);
  const routerMapDir = `${config.modulePath}/${config.routerMapDir}`;
  if (!existsSync(routerMapDir)) {
    mkdirSync(routerMapDir, { recursive: true });
  }
  console.log(`generateRouterMap path -> ${routerMapDir}/${config.moduleName}.json`)
  writeFileSync(`${routerMapDir}/${config.moduleName}.json`, jsonOutput, { encoding: "utf8" });
}

// 生成Index.ets，导出路由方法
export function generateIndex(config: PluginConfig) {
  const indexPath = `${config.modulePath}/Index.ets`;
  let indexContent: string = readFileSync(indexPath, { encoding: "utf8" });
  if (!indexContent.includes(" * Copyright (c) 2024 Huawei Device Co., Ltd.\r")) {
    const licensesPath = path.resolve(__dirname, `../license.tpl`);
    const licenses: string = readFileSync(licensesPath, { encoding: "utf-8" });
    indexContent = licenses + "\n" + indexContent;
  }
  const indexArr: string[] = indexContent.split("\n");
  const indexArray: string[] = [];
  indexArr.forEach((value: string) => {
    if (!value.includes(config?.builderDir.toString())) {
      indexArray.push(value);
    }
  });
  indexArray.push(`export * from './${config.builderDir}/${config.builderFileName?.replace(".ets", "")}';`);
  console.log(`generateIndex indexPath -> ${indexPath}`)
  writeFileSync(indexPath, indexArray.join("\n"), { encoding: "utf8" });
}

interface TemplateModel {
  viewList: ViewInfo[];
}

// 用于生成组件注册类
class ViewInfo {
  // 自定义组件的名字
  viewName?: string;
  // import路径
  importPath?: string;
  // 组件注册方法名
  functionName?: string;
  // 方法是否有参数
  param?: string;
}