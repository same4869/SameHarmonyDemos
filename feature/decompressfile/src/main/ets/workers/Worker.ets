import worker, { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope } from '@ohos.worker';
import { MLog } from '@same/common';
import fs from '@ohos.file.fs';
import { BusinessError, zlib } from '@kit.BasicServicesKit';

// 绑定Worker对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = (e: MessageEvents): void => {
  MLog.info(`Worker onmessage：${JSON.stringify(e.data)}`)
  const pathDir: string = e.data.pathDir //沙箱目录
  const rawfileZipName: string = e.data.rawfileZipName //.zip后缀的压缩文件名称
  //沙箱目录和去掉文件名后缀的压缩文件名称拼接成解压输出目录
  const outFileDir: string = `${pathDir}/${rawfileZipName.split('.')[0]}`;
  // TODO：知识点：使用fs.access判断目录是否已经存在。
  fs.access(outFileDir).then((res: boolean) => {
    if (!res) {
      // TODO：知识点：使用fs.mkdirSync创建目录，用于存放解压后的文件。
      fs.mkdirSync(outFileDir)
      MLog.info('mkdirSync succeed')
    }
    // TODO：知识点：使用zlib.decompressfile接口对沙箱目录中的压缩文件进行解压操作，解压至指定沙箱目录outFileDir。
    // 如果待解压的文件或文件夹在解压后的路径下已经存在，则会直接覆盖同名文件或同名文件夹中的同名文件。
    zlib.decompressFile(`${pathDir}/${rawfileZipName}`, outFileDir, (errData: BusinessError) => {
      if (errData !== null) {
        MLog.error(`decompressFile failed. code is ${errData.code}, message is ${errData.message}`);
      } else {
        MLog.info(`decompressFile succeed. outFileDir is ${outFileDir}`);
        // TODO：知识点：Worker线程向主线程发送信息。
        workerPort.postMessage(outFileDir);
      }
    })
  }).catch((error: BusinessError) => {
    MLog.error(`access failed with error message: ${error.message}, error code: ${error.code}`);
  })
}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents): void => {
  MLog.error(`Worker onmessageerror ${JSON.stringify(e.data)}`);
};

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent): void => {
  MLog.error(`Worker: onerror = ${e.message}`);
};
