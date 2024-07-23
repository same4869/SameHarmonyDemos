/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ImageText } from './ImageText';
import { promptAction } from '@kit.ArkUI';
import { FriendMoment } from './ListSlideToHistory';

/**
 * 列表子组件
 */
//TODO: 性能知识点：@Reusable复用组件优化，详情请见：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/best-practices-long-list-0000001728333749#section36781044162218
@Reusable
@Component
export struct OneMoment {
  @Prop moment: FriendMoment;

  build() {
    Column() {
      Row() {
        Image($r(this.moment.avatar))
          .autoResize(false)
          .width($r('app.integer.list_slide_to_history_user_image_width'))
          .height($r('app.integer.list_slide_to_history_user_image_height'))
          .borderRadius($r('app.integer.list_slide_to_history_user_image_border_radius'))
        Column() {
          Text(this.moment.userName)
            .fontSize($r('app.integer.list_slide_to_history_useName_fontSize'))
            .fontColor($r('app.color.list_slide_to_history_title_font_color'))
            .lineHeight($r('app.integer.list_slide_to_history_useName_line_height'))
            .fontFamily($r('app.string.list_slide_to_history_harmony_hei_ti'))
            .fontWeight(FontWeight.Medium)
          Text(this.moment.text)
            .fontSize($r('app.integer.list_slide_to_history_userText_fontSize'))
            .fontColor($r('app.color.list_slide_to_history_title_font_color'))
            .lineHeight($r('app.integer.list_slide_to_history_userText_line_height'))
            .opacity($r('app.float.list_slide_to_history_opacity'))
            .margin({ top: $r('app.integer.list_slide_to_history_userText_margin_top') })
        }
        .margin({ left: $r('app.integer.list_slide_to_history_user_col_margin_left') })
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width($r('app.string.list_slide_to_history_layout_100'))
      .constraintSize({ minHeight: $r('app.integer.list_slide_to_history_oneMoment_height') })
      .padding({
        left: $r('app.integer.list_slide_to_history_row_padding_left'),
        right: $r('app.integer.list_slide_to_history_row_padding_right'),
        top: $r('app.integer.list_slide_to_history_row_padding_top'),
        bottom: $r('app.integer.list_slide_to_history_row_padding_bottom')
      })

      Stack() {
        if (this.moment.image) {
          Column() {
            Image($r(this.moment.image))
              .id('singleImage')
              .width($r('app.integer.list_slide_to_history_single_image_width'))
              .height($r('app.integer.list_slide_to_history_single_image_height'))
              .borderRadius($r('app.integer.list_slide_to_history_single_image_radius'))
          }
          .alignItems(HorizontalAlign.Start)
          .width($r('app.string.list_slide_to_history_layout_100'))
          .padding({
            left: $r('app.integer.list_slide_to_history_image_group_padding_left'),
            right: $r('app.integer.list_slide_to_history_image_group_padding_right')
          })
        }
      }

      Row() {
        ImageText({
          imageStr: $r("app.media.list_slide_to_history_ic_share"),
          text: $r('app.string.list_slide_to_history_share')
        })
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.list_slide_to_history_other_function'),
            });
          })
        ImageText({
          imageStr: $r("app.media.list_slide_to_history_ic_thumbsup"),
          text: $r('app.string.list_slide_to_history_thumbs_up')
        })
          .margin({ left: $r('app.integer.list_slide_to_history_thumbsup_margin_left') })
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.list_slide_to_history_other_function'),
            });
          })
        ImageText({
          imageStr: $r("app.media.list_slide_to_history_ic_message"),
          text: $r('app.string.list_slide_to_history_message')
        })
          .margin({ left: $r('app.integer.list_slide_to_history_message_margin_left') })
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.list_slide_to_history_other_function'),
            });
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width($r('app.string.list_slide_to_history_layout_100'))
      .margin({
        top: $r('app.integer.list_slide_to_history_handler_margin_top'),
        bottom: $r('app.integer.list_slide_to_history_handler_margin_bottom')
      })
      .padding({
        left: $r('app.integer.list_slide_to_history_handler_padding_left'),
        right: $r('app.integer.list_slide_to_history_handler_padding_right')
      })
    }
    .width($r('app.string.list_slide_to_history_layout_100'))
  }
}
