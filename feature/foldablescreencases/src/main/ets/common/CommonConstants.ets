import { MusicInfo } from '../model/MusicModel';

export default class CommonConstants {

  static readonly TEST_MUSIC_INFO = {
    title: '后来',
    cover: $rawfile('cover.webp'),
    singer: '刘若英',
    duration: 341000,
    lyrics: ['歌词', 'coming soon...'],
    res: 'houlai.mp3'
  } as MusicInfo;

  /**
   * FolderStack组件中，需要在折叠态下移动到上屏的组件id
   */
  static readonly FOLDER_STACK_UP_COMP_ID = 'folderStackUpperSubComp';
  /**
   * 歌曲信息组件高度（折叠屏其他状态）
   */
  static readonly MUSIC_INFO_COMP_HEIGHT_COMMON = '90%';
  /**
   * 音乐播放器控制按钮尺寸（普通）
   */
  static readonly MUSIC_PLAYER_CTRL_BTN_SIZE_COMMON = 30;
  /**
   * 音乐播放器控制按钮尺寸（大）
   */
  static readonly MUSIC_PLAYER_CTRL_BTN_SIZE_BIG = 50;

  static readonly MUSIC_DURATION = 400;

  /**
   * 歌曲歌词组件上外边距（折叠屏折叠态或非折叠屏）
   */
  static readonly MUSIC_LYRICS_COMP_MARGIN_TOP_COMMON = 0;

  /**
   * 歌曲封面图尺寸（折叠屏折叠态或者非折叠屏）
   */
  static readonly MUSIC_COVER_SIZE_COMMON = 150;

  /**
   * 歌曲歌词组件高度（折叠屏展开态）
   */
  static readonly MUSIC_LYRICS_COMP_HEIGHT_EXPANDED = '50%';

  /**
   * 歌曲封面图尺寸（折叠屏展开态）
   */
  static readonly MUSIC_COVER_SIZE_EXPANDED = 300;

  /**
   * 歌曲歌词组件上外边距（折叠屏半折叠态或展开态）
   */
  static readonly MUSIC_LYRICS_COMP_MARGIN_TOP_EXPANDED = 100;

  /**
   * 歌曲歌词组件高度（折叠屏折叠态或者非折叠屏）
   */
  static readonly MUSIC_LYRICS_COMP_HEIGHT_COMMON = '30%';

  /**
   * 歌曲封面图尺寸（折叠屏半折叠态）
   */
  static readonly MUSIC_COVER_SIZE_HALF_FOLDED = 200;

  /**
   * 歌曲信息组件高度（折叠屏半折叠态）
   */
  static readonly MUSIC_INFO_COMP_HEIGHT_HALF_FOLDED = '100%';

  /**
   * 歌曲歌词组件高度（折叠屏半折叠态）
   */
  static readonly MUSIC_LYRICS_COMP_HEIGHT_HALF_FOLDED = '25%';

  /**
   * avplayer闲置状态
   */
  static readonly AVPLAYER_STATE_IDLE = 'idle';
  /**
   * avplayer资源初始化状态
   */
  static readonly AVPLAYER_STATE_INITIALIZED = 'initialized';
  /**
   * avplayer已准备状态
   */
  static readonly AVPLAYER_STATE_PREPARED = 'prepared';
  /**
   * avplayer正在播放状态
   */
  static readonly AVPLAYER_STATE_PLAYING = 'playing';
  /**
   * avplayer暂停状态
   */
  static readonly AVPLAYER_STATE_PAUSED = 'paused';
  /**
   * avplayer播放至结尾状态
   */
  static readonly AVPLAYER_STATE_COMPLETED = 'completed';
  /**
   * avplayer停止状态
   */
  static readonly AVPLAYER_STATE_STOPPED = 'stopped';
  /**
   * avplayer销毁状态
   */
  static readonly AVPLAYER_STATE_RELEASED = 'released';
  /**
   * avplayer错误状态
   */
  static readonly AVPLAYER_STATE_ERROR = 'error';

  /**
   * 1分钟内的秒数
   */
  static readonly SECONDS_IN_MINUTE = 60;
  /**
   * 1小时内的秒数
   */
  static readonly SECONDS_IN_HOUR = 3600;

  /**
   * 歌曲进度条最大值
   */
  static readonly MUSIC_SLIDER_MAX = 100;
}