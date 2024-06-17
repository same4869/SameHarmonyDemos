# 自动生成代码插件

### 介绍

本示例将介绍如何通过ts抽象语法树，根据自定义装饰器，自动生成代码。

### 实现原理

1. 在编译期通过扫描并解析ets文件中的自定义装饰器来生成路由表和组件注册类
2. har中的rawfile文件在hap编译时会打包在hap中，通过这一机制实现路由表的合并

### 实现思路

**插件初始化**

1. 创建ts工程，并添加hvigor依赖，可以使用hvigor中配置的解析和打包方法

    ```shell
    npm init
    npm -i --save-dev @types/node @ohos/hvigor @ohos/hvigor-ohos-plugin
    npm i typescript handlebars
    ```

2. 初始化ts配置

    ```shell
    ./node_modules/.bin/tsc --init
    ```
   
3. 修改package.json文件

   ```json
   {
   "name": "autobuildrouter",
   "version": "1.0.0",
   "description": "",
   "main": "lib/index.js",
   "scripts": {
     "test": "echo \"Error: no test specified\" && exit 1",
     "dev": "tsc && node lib/index.js",
     "build": "tsc"
   },
   ...
   ```

4. 修改tsconfig.json，指定编译相关的选项

    ```json5
    {
      "compilerOptions": {
        "target": "es2021",                                  /* Set the JavaScript language version for emitted JavaScript and include compatible library 
        "module": "commonjs",                                /* Specify what module code is generated. */
        "esModuleInterop": true,                             /* Emit additional JavaScript to ease support for importing CommonJS modules. This enables 'allowSyntheticDefaultImports' for type compatibility. */
        "forceConsistentCasingInFileNames": true,            /* Ensure that casing is correct in imports. */
        "skipLibCheck": true,                                 /* Skip type checking all .d.ts files. */
        "sourceMap": true,
        "outDir": "./lib"
      },
      "include": [".eslintrc.js","src/**/*"],
      "exclude": ["node_modules","lib/**/*"]
    }
    ```

5. 创建插件文件src/index.ts，用于编写插件代码

6. 插件代码编写完成后，运行/node_modules/.bin/tsc.cmd，在hvigor/hvigor-config.json5中配置插件后即可使用。

**插件实现**

1. 根据hvigor文件中的配置，初始化插件的参数

    ```typescript
    export function etsGeneratorPlugin(pluginConfig: PluginConfig): HvigorPlugin {
      ...
      return {
        pluginId: PLUGIN_ID,
        apply(node: HvigorNode) {
          // 获取模块名
          pluginConfig.moduleName = node.getNodeName();
          // 获取模块路径
          pluginConfig.modulePath = node.getNodePath();
          pluginExec(pluginConfig);
      }
    }
    ```

2. 扫描hvigor配置的路径下的所有文件，获取装饰器中配置的路由信息

    ```typescript
    function pluginExec(config: PluginConfig) {
      ...
      // 遍历需要扫描的文件列表
      config.scanFiles.forEach((file) => {
      // 文件绝对路径
      let sourcePath = `${config.modulePath}/${file}`;
      // 如果配置的文件路径没有ets后缀，则添加后缀名
      if(!sourcePath.endsWith('.ets')){
        sourcePath = sourcePath+'.ets';
      }
      // 获取文件相对路径
      const importPath = path.relative(`${config.modulePath}/${config.builderDir}`, sourcePath).replaceAll("\\", "/").replaceAll(".ets", "");
      const analyzer = new EtsAnalyzer(config, sourcePath);
      // 开始解析文件
      analyzer.start();
      console.log(JSON.stringify(analyzer.analyzeResult));
      console.log(importPath);
      // 如果解析的文件中存在装饰器，则将结果保存到列表中
      if (analyzer.routerAnnotationExisted) {
        templateModel.viewList.push({
          viewName: analyzer.analyzeResult.viewName,
          importPath: importPath,
          functionName:analyzer.analyzeResult.functionName
        });
        routerMap.routerMap.push({
          name: analyzer.analyzeResult.name,
          pageModule: config.moduleName,
          pageSourceFile: `${config.builderDir}/${config.builderFileName}`,
          registerFunction: `${analyzer.analyzeResult.functionName}Register`
        });
      }
      
      })
    }
    ```

3. 读取文件内容，通过遍历ts抽象语法树，找到自定义装饰器，读取路由信息，并通过关键字确认自定义组件的名称，其他的节点可以忽略

    ```typescript
    // ets文件解析
    export class EtsAnalyzer {
    
      start() {
        // 读取文件
        const sourceCode = readFileSync(this.sourcePath, "utf-8");
        // 解析文件，生成抽象语法树
        const sourceFile = ts.createSourceFile(this.sourcePath, sourceCode, ts.ScriptTarget.ES2021, false);
        // 遍历语法树
        ts.forEachChild(sourceFile, (node: ts.Node) => {
          this.resolveNode(node);
        });
      }
      // 根据类型对语法树节点进行处理
      resolveNode(node: ts.Node): NodeInfo | undefined {
        switch (node.kind) {
          case ts.SyntaxKind.ImportDeclaration:
            this.resolveImportDeclaration(node);
          break;
          case ts.SyntaxKind.MissingDeclaration:
            this.resolveMissDeclaration(node);
          break;
          case ts.SyntaxKind.Decorator:
            this.resolveDecoration(node);
          break;
          case ts.SyntaxKind.ExpressionStatement:
            this.resolveExpression(node);
          break;
          ...
      }
      ...
    }
   
    // 解析装饰器节点，根据名称找到自定义装饰器，并获取装饰器中配置的路由信息
    resolveDecoration(node: ts.Node) {
      // 转换为装饰器节点类型
      let decorator = node as ts.Decorator;
      // 判断表达式是否是函数调用
      if (decorator.expression.kind === ts.SyntaxKind.CallExpression) {
        const callExpression = decorator.expression as ts.CallExpression;
        // 表达式类型是否是标识符
        if (callExpression.expression.kind === ts.SyntaxKind.Identifier) {
          const identifier = callExpression.expression as ts.Identifier;
          // 标识符是否是自定义的装饰器
          if (identifier.text === this.pluginConfig.annotation) {
            this.routerAnnotationExisted = true;
            const arg = callExpression.arguments[0];
            // 调用方法的第一个参数是否是表达式
            if (arg.kind === ts.SyntaxKind.ObjectLiteralExpression) {
              const properties = (arg as ts.ObjectLiteralExpression).properties;
              // 第一个参数是否是表达式
              if (properties[0].kind === ts.SyntaxKind.PropertyAssignment) {
                // 设置的第一个参数是否是自定义装饰器中的变量名
                if ((properties[0].name as ts.Identifier).escapedText === "name") {
                  // 将装饰器中的变量的值赋值给解析结果中的变量
                  this.analyzeResult.name = (properties[0].initializer as ts.StringLiteral).text;
                }
              }
            }
          }
        }
      }
    }
   // 由于一个ets文件中可能有多个自定义组件，只有与hvigor中配置的关键字相同时，才是需要通过路由加载的组件
    resolveExpression(node: ts.Node) {
      let args = node as ts.ExpressionStatement;
      let identifier = this.resolveNode(args.expression);
      if (this.analyzeResult.name.endsWith(identifier?.value)) {
        this.analyzeResult.viewName = identifier?.value;
        // 通过identifier获取到的自定义组件的名字是大驼峰，方法名需要使用小驼峰，所以此处对组件名首字母进行处理，变为符合规则的小驼峰格式的方法名
        let viewName: string = identifier?.value.toString();
        viewName = `${viewName.charAt(0).toLowerCase()}${viewName.slice(1, viewName.length)}`;
        this.analyzeResult.functionName = viewName;
      }
    }
    ```

4. 生成路由表、组件注册类和Index.ets文件

    ```typescript
    ...
    generateBuilder(templateModel, config);
    generateRouterMap(routerMap, config);
    generateIndex(config);
    ...
    ```