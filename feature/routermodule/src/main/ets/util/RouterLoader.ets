import { AppRouterInfo, RouterMapModel } from '../model/AppRouterInfo';
import resourceManager from '@ohos.resourceManager';
import util from '@ohos.util';
import { BusinessError } from '@kit.BasicServicesKit';
import { MLog } from '@same/common/Index';

//加载路由
export namespace RouterLoader {
  //加载所有路由表文件
  export function load(dir: string, routerMap: Map<string, AppRouterInfo>, context: Context) {
    const rm: resourceManager.ResourceManager = context.resourceManager
    try {
      rm.getRawFileList(dir).then((value: Array<string>) => {
        let decoder: util.TextDecoder = util.TextDecoder.create("utf-8", {
          fatal: false,
          ignoreBOM: true
        })
        //遍历所有模块的路由表文件，放入路由表中管理
        value.forEach((fileName: string) => {
          let fileBytes: Uint8Array = rm.getRawFileContentSync(`${dir}/${fileName}`)
          let retStr = decoder.decodeWithStream(fileBytes)
          let routerMapModel: RouterMapModel = JSON.parse(retStr) as RouterMapModel
          loadRouterMap(routerMapModel, routerMap)
        })
      })
    } catch (error) {
      let code = (error as BusinessError).code
      let message = (error as BusinessError).message
      MLog.error(`promise getRawFile failed, error code:${code} ,message :${message}`)
    }
  }

  function loadRouterMap(routerMapModel: RouterMapModel, routerMap: Map<string, AppRouterInfo>) {
    routerMapModel.routerMap.forEach((routerInfo: AppRouterInfo) => {
      if (routerMap.has(routerInfo.name)) {
        MLog.warn("duplicate router declare")
      } else {
        routerMap.set(routerInfo.name, routerInfo)
      }
    })
  }
}