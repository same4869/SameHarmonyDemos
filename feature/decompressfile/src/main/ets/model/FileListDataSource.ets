import { CommonLazyDataSourceModel } from '@same/common';

export class FileItem {
  fileName: string;
  filePath: string;

  constructor(fileName: string, filePath: string) {
    this.fileName = fileName;
    this.filePath = filePath;
  }
}

export class FileListDataSource extends CommonLazyDataSourceModel<FileItem>{

}