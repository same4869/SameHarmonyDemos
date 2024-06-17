# 自动生成动态路由

### 介绍

本示例将介绍如何使用装饰器和插件，自动生成动态路由表，并通过动态路由跳转到模块中的页面，以及如何使用动态import的方式加载模块

**使用说明**

1. 自定义装饰器
2. 添加装饰器和插件配置文件，编译时自动生成动态路由表
3. 配置动态路由，通过WrapBuilder接口，动态创建页面并跳转。
4. 动态import变量表达式，需要DevEco Studio NEXT Developer Preview1 （4.1.3.500）版本IDE，配合hvigor 4.0.2版本使用。
5. 支持自定义路由栈管理，相关内容请参考[路由来源页的相关说明](./README_ROUTER_REFERRER.md)

### 实现思路

#### [动态路由的实现](./src/main/ets/router/DynamicsRouter.ets)

1. 初始化动态路由

    ```ts
     public static routerInit(config: RouterConfig, context: Context) {
       DynamicsRouter.config = config;
       DynamicsRouter.appRouterStack.push(HOME_PAGE);
       RouterLoader.load(config.mapPath, DynamicsRouter.routerMap, context);
     }
    ```

2. 获取路由

    ```ts
    private static getNavPathStack(): NavPathStack {
      return DynamicsRouter.navPathStack;
    }
    ```

3. 通过builderName，注册WrappedBuilder对象，用于动态创建页面

    ```ts
    private static registerBuilder(builderName: string, builder: WrappedBuilder<[object]>): void {
      DynamicsRouter.builderMap.set(builderName, builder);
    }
    ```
   
4. 通过builderName，获取注册的WrappedBuilder对象

    ```ts
    public static getBuilder(builderName: string): WrappedBuilder<[object]> {
      let builder = DynamicsRouter.builderMap.get(builderName);
      if (!builder) {
        let msg = "not found builder";
        console.info(msg + builderName);
      }
      return builder as WrappedBuilder<[object]>;
    }
    ```

5. 通过页面栈跳转到指定页面

    ```ts
    public static pushUri(name: string, param?: Object) {
      if (!DynamicsRouter.routerMap.has(name)) {
        return;
      }
      let routerInfo: AppRouterInfo = DynamicsRouter.routerMap.get(name)!;
      if (!DynamicsRouter.builderMap.has(name)) {
        import(`${DynamicsRouter.config.libPrefix}/${routerInfo.pageModule}`)
          .then((module: ESObject) => {
            module[routerInfo.registerFunction!](routerInfo);
            DynamicsRouter.navPathStack.pushPath({ name: name, param: param });
        })
          .catch((error: BusinessError) => {
            logger.error(`promise import module failed, error code:${error.code}, message:${error.message}`);
        });
      } else {
        DynamicsRouter.navPathStack.pushPath({ name: name, param: param });
        DynamicsRouter.pushRouterStack(routerInfo);
      }
    }
    ```

6. 注册动态路由跳转的页面信息

    ```ts
    public static registerAppRouterPage(routerInfo: AppRouterInfo, wrapBuilder: WrappedBuilder<[object]>): void {
      const builderName: string = routerInfo.name;
      if (!DynamicsRouter.builderMap.has(builderName)) {
        DynamicsRouter.registerBuilder(builderName, wrapBuilder);
      }
    }
    ```

#### 动态路由的使用

1. 在工程的hvigor/hvigor-config.json5中配置插件

   ```json
   {
       ...
       "dependencies": {
           ...
           "@app/ets-generator": "file:../plugin/AutoBuildRouter"
       }
   }
   ```

2. 在工程的根目录的build-profile.json5中添加动态路由模块和需要加载的子模块的依赖，详细代码参考[build-profile.json5](../../build-profile.json5)。

    ```
    {
      "app":{
        ...
      }
      "modules":{
        ...
        {
          "name": "eventpropagation",
          "srcPath": "./feature/eventpropagation"
        },
        {
          "name": "routermodule",
          "srcPath": "./feature/routermodule"
        }
        ...
      }
    }
    ```

3. 在主模块中添加动态路由和需要加载的子模块的依赖，详细代码请参考[oh-package.json](../../product/entry/oh-package.json5)。

    ```
    "dependencies": {
      "@ohos/dynamicsrouter": "file:../../feature/routermodule",    
      "@ohos/event-propagation": "file:../../feature/eventpropagation",
      ...
    }
    ```

4. 在主模块中添加动态import变量表达式需要的参数，此处在packages中配置的模块名必须和[oh-package.json](../../product/entry/oh-package.json5)中配置的名称相同，详细代码请参考[build-profile.json5](../../product/entry/build-profile.json5)。

    ```
    ...
    "buildOption": {
      "arkOptions": {
        "runtimeOnly": {
          "packages": [
            "@ohos/event-propagation",
            ...
          ]
        }
      }
    }
    ```

5. 在主模块EntryAbility的onCreate接口初始化动态路由，详细代码请参考[EntryAbility.ets](../../product/entry/src/main/ets/entryability/EntryAbility.ets)。

    ```ts
    ...
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
      DynamicsRouter.routerInit({
        libPrefix: "@ohos", mapPath: "routerMap"
      }, this.context);
      ...
    }
    ...
    ```

6. 在主模块的WaterFlowData.ets中，将子模块要加载的页面，添加到列表中，详细代码请参考[WaterFlowData.ets](../../product/entry/src/main/ets/data/WaterFlowData.ets)和[SceneModuleInfo](../functionalscenes/src/main/ets/model/SceneModuleInfo.ets)。

    ```ts
    export const waterFlowData: SceneModuleInfo[] = [
      ...
      new SceneModuleInfo($r('app.media.address_exchange'), '地址交换动画', new RouterInfo("", ""), '动效', 2, "addressexchange/AddressExchangeView"),
      ...
    }
    ```

7. 在需要加载时将页面放入路由栈，详细代码请参考[FunctionalScenes.ets](../functionalscenes/src/main/ets/FunctionalScenes.ets)。

    ```ts
    @Builder
    methodPoints(listData: ListData) {
      Column() {
      ...
        .onClick(() => {
          ...
          DynamicsRouter.pushUri(this.listData.appUri);
          ...
        })
    }
    
    ```

8. 在子模块中添加动态路由的依赖，详细代码可参考[oh-package.json](../eventpropagation/oh-package.json5)。

    ```
    ...
    "dependencies": {
      ...
      "@ohos/dynamicsrouter": "file:../../feature/routermodule"
    }
    ```

**以上是需要在主模块中添加的配置，如果已经添加过相关代码，则可以直接略过，按照下面的步骤在子模块中添加相关即可自动生成动态路由相关文件。**

1. 在子模块的oh-package.json5中添加路由模块依赖，可参考[oh-package.json5](../addressexchange/oh-package.json5)

   ```typescript
   {
     ...
     "dependencies": {
       ...
       // 动态路由模块，用于配置动态路由
       "@ohos/dynamicsrouter": "file:../../feature/routermodule"
     }
   }
   ```

2. 在子模块的hvigorfile.ts文件中添加插件配置，可参考[hvigorfile.ts](../addressexchange/hvigorfile.ts)

   ```typescript
   ...
   import { PluginConfig, etsGeneratorPlugin } from '@app/ets-generator';
   // 配置路由信息
   const config: PluginConfig = {
     // 需要扫描的文件的路径，即配置自定义装饰AppRouter的文件路径
     scanFiles: ["src/main/ets/view/AddressExchangeView"]
   }
   
   export default {
     ...
     plugins: [etsGeneratorPlugin(config)]         /* Custom plugin to extend the functionality of Hvigor. */
   }
   ```
3. 在需要跳转的页面的自定义组件上添加装饰器，可参考[AddressExchangeView.ets](../addressexchange/src/main/ets/view/AddressExchangeView.ets)，如果需要通过路由传递参数，则需要设置hasParam为true，可参考[NavigationParameterTransferView.ets](../navigationparametertransfer/src/main/ets/view/NavigationParameterTransferView.ets)。
   
   ```typescript
   // 自定义装饰器，用于自动生成动态路由代码及页面的跳转。命名规则：模块名/自定义组件名
   @AppRouter({ name: "addressexchange/AddressExchangeView" })
   @Component
   export struct AddressExchangeView {
     ...
   }
   ```

### 高性能知识点

本示例使用动态import的方式加载模块，只有需要进入页面时才加载对应的模块，减少主页面启动时间和初始化效率，减少内存的占用。

### 工程结构&模块类型

   ```
   routermodule                                  // har类型
   |---annotation
   |---|---AppRouter.ets                         // 自定义装饰器
   |---constants
   |   |---RouterInfo.ets                        // 路由信息类，用于配置动态路由跳转页面的名称和模块名（后续会删除）
   |---model
   |   |---AppRouterInfo.ets                     // 路由信息类
   |   |---RouterParam.ets                       // 路由参数
   |---router
   |   |---DynamicsRouter.ets                    // 动态路由实现类
   |---util
   |   |---RouterLoader.ets                      // 路由表加载类
   ```

### 模块依赖

**不涉及**

### 参考资料

[动态路由Sample](https://gitee.com/openharmony/applications_app_samples/tree/master/code/BasicFeature/ApplicationModels/DynamicRouter)