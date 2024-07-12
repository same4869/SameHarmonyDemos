/**
 * @Author: xwang
 * @Date: 2024/7/12 15:26
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter';
import { CommodityList } from './CommodityList';
import { LoadingHUD } from './LoadingHUD';

@AppRouter({ name: "pageloading/PageLoading" })
@Component
export struct PageLoading {
  @State isLoading: Boolean = true;

  aboutToAppear(): void {
    // 模拟网络请求操作，请求网络3秒后得到数据，通知组件，变更列表数据
    setTimeout(() => {
      this.isLoading = false
    }, 3000)
  }

  build() {
    Stack() {
      if (this.isLoading) {
        LoadingHUD()
      } else {
        CommodityList()
      }
    }
    .width("100%")
    .height("100%")
    .backgroundColor(Color.White)
  }
}