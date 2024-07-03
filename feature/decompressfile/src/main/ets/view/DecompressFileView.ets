import { FileItem, FileListDataSource } from '../model/FileListDataSource';
import { MessageEvents, worker } from '@kit.ArkTS';
import { MToast } from '@same/common/src/main/ets/utils/MToast';
import { MLog } from '@same/common';
import fs from '@ohos.file.fs'; // 引入文件管理模块
import { BusinessError } from '@ohos.base';
import { AppRouter } from '@ohos/dynamicsRouter';

const LINEAR_GRADIENT_START = 0; // 颜色渐变起始位置
const LINEAR_GRADIENT_END = 1; // 颜色渐变结束位置

@AppRouter({ name: "decompressfile/DecompressFileView" })
@Component
export struct DecompressFileView {
  @State pathDir: string = ''; // 应用沙箱目录
  @State outFileDir: string = ''; // 解压后的文件所处的应用沙箱目录
  private rawfileZipName: string = 'decompress_file_test.zip'; // 待解压的文件名
  private fileListData: FileListDataSource = new FileListDataSource(); // 解压后的文件列表
  private context: Context = getContext(this);
  private rawfilePath: string = ''; // rawfile压缩文件的应用沙箱路径

  aboutToAppear() {
    this.initZip(this.rawfileZipName)
  }

  // 将项目目录rawfile下的压缩文件写入到应用的沙箱目录，用于后续介绍解压操作。
  initZip(rawfileZipName: string) {
    // 使用getRowFileContent接口以字节数组的形式获取到rawfile中的文件内容。
    this.context.resourceManager.getRawFileContent(rawfileZipName, (error: BusinessError, value: Uint8Array) => {
      if (error) {
        MLog.error(`getRawFileContent failed, error message: ${error.message}, error code: ${error.code}`);
      } else {
        const rawFile: Uint8Array = value;
        this.pathDir = this.context.filesDir; // 获取应用沙箱目录
        MLog.info(`Application Sandbox Directory: ${this.pathDir}`);
        this.rawfilePath = `${this.pathDir}/${rawfileZipName}`; // 设置rawfile压缩文件的应用沙箱路径
        const file = fs.openSync(this.rawfilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE); // 在指定路径以同步方法打开或创建文件
        // 使用fs.write接口将字节数组形式的rawfile的文件内容写入到指定沙箱路径filePath中
        fs.write(file.fd, rawFile.buffer).then((writeLen: number) => {
          MLog.info(`write data to file succeed and size is: ${writeLen}`);
        }).catch((err: BusinessError) => {
          MLog.error(`write data to file failed with error message: ${err.message}, error code: ${err.code}`);
        }).finally(() => {
          MLog.info('write finished');
          fs.closeSync(file); // 以同步方法关闭文件。
        });
      }
    });
  }

  // 性能：使用Worker子线程解压文件，https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/multi_thread_capability.md/
  decompressFileByWorker(rawfileZipName: string): void {
    /**
     * TODO：知识点：主线程中使用new worker.ThreadWorker创建Worker对象。
     * TODO：知识点：@标识路径加载形式：所有种类的模块加载本地HAR中的Worker线程文件，加载路径规则：@{moduleName}/ets/{relativePath}。
     */
    let workerInstance: worker.ThreadWorker = new worker.ThreadWorker('@decompressfile/ets/workers/Worker.ets')
    // TODO：知识点：主线程在onmessage中接收来自worker线程的消息。
    workerInstance.onmessage = (e: MessageEvents): void => {
      if (e.data) {
        MToast.showToast("文件解压成功")
        this.outFileDir = e.data
        MLog.info(`Decompressed Files outFileDir: ${this.outFileDir}`)
        //根据解压后的文件所属沙箱目录，获取解压后的文件列表
        this.getFileListData(this.outFileDir)
      } else {
        MLog.error('Decompress Files failed!')
      }
      // TODO：知识点：主线程使用terminate()销毁Worker线程。
      workerInstance.terminate();
    }
    /**
     * TODO：知识点：主线程使用postMessage()向worker线程发送消息。
     * 主线程使用postMessage()向worker线程发送应用沙箱路径和压缩文件名称。
     */
    workerInstance.postMessage({ pathDir: this.pathDir, rawfileZipName: rawfileZipName })
  }

  //获取解压后的文件列表
  getFileListData(outFileDir: string) {
    // TODO：知识点：使用fs.listFile接口获取解压得到的沙箱目录下的所有文件名。
    fs.listFile(outFileDir).then((fileNames: Array<string>) => {
      this.fileListData.clear() // 清空上一次获取的列表
      for (let i = 0; i < fileNames.length; i++) {
        this.fileListData.pushData(new FileItem(fileNames[i], `${outFileDir}/${fileNames[i]}`))
      }
    }).catch((err: BusinessError) => {
      MLog.error('list file failed with error message: ${err.message}, error code: ${err.code}')
    })
  }

  build() {
    Column() {
      Row() {
        Column() {
          Text("文件解压")
            .fontColor("#ffffff")
            .fontWeight(FontWeight.Bolder)
            .fontSize(26)
          Text("使用@ohos.zlib在Worker子线程解压文件")
            .fontColor("#ffffff")
        }
        .width(200)
        .alignItems(HorizontalAlign.Start)

        Image($r("app.media.decompress_file_ic_files_compress"))
          .width(60)
          .height(60)
      }
      .width("100%")
      .height(140)
      .padding(20)
      .justifyContent(FlexAlign.SpaceBetween)
      .borderRadius(12)
      .linearGradient({
        direction: GradientDirection.Top,
        repeating: true,
        colors: [["#8054a1ff", LINEAR_GRADIENT_START], ["#b354a1ff", LINEAR_GRADIENT_END]]
      })

      //压缩文件组件
      Row() {
        Image($r("app.media.decompress_file_ic_files_compress"))
          .width(20)
          .height(20)
          .margin({ right: 12 })
        Text(this.rawfileZipName)
          .fontSize(14)
          .layoutWeight(1)
        Button("解压")
          .fontWeight(FontWeight.Bold)
          .type(ButtonType.Normal)
          .width(60)
          .height(28)
          .borderRadius(12)
          .onClick(() => {
            this.decompressFileByWorker(this.rawfileZipName)
          })
      }
      .padding(12)
      .backgroundColor("#ffffff")

      Divider()

      Text("解压结果")
        .textAlign(TextAlign.Start)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width("100%")
        .padding(12)
        .backgroundColor("#4cadd8ff")

      Divider()

      List() {
        LazyForEach(this.fileListData, (item: FileItem) => {
          ListItem() {
            FileListItem({ item: item })
          }
        }, (item: FileItem) => JSON.stringify(item))
      }
      .cachedCount(5)
      .width("100%")
      .backgroundColor("#ffffff")
      .height(400)
      .layoutWeight(1)
      .divider({
        strokeWidth: 1,
        color: "#f1f3f5",
        startMargin: 12,
        endMargin: 12
      })
      .borderRadius({
        bottomLeft: 12,
        bottomRight: 12
      })

    }.height("100%")
    .padding(12)
    .backgroundColor("#f1f3f5")
  }
}

@Reusable
@Component
struct FileListItem {
  @State item: FileItem = new FileItem('', '');

  aboutToReuse(params: Record<string, FileItem>): void {
    this.item = params.item
  }

  build() {
    Row() {
      Image($r("app.media.decompress_file_ic_files_documents"))
        .width(20)
        .height(20)
        .margin({ right: 12 })
      Text(this.item.fileName)
        .fontSize(14)
    }
    .padding(12)
  }
}