/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BuilderNode, FrameNode, NodeController } from '@kit.ArkUI';

/**
 * 全局状态保留能力弹窗组件
 */
@Component
export struct GlobalStateDialog {
  @StorageProp('isShowGlobalStateDialog') isShowGlobalStateDialog: boolean = false;

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopEnd }) {
        // 关闭按钮
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Image($r("app.media.global_state_dialog_close_button"))
            .width($r('app.integer.ohos_global_state_dialog_close_button_image_size'))
            .height($r('app.integer.ohos_global_state_dialog_close_button_image_size'))
        }
        .backgroundColor($r('app.color.ohos_global_state_dialog_background_color'))
        .width($r('app.integer.ohos_global_state_dialog_close_button_image_size'))
        .height($r('app.integer.ohos_global_state_dialog_close_button_image_size'))
        .margin({ left: $r('app.integer.ohos_global_state_dialog_close_button_margin_left') })
        .onClick(() => {
          // 关闭全局弹窗
          GlobalStateDialogManager.operateGlobalStateDialog({ isShowGlobalStateDialog: false });
        })
      }.margin({ top: $r('app.integer.ohos_global_state_dialog_number_10') })

      // 弹窗的布局与内容，使用NodeContainer提前占位
      NodeContainer(GlobalStateDialogManager.getGlobalStateDialogNodeController())
    }
    .visibility(this.isShowGlobalStateDialog ? Visibility.Visible : Visibility.Hidden)
    .backgroundColor($r('app.color.ohos_global_state_dialog_background_color'))
    .height($r('app.string.ohos_global_state_dialog_sixty_percent'))
    .borderRadius({
      topLeft: $r('app.integer.ohos_global_state_dialog_number_10'),
      topRight: $r('app.integer.ohos_global_state_dialog_number_10')
    })
    .width($r('app.string.ohos_global_state_dialog_hundred_percent'))
    .animation({
      duration: 1000,
      curve: Curve.,
      iterations: 1,
      playMode: PlayMode.Normal
    })
  }
}

/**
 * 全局状态保留能力弹窗控制器，对外提供fillGlobalStateDialog函数来操作弹窗的布局与内容
 */
export class GlobalStateDialogNodeController extends NodeController {
  private uiContext: UIContext | null = null;
  private rootNode: BuilderNode<[ESObject]> | null = null;
  private wrapBuilder: WrappedBuilder<[ESObject]> | null = null;
  private params: ESObject;

  setUIContext(uiContext: UIContext) {
    this.uiContext = uiContext;
  }

  /**
   * 填充全局状态保留能力弹窗的布局以及内容
   * @param wrapBuilder 布局
   * @param params 内容
   */
  fillGlobalStateDialog(wrapBuilder: WrappedBuilder<[ESObject]>, params: ESObject) {
    this.wrapBuilder = wrapBuilder;
    this.params = params;
    this.refreshNode();
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.rootNode != null) {
      // 返回FrameNode节点
      return this.rootNode.getFrameNode();
    }
    // 返回null控制动态组件脱离绑定节点
    return null;
  }

  refreshNode() {
    if (!this.uiContext) {
      return;
    }
    // 创建节点，需要uiContext
    this.rootNode = new BuilderNode(this.uiContext)
    // 创建组件
    this.rootNode.build(this.wrapBuilder, this.params)
    this.rebuild();
  }
}

/**
 * 全局弹窗配置项
 */
interface GlobalStateDialogConfig {
  isShowGlobalStateDialog?: boolean; // 显隐控制：true显示/false隐藏
  wrapBuilder?: WrappedBuilder<[ESObject]>; // 布局
  params?: ESObject; // 内容
}

/**
 * 管理全局弹窗
 */
export class GlobalStateDialogManager {
  private static globalStateDialogController: GlobalStateDialogNodeController = new GlobalStateDialogNodeController();

  static getGlobalStateDialogNodeController(): GlobalStateDialogNodeController {
    return GlobalStateDialogManager.globalStateDialogController;
  }

  /**
   * 控制全局弹窗的显隐及内容布局
   * @param globalStateDialogConfig 配置全局弹窗
   */
  static operateGlobalStateDialog(globalStateDialogConfig: GlobalStateDialogConfig) {
    if (globalStateDialogConfig.isShowGlobalStateDialog !== undefined) {
      AppStorage.setOrCreate('isShowGlobalStateDialog', globalStateDialogConfig.isShowGlobalStateDialog);
    }
    if (globalStateDialogConfig.wrapBuilder) {
      GlobalStateDialogManager.globalStateDialogController.fillGlobalStateDialog(globalStateDialogConfig.wrapBuilder,
        globalStateDialogConfig.params);
    }
  }
}