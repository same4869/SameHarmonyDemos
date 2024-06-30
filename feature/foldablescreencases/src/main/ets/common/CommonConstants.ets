import { MusicInfo } from '../model/MusicModel';

export default class CommonConstants {

  static readonly TEST_MUSIC_INFO = {
    title: '后来',
    cover: $rawfile('cover.webp'),
    singer: '刘若英',
    duration: 341000,
    lyrics: ['歌词', '后来 我总算学会了 如何去爱',

    '可惜你 早已远去 消失在人海',

    '后来终于在眼泪中明白',

    '有些人 一旦错过就不再',

    '栀子花 白花瓣 落在我蓝色百褶裙上',

    '爱你 你轻声说',

    '我低下头 闻见一阵芬芳',

    '那个永恒的夜晚 十七岁仲夏 你吻我的那个夜晚',

    '让我往后的时光 每当有感叹',

    '总想起 当天的星光',

    `那时候的爱情 为什么就能那样简单`,

    `而又是为什么 人年少时`,

    `一定要让深爱的人受伤`,

    `在这相似的深夜里 你是否一样 也在静静追悔感伤`,

    `如果当时我们能 不那么倔强`,

    `现在也 不那么遗憾`,

    `你都如何回忆我 带着笑或是很沉默`,

    `这些年来 有没有人能让你不寂寞`,

    `后来 我总算学会了 如何去爱`,

    `可惜你 早已远去 消失在人海`,

    `后来终于在眼泪中明白`,

    `有些人 一旦错过就不再`,

    `你都如何回忆我 带着笑或是很沉默`,

    `这些年来 有没有人能让你不寂寞`,

    `后来 我总算学会了 如何去爱`,

    `可惜你 早已远去 消失在人海`,

    `后来终于在眼泪中明白`,

    `有些人 一旦错过就不再`,

    `后来 我总算学会了 如何去爱`,

    `可惜你 早已远去 消失在人海`,

    `后来终于在眼泪中明白`,

    `有些人 一旦错过就不再`,

    `永远不会再重来`,

    `有一个男孩 爱着那个女孩`,

    ],
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

  /**
   * 歌曲时间显示文本展示最大行数
   */
  static readonly MUSIC_TIME_MAX_LINES = 1;

  /**
   * 歌曲时间显示文本flex布局所占父组件尺寸的比例
   */
  static readonly MUSIC_TIME_FLEX_SHRINK = 0;

  /**
   * 歌曲进度条最小值
   */
  static readonly MUSIC_SLIDER_MIN = 0;

  /**
   * 歌曲控制按钮flex布局所占父组件尺寸的比例
   */
  static readonly MUSIC_CTRL_BTN_FLEX_SHRINK = 1;
}