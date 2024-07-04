/**
 * @Author: xwang
 * @Date: 2024/7/4 10:45
 * @Description:
 **/
import { IconDataModel, ProductDataModel } from '../model/IconModel';

// 快捷图标数据
export const ICON_DATA1: Array<IconDataModel> = [
  new IconDataModel(0, 2, $r("app.media.component_stack_ic_device_matebook_filled"), '笔记本'),
  new IconDataModel(1, 2, $r("app.media.component_stack_ic_device_smartscreen_filled"), '智慧屏'),
  new IconDataModel(2, 1, $r("app.media.component_stack_ic_device_soundx_filled"), '音箱'),
  new IconDataModel(3, 1, $r("app.media.component_stack_ic_device_vrglass_filled"), 'VR眼镜'),
  new IconDataModel(4, 1, $r("app.media.component_stack_ic_device_watch_filled"), '手表'),
  new IconDataModel(5, 1, $r("app.media.component_stack_ic_public_devices_phone_filled"), '手机')
];

// 快捷图标数据
export const ICON_DATA2: Array<IconDataModel> = [
  new IconDataModel(0, 1, $r("app.media.component_stack_ic_gallery_puzzle"), '拼图'),
  new IconDataModel(1, 1, $r("app.media.component_stack_ic_public_car"), '汽车'),
  new IconDataModel(2, 1, $r("app.media.component_stack_ic_public_cards"), '钱包'),
  new IconDataModel(3, 1, $r("app.media.component_stack_ic_public_highlight"), '收藏'),
  new IconDataModel(4, 1, $r("app.media.component_stack_ic_contacts_birthday"), '生日'),
];

// 商品列表数据源
export const PRODUCT_DATA: Array<ProductDataModel> = [
  new ProductDataModel(0, $r("app.media.component_stack_product00"), "充电宝", "￥79.9", "7天保价"),
  new ProductDataModel(1, $r("app.media.component_stack_product01"), "笔记本电脑", "￥6975.9", "15天保价"),
  new ProductDataModel(2, $r("app.media.component_stack_product02"), "移动手机", "4279.6", "30天保价"),
  new ProductDataModel(3, $r("app.media.component_stack_product03"), "电动按摩椅", "5385.4", "7天保价"),
  new ProductDataModel(4, $r("app.media.component_stack_product04"), "折叠屏", "1252.9", "30天保价"),
  new ProductDataModel(5, $r("app.media.component_stack_product05"), "极简潮流背包", "105.3", "30天保价")
];