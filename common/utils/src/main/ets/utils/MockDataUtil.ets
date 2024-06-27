import { util } from '@kit.ArkTS';

export class MockDataUtil {
  //传入rawfile下面的一个json文件作为数据源，生产对应泛型的实体类
  static getMockDataFromJson<T>(mockFileDir: string): Array<T> {
    const jsonObj: JsonObject = new JsonObject(mockFileDir);
    const mModelMockData: Array<T> = jsonObj.getMockData()
    return mModelMockData
  }
}

class JsonObjType <T> {
  list: Array<T> = [];
}

class JsonObject {
  private jsonFileDir: string = '';

  constructor(jsonFileDir: string) {
    this.jsonFileDir = jsonFileDir;
  }

  // 获取数据
  getMockData<T>(): Array<T> {
    // 从本地文件中获取数据
    const value = getContext().resourceManager.getRawFileContentSync(this.jsonFileDir);
    // 解码为utf-8格式
    const textDecoder = util.TextDecoder.create('utf-8', {
      ignoreBOM: true
    });
    const textDecoderResult = textDecoder.decodeWithStream(new Uint8Array(value.buffer));
    const jsonObj: JsonObjType<T> = JSON.parse(textDecoderResult) as JsonObjType<T>;
    const dataModelBuckets: Array<T> = [];
    const dataModelObj = jsonObj.list;
    for (let i = 0; i < dataModelObj.length; i++) {
      dataModelBuckets.push(dataModelObj[i]);
    }
    return dataModelBuckets;
  }
}

