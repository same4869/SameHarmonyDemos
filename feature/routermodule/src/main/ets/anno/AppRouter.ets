//自定义装饰器
export function AppRouter(parm: AppRouterParam) {
  return Object
}

//装饰器参数
export interface AppRouterParam {
  //跳转的路由名
  name: string
  //是否需要传递参数，需要的话设置为true，否则可不需要设置
  hasParam?: boolean
}