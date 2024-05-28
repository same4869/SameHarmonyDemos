import hilog from '@ohos.hilog'
import { LogOptions } from './LogOptions'

/**
 @author: XWANG
 @date: 2024/1/4
 @description: 日志打印工具类,支持一些配置可提前init
 */

export class MLog {
  private static mTag: string = "mlog"
  private static mDomain: number = 0x0001
  private static mEnable: boolean = true //日志总开关
  private static mIsHilog: boolean = true //默认是用hilog进行打印
  private static mLogSize = 1000 //打印的最大长度

  static init(object: LogOptions) {
    const tag: string = object.tag
    const domain: number = object.domain //日志输出级别
    const enable: boolean = object.enable //是否关闭日志
    const isHilog: boolean = object.isHilog //是否是hilog打印
    const logSize: number = object.logSize //日志输出大小

    if (tag != undefined) {
      this.mTag = tag
    }
    if (domain != undefined) {
      this.mDomain = domain
    }
    if (enable != undefined) {
      this.mEnable = enable
    }
    if (isHilog != undefined) {
      this.mIsHilog = isHilog
    }
    if (logSize != undefined) {
      this.mLogSize = logSize
    }
  }

  //需要先调用isLoggable确认某个domain、tag和日志级别是否被禁止打印日志
  static isLoggable(level: hilog.LogLevel): boolean {
    return hilog.isLoggable(this.mDomain, this.mTag, level)
  }

  /*
 * console形式打印log日志,只支持console
 * */
  static log(message: any, tag?: string) {
    console.log(this.getMessage(hilog.LogLevel.INFO, tag == undefined ? this.mTag : tag, message))
  }

  /*
* info日志
* */
  static info(message: any, tag?: string) {
    this.logLevel(hilog.LogLevel.INFO, tag, message)
  }

  /*
* debug日志
* */
  static debug(message: any, tag?: string) {
    this.logLevel(hilog.LogLevel.DEBUG, tag, message)
  }


  /*
* error日志,不带标签
* */
  static error(message: any, tag?: string) {
    this.logLevel(hilog.LogLevel.ERROR, tag, message)
  }


  /*
* warn日志
* */
  static warn(message: any, tag?: string) {
    this.logLevel(hilog.LogLevel.WARN, tag, message)
  }

  /*
* fatal日志
* */
  static fatal(message: any, tag?: string) {
    this.logLevel(hilog.LogLevel.FATAL, tag, message)
  }

  /*
 *统一输出日志
 * */
  private static logLevel(level: hilog.LogLevel, tag: string, message: any) {
    //如果关闭状态，则不打印日志
    if (!this.mEnable) {
      return
    }

    //没有tag时，使用默认的
    if (tag == undefined) {
      tag = this.mTag
    }

    const content = this.getMessage(level, tag, message) //最终的内容展示

    const len = content.length / this.mLogSize
    for (var i = 0; i < len; i++) {
      var con = content.substring(i * this.mLogSize, (i + 1) * this.mLogSize)
      if (i != 0) {
        con = "|" + con
      }
      //打印日志
      if (this.mIsHilog) {
        //使用hilog
        switch (level) {
          case hilog.LogLevel.INFO: //info
            hilog.info(this.mDomain, tag, con)
            break
          case hilog.LogLevel.WARN: //WARN
            hilog.warn(this.mDomain, tag, con)
            break
          case hilog.LogLevel.DEBUG: //DEBUG
            hilog.debug(this.mDomain, tag, con)
            break
          case hilog.LogLevel.ERROR: //ERROR
            hilog.error(this.mDomain, tag, con)
            break
          case hilog.LogLevel.FATAL: //FATAL
            hilog.fatal(this.mDomain, tag, con)
            break
        }
      } else {
        //使用console
        switch (level) {
          case hilog.LogLevel.INFO: //info
            console.info(con)
            break
          case hilog.LogLevel.WARN: //WARN
            console.warn(con)
            break
          case hilog.LogLevel.DEBUG: //DEBUG
            console.debug(con)
            break
          case hilog.LogLevel.ERROR: //ERROR
            console.error(con)
            break
          case hilog.LogLevel.FATAL: //FATAL
            console.log(con)
            break
        }
      }
    }
  }

  /**
   * 获取输出位置
   * */
  static getMessage(level: hilog.LogLevel, tag: string, message: any): string {
    var log = "┌───────" + tag + "────────────────────────────────────────────────────────────────────────────────"
    log = log.substring(0, log.length - tag.length) + "\n"

    try {
      //打印行号，但是测试下来不准，先关掉
      // const stackTrace = new Error().stack
      // const traceArray = stackTrace.split('\n')
      // const trace = traceArray[traceArray.length-2]
      // log = log + "|" + trace

      var type = typeof message
      if (type == "object") {
        //是对象
        message = this.getObjectToJson(message)
      } else if (type == "string") {
        //判断是否包含大括号
        const content = message + ""
        if (content.startsWith("{") && content.endsWith("}")) {
          //对象
          const obj = JSON.parse(message)
          message = this.getObjectToJson(obj)
        } else {
          message = content
        }
      }
      log = log + "\n|    " + message
    } catch (e) {
    }

    log = log + "\n└───────────────────────────────────────────────────────────────────────────────────────"
    return log
  }

  /*
 *对象转Json
 * */
  private static getObjectToJson(message: object): String {
    const json = JSON.stringify(message, null, 2)
    const endMessage = json.replace(/\n/g, "\n|    ")
    return endMessage
  }
}