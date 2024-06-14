import { PullToRefresh } from '@ohos/pulltorefresh';
import { CommonLazyDataSourceModel, MLog, MockDataUtil } from '@same/common/Index';
import { util } from '@kit.ArkTS';

const NEWS_TITLE_MAX_LINES: number = 1;
const NEWS_TITLE_TEXT_FONT_WEIGHT: number = 500;
const NEWS_CONTENT_MAX_LINES: number = 2;
const NEWS_TIME_MAX_LINES: number = 1;
const NEWS_PAGE_TEXT_FONT_WEIGHT: number = 600;
const NEWS_RESOLVE_SUCCESS: string = '刷新成功';
const NEWS_MOCK_DATA_COUNT: number = 8; // 每份模拟数据所含的新闻个数为8
const MOCK_DATA_FILE_ONE_DIR: string = 'mockDataOne.json'; // 模拟数据路径
const MOCK_DATA_FILE_TWO_DIR: string = 'mockDataTwo.json'; // 模拟数据路径
const NEWS_REFRESH_TIME: number = 1500; // 数据刷新时间

@Preview
@Component
@Entry({ routeName: 'pulltorefreshnews/PullToRefreshNews' })
export struct PullToRefreshNews {
  @State newsData: NewsDataSource = new NewsDataSource()
  private mockFlag: boolean = true
  private scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    const newsModelMockData: Array<NewsData> = MockDataUtil.getMockDataFromJson<NewsData>(MOCK_DATA_FILE_ONE_DIR)
    for (let j = 0; j < NEWS_MOCK_DATA_COUNT; j++) {
      this.newsData.pushData(newsModelMockData[j]);
    }
  }

  build() {
    Column() {
      Text("资讯")
        .fontSize(18)
        .fontWeight(NEWS_PAGE_TEXT_FONT_WEIGHT)
        .textAlign(TextAlign.Start)
        .lineHeight(40)
        .padding({ left: "3.3%" })
        .width("100%")
        .height("7%")
        .backgroundColor("#f1f3f5")

      Column() {
        PullToRefresh({
          // TODO: 知识点：使用PullToRefresh组件时需要先绑定数据与主体布局。若使用LazyForEach组件渲染列表时，需将UI方法使用@Builder修饰并传入customList属性中。
          // 必传项，列表组件所绑定的数据
          data: $newsData,
          // 必传项，需绑定传入主体布局内的列表或宫格组件
          scroller: this.scroller,
          // 必传项，自定义主体布局，内部有列表或宫格组件
          customList: () => {
            // 一个用@Builder修饰过的UI方法
            this.getListView()
          },
          // TODO: 知识点：设置onRefresh下拉刷新回调方法，该方法必须返回一个Promise类型。
          onRefresh: () => {
            return new Promise<string>((resolve, reject) => {
              MLog.debug("------onRefresh-------")
              // 模拟网络请求操作，请求网络1.5秒后得到数据，通知组件，变更列表数据
              setTimeout(() => {
                this.newsData.clear()
                let newsModelMockData: Array<NewsData> = []
                if (this.mockFlag) {
                  newsModelMockData = MockDataUtil.getMockDataFromJson<NewsData>(MOCK_DATA_FILE_TWO_DIR)
                } else {
                  newsModelMockData = MockDataUtil.getMockDataFromJson<NewsData>(MOCK_DATA_FILE_ONE_DIR)
                }
                this.mockFlag = !this.mockFlag
                for (let index = 0; index < NEWS_MOCK_DATA_COUNT; index++) {
                  this.newsData.pushData(newsModelMockData[index])
                }
                resolve(NEWS_RESOLVE_SUCCESS)
              }, NEWS_REFRESH_TIME)
            })
          },
          // TODO: 知识点：设置onLoadMore上滑加载更多数据回调方法，该方法必须返回一个Promise类型。
          onLoadMore: () => {
            return new Promise<string>((resolve, reject) => {
              MLog.debug("------onLoadMore-------")
              // 模拟网络请求操作，请求网络1.5秒后得到数据，通知组件，变更列表数据
              setTimeout(() => {
                let newsModelMockData = MockDataUtil.getMockDataFromJson<NewsData>(MOCK_DATA_FILE_ONE_DIR)
                for (let j = 0; j < NEWS_MOCK_DATA_COUNT; j++) {
                  this.newsData.pushData(newsModelMockData[j])
                }
                resolve(NEWS_RESOLVE_SUCCESS)
              }, NEWS_REFRESH_TIME)
            })
          },
          customLoad: null,
          customRefresh: null
        })
      }
      .backgroundColor("#f1f3f5")

    }.height("93.3%")
  }

  @Builder
  private getListView() {
    List({
      space: 3, scroller: this.scroller
    }) {
      LazyForEach(this.newsData, (item: NewsData) => {
        ListItem() {
          newsItem({
            newTitle: item.newsTitle,
            newContent: item.newsContent,
            newTime: item.newsTime
          })
        }
        .backgroundColor("#ffffff")
        .margin({ bottom: "12vp", left: "3.3%" })
        .borderRadius(16)
      }, (item: NewsData, index?: number) => JSON.stringify(item) + index)
    }
    .width("100%")
    .backgroundColor("f1f3f5")
    // TODO: 知识点：必须设置列表为滑动到边缘无效果，否则无法触发pullToRefresh组件的上滑下拉方法。
    .edgeEffect(EdgeEffect.None)
  }
}

@Component
struct newsItem {
  private newTitle: ResourceStr = ""
  private newContent: ResourceStr = ""
  private newTime: ResourceStr = ""

  build() {
    Column() {
      Row() {
        Image($r("app.media.pull_refresh_news"))
          .width("9.9%")
          .height("80%")
          .objectFit(ImageFit.Contain)
        Text(this.newTitle)
          .fontSize(16)
          .fontColor("#000000")
          .width("78.6%")
          .maxLines(NEWS_TITLE_MAX_LINES)
          .margin({ left: "2.4%" })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(NEWS_TITLE_TEXT_FONT_WEIGHT)
      }
      .alignItems(VerticalAlign.Center)
      .height("20vp")
      .margin({ top: "16vp", left: "3.5%" })

      Text(this.newContent)
        .fontSize(14)
        .lineHeight(18)
        .fontColor("#000000")
        .height("5.8%")
        .width("93%")
        .maxLines(NEWS_TITLE_MAX_LINES)
        .margin({ left: "3.5%", top: "1.4%" })
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(this.newTime)
        .fontSize(10)
        .fontColor("#989898")
        .height("3.4%")
        .width("93%")
        .maxLines(NEWS_TITLE_MAX_LINES)
        .margin({ left: "3.5%", top: "1.4%" })
        .textOverflow({ overflow: TextOverflow.None })
    }
    .alignItems(HorizontalAlign.Start)
  }
}

// 新闻数据对象
class NewsData {
  newsId: string
  newsTitle: string | Resource
  newsContent: string | Resource
  newsTime: string | Resource

  toString(): string {
    return this.newsId + ' ' + this.newsTitle + ' ' + this.newsContent + ' ' + this.newsTime;
  }

  constructor(id: string, title: string | Resource, content: string | Resource, time: string | Resource) {
    this.newsId = id;
    this.newsTitle = title;
    this.newsContent = content;
    this.newsTime = time;
  }
}

class NewsDataSource extends CommonLazyDataSourceModel<NewsData> {
}
