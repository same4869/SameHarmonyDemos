import { TabBarDataType } from './TabBarDataType'

export const TABINFO: TabBarDataType[] = [
  new TabBarDataType(0, "首页", $r("app.media.custom_tab_tabBarMain"), $r("app.media.custom_tab_home")),
  new TabBarDataType(1, "新品", $r("app.media.custom_tab_new_selected"), $r("app.media.custom_tab_new")),
  new TabBarDataType(2, "社区", $r("app.media.custom_tab_community_selected"), $r("app.media.custom_tab_community")),
  new TabBarDataType(3, "购物车", $r("app.media.custom_tab_cart_selected"), $r("app.media.custom_tab_cart")),
  new TabBarDataType(4, "我的", $r("app.media.custom_tab_user_selected"), $r("app.media.custom_tab_user"))
]