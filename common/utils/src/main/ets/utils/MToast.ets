import promptAction from '@ohos.promptAction'
import { MLog } from '../log/MLog'

/**
 @author: XWANG
 @date: 2024/1/4
 @description: toast封装，先只封最基本的，更多扩展参考https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/js-apis-promptaction-0000001478341345-V3#ZH-CN_TOPIC_0000001573929081__promptactionshowtoast
 */

export class MToast {
  static showToast(message: string, duration: number = 2000) {
    try {
      promptAction.showToast({
        message: message,
        duration: duration,
        bottom: "center",
      })
    } catch (e) {
      MLog.error(`showToast args error code is ${e.code}, message is ${e.message}`)
    }
  }
}