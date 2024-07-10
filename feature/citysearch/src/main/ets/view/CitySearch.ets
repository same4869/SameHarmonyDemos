/**
 * @Author: xwang
 * @Date: 2024/7/10 14:14
 * @Description:
 **/
import { AppRouter } from '@ohos/dynamicsRouter'
import { ALL_CITY2, CITY_DATA } from '../model/DetailData';
import { CityView } from './CityView';
import { SearchView } from './SearchView';

@AppRouter({ name: "citysearch/CitySearch" })
@Component
export struct CitySearch {
  // 搜索值
  @State changeValue: string = '';
  // 占位
  @State placeholder: string = getContext().resourceManager.getStringSync($r('app.string.citysearch_placeholder'));
  // 搜索控制器
  controller: SearchController = new SearchController();
  // 是否展示搜索结果列表
  @State isSearchState: boolean = false;
  // 搜索结果
  @State searchList: string[] = [];

  build() {
    Column() {
      //搜索框
      Search({ value: this.changeValue, placeholder: this.placeholder, controller: this.controller })
        .searchButton("搜索")
        .width("100%")
        .height(40)
        .margin({ left: 3 })
        .backgroundColor("#d9d8d8")
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .textFont({ size: 14, weight: 400 })
        .onSubmit((value: string) => {
          if (value.length === 0) {
            value = this.placeholder
          }
          this.changeValue = value
          this.isSearchState = true
          this.searchCityList(value)
        })
        .onChange((value: string) => {
          this.changeValue = value;
          // 搜索
          this.searchCityList(value);
          if (value.length === 0) {
            // 关闭搜索列表
            this.isSearchState = false;
            // 清空数据
            this.searchList.splice(0, this.searchList.length);
          } else {
            this.changeValue = value;
            // 搜索
            this.searchCityList(value);
            this.isSearchState = true;
          }
        })

      // 城市列表组件
      CityView({ isSearchState: $isSearchState, changeValue:$changeValue })
        .margin({ top: 15 })

      // 搜索组件，将数据传递到搜索列表
      SearchView({ searchList: $searchList, isSearchState: $isSearchState, changeValue:$changeValue })
        .width("100%")
        .layoutWeight(1)
    }
    .width("100%")
    .height("100%")
    .padding({ left: 10, right: 16 })
    .backgroundColor("#f1f3f5")
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }

  searchCityList(value: string) {
    const cityNames: string[] = []
    ALL_CITY2.forEach(item => {
      if (item.name === value) {
        // 当搜索关键字，将相关城市信息展示。例如搜索"an"：展示"安庆"，"安阳"。
        item.city.forEach(city => {
          cityNames.push(city)
        })
        this.searchList = cityNames
        return
      }
    })
    CITY_DATA.forEach(item => {
      item.city.forEach(city => {
        // 当搜索汉字，会进行模糊搜索，将相关城市信息展示。例如搜索"长"：展示"长沙"，"长春"。
        if (city.includes(value)) {
          cityNames.push(city);
        }
      })
    })
    this.searchList = cityNames;
  }
}