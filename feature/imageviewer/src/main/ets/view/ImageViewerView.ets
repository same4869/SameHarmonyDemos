import { CommonLazyDataSourceModel } from '../model/BaseDataSource'
import { common } from '@kit.AbilityKit';
import { ImageItemView } from './ImageItemView';

@Entry({ routeName: "imageviewer/ImageViewerView" })
@Component
export struct ImageViewerView {
  @State isEnableSwipe: boolean = true;
  @Provide bgc: Color = Color.Brown;
  swipeController: SwiperController = new SwiperController()
  imageDataSource: CommonLazyDataSourceModel<string> = new CommonLazyDataSourceModel()
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    const resourceDir: string = this.context.resourceDir
    this.imageDataSource.pushData(resourceDir + "/imageviewer_test1.jpg")
    this.imageDataSource.pushData(resourceDir + "/imageviewer_test2.png")
    this.imageDataSource.pushData(resourceDir + "/imageviewer_test3.jpg")
  }

  build() {
    Swiper(this.swipeController) {
      LazyForEach(this.imageDataSource, (item: string, index: number) => {
        ImageItemView({ imageUri: item, isEnableSwipe: this.isEnableSwipe })
          .size({ height: "100%", width: "100%" })
      })
    }
    .size({ width: "100%", height: "100%" })
    .autoPlay(false)
    .indicator(false)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .cachedCount(2)
    .loop(false)
    .disableSwipe(!this.isEnableSwipe)
    .onClick(() => {

    })
  }
}