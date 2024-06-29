// TODO：知识点：通过context.startAbilityForResult接口拉起相机拍照，并通过result返回照片地址
import { common } from '@kit.AbilityKit';

const ACTION_PICKER_CAMERA: string = "ohos.want.action.imageCapture";
const KEY_RESULT_PICKER_CAMERA: string = "resourceUri";

export async function cameraCapture(context: common.UIAbilityContext): Promise<string> {
  // 通过context.startAbilityForResult拉起相机
  const result: common.AbilityResult = await context.startAbilityForResult({
    action: ACTION_PICKER_CAMERA, // 拉起相机的action
    parameters: {
      'supportMultiMode': false, // 是否可以同时拍照和录像
      'callBundleName': context.abilityInfo.bundleName // 拉起相机的应用的bundleName
    }
  })
  // 相机返回的数据，如果resultCode是0，则表示返回成功
  if (result.resultCode === 0) {
    // 获取返回结果中的数据
    const param: Record<string, Object> | undefined = result.want?.parameters;
    if (param !== undefined) {
      // 通过resourceUri获取照片的本地路径
      const resourceUri: string = param[KEY_RESULT_PICKER_CAMERA] as string;
      return resourceUri;
    }
  }
  return "";
}