/**
 * 歌曲数据模型
 */
import { BaseDataSource, CommonLazyDataSourceModel } from '@same/common';

export class MusicModel {
  private titleRaw: string = '';

  public get title(): string {
    return this.titleRaw;
  }

  private coverRaw: Resource;

  public get cover(): Resource {
    return this.coverRaw;
  }

  private singerRaw: string = '';

  public get singer(): string {
    return this.singerRaw;
  }

  private rawTotalTime: number = 0;

  public get totalTime(): number {
    return this.rawTotalTime;
  }

  private curTimeRaw: number = 0;

  public get curTime(): number {
    return this.curTimeRaw;
  }

  private lyricsInfoRaw: LyricsDataSource;

  public get lyricsInfo(): LyricsDataSource {
    return this.lyricsInfoRaw;
  }

  private resRaw: string = '';

  public get res(): string {
    return this.resRaw;
  }

  constructor(options: MusicInfo) {
    this.titleRaw = options.title;
    this.coverRaw = options.cover;
    this.singerRaw = options.singer;
    this.rawTotalTime = options.duration;
    this.lyricsInfoRaw = new LyricsDataSource(options.lyrics);
    this.resRaw = options.res;
  }
}

/**
 * 歌曲信息接口
 */
export interface MusicInfo {
  title: string,
  cover: Resource,
  singer: string,
  duration: number,
  lyrics: Array<string>,
  res: string,
}

export class LyricsDataSource extends BaseDataSource<string> {
  private lyricsDataArr: Array<string>;

  constructor(lyricsArr: Array<string>) {
    super()
    this.lyricsDataArr = lyricsArr;
  }

  totalCount(): number {
    return this.lyricsDataArr.length;
  }

  getData(index: number): string {
    return this.lyricsDataArr[index];
  }
}