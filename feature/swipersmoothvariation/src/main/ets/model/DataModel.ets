/**
 * @Author: xwang
 * @Date: 2024/7/8 13:34
 * @Description:
 **/
export interface GridItemInfo {
  name: Resource
  image: Resource
  prompt?: Resource
}
;

// swiper的第一个页面数据
export let dataPageOne: GridItemInfo[] = [
  { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
  { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
  { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
  { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
  { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
  {
    name: $r('app.string.swipersmoothvariation_name_pageone'),
    image: $r("app.media.swipersmoothvariation_taxi"),
    prompt: $r('app.string.swipersmoothvariation_first_prompt')
  },
  { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
  {
    name: $r('app.string.swipersmoothvariation_name_pageone'),
    image: $r("app.media.swipersmoothvariation_taxi"),
    prompt: $r('app.string.swipersmoothvariation_sec_prompt')
  },
  { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
  { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
];
// swiper的第二个页面数据
export let dataPageTwo: GridItemInfo[] = [
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
];
// swiper的第三个页面数据
export let dataPageThree: GridItemInfo[] = [
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
  {
    name: $r('app.string.swipersmoothvariation_name_pagethree'),
    image: $r("app.media.swipersmoothvariation_car_icon")
  },
];

// swiper的第四个页面数据
export let dataPageFour: GridItemInfo[] = [
  { name: $r('app.string.swipersmoothvariation_name_pagefour'), image: $r("app.media.swipersmoothvariation_taxi") }
];