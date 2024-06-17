//路由信息
export interface AppRouterInfo {
  name: string
  pageModule: string
  registerFunction?: string
  pageSourceFile?: string
}

//路由配置
export interface RouterConfig {
  libPrefix: string
  mapPath: string
}

// 路由表
export class RouterMapModel {
  routerMap: AppRouterInfo[] = [];
}

// 主页路由信息
export const HOME_PAGE: AppRouterInfo = {
  pageModule: "entry",
  name: 'EntryView',
  registerFunction: ""
}