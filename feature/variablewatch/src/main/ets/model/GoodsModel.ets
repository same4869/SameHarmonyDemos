/**
 * 表示商品模型的类型，是嵌套类的首层
 * @class
 */
export class FistGoodsModel {
  itemList: SecondGoodsItemList;

  constructor(itemList: SecondGoodsItemList) {
    this.itemList = itemList;
  }
}


// TODO: 知识点：使用@Observed装饰器，为了做到类的嵌套也可以被观察到属性的变化
@Observed
/**
 * 表示商品列表的类型，是嵌套类的第二层
 * @class
 */
export class SecondGoodsItemList {
  itemList: Array<ThirdGoodsItem>

  constructor(imgSrc: Array<ThirdGoodsItem>) {
    this.itemList = imgSrc
  }
}

@Observed
/**
 * 表示商品详细数据的类型，是嵌套类的第三层
 * @class
 */
export class ThirdGoodsItem {
  imageSrc: ResourceStr
  price: String

  constructor(imageSrc: ResourceStr, price: String) {
    this.imageSrc = imageSrc
    this.price = price
  }
}

/**
 * 需要更新的商品数据
 */
export let targetItemList: ThirdGoodsItem[] = [
  new ThirdGoodsItem($r("app.media.variablewatch_strawberry"), '价格5'),
  new ThirdGoodsItem($r("app.media.variablewatch_banana"), '价格6'),
  new ThirdGoodsItem($r("app.media.variablewatch_apple"), '价格7'),
  new ThirdGoodsItem($r("app.media.variablewatch_mango"), '价格8')
]

/**
 * 初始商品数据
 */
export let originItemList: ThirdGoodsItem[] = [
  new ThirdGoodsItem($r("app.media.variablewatch_grape"), '价格1'),
  new ThirdGoodsItem($r("app.media.variablewatch_kiwifruit"), '价格2'),
  new ThirdGoodsItem($r("app.media.variablewatch_persimmon"), '价格3'),
  new ThirdGoodsItem($r("app.media.variablewatch_watermelon"), '价格4')
]

export function loadSource(): Array<ThirdGoodsItem> {
  let itemDataArray: Array<ThirdGoodsItem> = []
  for (let index = 0; index < originItemList.length; index++) {
    let item = originItemList[index]
    itemDataArray.push(new ThirdGoodsItem(item.imageSrc, item.price))
  }
  return itemDataArray
}