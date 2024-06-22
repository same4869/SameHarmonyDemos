import { MLog } from '@same/common/Index'
import { AppRouterInfo, HOME_PAGE, RouterConfig } from '../model/AppRouterInfo'
import { RouterLoader } from '../util/RouterLoader'
import { BusinessError } from '@kit.BasicServicesKit'

export class DynamicsRouter {
  static config: RouterConfig
  //路由表信息
  static routerMap: Map<string, AppRouterInfo> = new Map()
  // 管理需要动态导入的模块，key是模块名，value是WrappedBuilder对象，动态调用创建页面的接口
  static builderMap: Map<string, WrappedBuilder<[object]>> = new Map<string, WrappedBuilder<[object]>>();
  static navPathStack: NavPathStack = new NavPathStack();
  //自动生成的路由列表
  static appRouterStack: Array<AppRouterInfo> = new Array()
  static referrer: string[] = [];

  //初始化动态路由
  public static routerInit(config: RouterConfig, context: Context) {
    DynamicsRouter.config = config
    DynamicsRouter.appRouterStack.push(HOME_PAGE)
    //加载路由表
    RouterLoader.load(config.mapPath, DynamicsRouter.routerMap, context)
  }

  //通过名称注册builder
  private static registerBuilder(builderName: string, builder: WrappedBuilder<[object]>) {
    DynamicsRouter.builderMap.set(builderName, builder)
  }

  // 根据路由信息跳转到对应的页面
  public static pushUri(name: string, param?: ESObject) {
    //如果路由表中没有改路由信息，直接中断
    if (!DynamicsRouter.routerMap.has(name)) {
      MLog.error("dRouter", "router has not contain name : " + name)
      return
    }
    //根据路由名获取路由信息
    let routerInfo: AppRouterInfo = DynamicsRouter.routerMap.get(name)!
    // 如果是第一次跳转，则需要动态引入模块
    if (!DynamicsRouter.builderMap.has(name)) {
      // 动态引用模块，如“@ohos/addressexchange”，和entry/oh-package.json中配置的模块名相同
      import(`${DynamicsRouter.config.libPrefix}/${routerInfo.pageModule}`)
        .then((module: ESObject) => {
          //通过路由注册方法注册路由
          module[routerInfo.registerFunction!](routerInfo)
          // TODO：知识点：在路由模块的动态路由.pushUri()中调用拦截方法，此处必须等待动态路由加载完成后再进行拦截，否则页面加载不成功，导致无法注册拦截的函数，出现首次拦截失效。
          // Interceptor
          // 页面跳转
          DynamicsRouter.navPathStack.pushPath({ name: name, param: param })
        })
        .catch((error: BusinessError) => {
          MLog.error(`promise import module failed, error code:${error.code}, message:${error.message}`)
        })
    } else {
      // TODO：知识点：除首次跳转后，之后的每次跳转都需进行路由拦截。
      // Interceptor
      //如果已经跳转果，则直接跳转
      DynamicsRouter.navPathStack.pushPath({ name: name, param: param })
      DynamicsRouter.pushRouterStack(routerInfo)
    }

  }

  // 存储引用信息
  private static pushRouterStack(routerInfo: AppRouterInfo) {
    DynamicsRouter.appRouterStack.push(routerInfo);
    const referrerModel: AppRouterInfo = DynamicsRouter.appRouterStack[DynamicsRouter.appRouterStack.length-2];
    DynamicsRouter.referrer[0] = referrerModel.pageModule;
    DynamicsRouter.referrer[1] = referrerModel.name;
    MLog.info(`From DynamicsRouter.routerStack push preview module name is ${DynamicsRouter.referrer[0]},path is ${DynamicsRouter.referrer[1]}`);
  }

  /**
   * 注册动态路由需要加载的页面，用于自动生成的路由
   *
   * @param pageName 页面名，需要动态加载的页面名称
   * @param wrapBuilder wrapBuilder对象
   */
  public static registerAppRouterPage(routerInfo: AppRouterInfo, wrapBuilder: WrappedBuilder<[object]>) {
    const buildName: string = routerInfo.name
    if (!DynamicsRouter.builderMap.has(buildName)) {
      DynamicsRouter.registerBuilder(buildName, wrapBuilder)
    }
  }
}