import { AppRouterInfo, HOME_PAGE, RouterConfig } from '../model/AppRouterInfo'
import { RouterLoader } from '../util/RouterLoader'

export class DynamicsRouter {
  static config: RouterConfig
  //路由表信息
  static routerMap: Map<string, AppRouterInfo> = new Map()
  //自动生成的路由列表
  static appRouterStack: Array<AppRouterInfo> = new Array()

  //初始化动态路由
  public static routerInit(config: RouterConfig, context: Context) {
    DynamicsRouter.config = config
    DynamicsRouter.appRouterStack.push(HOME_PAGE)
    //加载路由表
    RouterLoader.load(config.mapPath, DynamicsRouter.routerMap, context)
  }
}