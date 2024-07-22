/**
 * @Author: xwang
 * @Date: 2024/7/22 10:06
 * @Description:
 **/
import { CommonLazyDataSourceModel } from '@same/common';
import { MEMO_DATA } from './MockData';

/**
 * 笔记信息类型
 */
export class MemoInfo {
  memoId: string;
  title: string;
  time: string;
  imageSrc: string;
  content: string;

  constructor(memoId: string, title: string, time: string, imageSrc: string, content: string) {
    this.memoId = memoId;
    this.title = title;
    this.time = time;
    this.imageSrc = imageSrc;
    this.content = content;
  }
}

export class MemoDataSource extends CommonLazyDataSourceModel<MemoInfo> {
}