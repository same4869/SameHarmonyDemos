import { AppRouter } from '@ohos/dynamicsRouter';
import { promptAction } from '@kit.ArkUI';
import { pinyin4js } from '@ohos/pinyin4js';

const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const LIST_SPACE: number = 16;
const PINYIN_ARRAY: number = 0; // 拼音列表项在数组中的位置
const STROKE_WIDTH: number = 1;
const MAX_LINE: number = 1; // text显示的最大行数

// 列表结构对象
@Observed
class ListConstruction {
  public id: Resource; // 唯一id
  public title: Resource; // 列表标题
  public content: Resource | string; // 列表内容

  constructor(id: Resource, title: Resource, content: Resource | string) {
    this.id = id;
    this.title = title;
    this.content = content;
  }
}

@AppRouter({
  name: "chinesetopinyin/chinesetopinyin"
})
@Component
export struct chinesetopinyin {
  @State userName: string | Resource = $r('app.string.pinyin_name_content');
  // 个人信息分组
  @State userGroup: ListConstruction[] = [
    new ListConstruction($r('app.string.pinyin_id'), $r('app.string.pinyin_name_change_title'),
      $r('app.string.pinyin_name_change_content')),
    new ListConstruction($r('app.string.pinyin_sex_id'), $r('app.string.pinyin_sex_title'),
      $r('app.string.pinyin_sex_content'))
  ];
  // 证件信息分组
  @State idGroup: ListConstruction[] = [
    new ListConstruction($r('app.string.pinyin_country_id'), $r('app.string.pinyin_country_title'),
      $r('app.string.pinyin_country_content')),
    new ListConstruction($r('app.string.pinyin_type_id'), $r('app.string.pinyin_id_type_title'),
      $r('app.string.pinyin_id_type_content')),
    new ListConstruction($r('app.string.pinyin_card_id'), $r('app.string.pinyin_id_title'),
      $r('app.string.pinyin_id_content')),
    new ListConstruction($r('app.string.pinyin_validity_id'), $r('app.string.pinyin_id_validity_title'),
      $r('app.string.pinyin_id_validity_content'))
  ];

  build() {
    Column() {
      Text("个人信息修改")
        .fontSize(20)
        .fontColor("#182431")
        .fontWeight(FontWeight.Bold)
        .width("100%")
        .lineHeight(33)
        .textAlign(TextAlign.Center)
        .height(56)

      List({
        space: LIST_SPACE
      }) {
        ListItem() {
          Row() {
            Text("姓名（中文）")
              .width("30%")
              .fontColor("#99182431")
              .fontSize(16)
              .layoutWeight(LAYOUT_WEIGHT)
              .lineHeight(22)

            TextInput({
              text: this.userName
            })
              .textAlign(TextAlign.End)
              .backgroundColor("#ffffff")
              .fontSize(16)
              .layoutWeight(LAYOUT_WEIGHT)
              .selectionMenuHidden(true)
              .onChange((value: string) => {
                /** TODO: 知识点: 使用convertToPinyinString方法将汉字转换成拼音字母。
                 其中参数1为待转数据，参数2为拼音间隔字符，参数3设置是否带声调符号。
                 */
                const pinyin: string = pinyin4js.convertToPinyinString(value, '', pinyin4js.WITHOUT_TONE);
                this.userGroup[PINYIN_ARRAY].content = pinyin.toUpperCase();
              })
          }
          .height($r('app.integer.pinyin_pinyin_height'))
          .borderRadius($r('app.integer.pinyin_list_radius'))
          .backgroundColor($r('app.color.pinyin_list_background'))
          .margin({
            left: $r('app.integer.pinyin_margin_left'),
            right: $r('app.integer.pinyin_margin_right')
          })
          .padding({
            left: $r('app.integer.pinyin_padding_left'),
            right: $r('app.integer.pinyin_padding_right')
          })
        }

        ListItem() {
          ForEachItem({ dataGroup: this.userGroup })
        }
        .margin({
          left: $r('app.integer.pinyin_list_item_margin_left'),
          right: $r('app.integer.pinyin_list_item_margin_right')
        })

        ListItem() {
          ForEachItem({ dataGroup: this.idGroup })
        }
        .margin({
          left: $r('app.integer.pinyin_list_item_margin_left'),
          right: $r('app.integer.pinyin_list_item_margin_right')
        })
      }
      .width($r('app.string.pinyin_list_width'))
      .margin({ top: $r('app.integer.pinyin_list_margin_top') })

      Button($r('app.string.pinyin_button_content'))
        .width($r('app.string.pinyin_button_width'))
        .margin({ top: $r('app.integer.pinyin_button_margin_top') })
        .onClick(() => {
          promptAction.showToast({ message: $r('app.string.pinyin_only_show') });
        })
    }
    .backgroundColor("#f1f3f5")
    .height("100%")
    .width("100%")
  }
}

// 循环遍历列表
@Component
export struct ForEachItem {
  // 需要遍历的数据数组
  private dataGroup: ListConstruction[] = [];

  build() {
    Row() {
      List({
        space: LIST_SPACE
      }) {
        // TODO: 性能知识点：使用ForEach组件循环渲染数据
        ForEach(this.dataGroup, (item: ListConstruction) => {
          ListItem() {
            UserItemView({ text: item });
          }
        }, (item: ListConstruction) => JSON.stringify(item))
      }
      .divider({
        strokeWidth: STROKE_WIDTH,
        color: $r('app.color.pinyin_divider_color'),
        startMargin: $r('app.integer.pinyin_divider_start_margin'),
        endMargin: $r('app.integer.pinyin_divider_end_margin')
      })
    }
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.pinyin_list_background'))
    .borderRadius($r('app.integer.pinyin_list_radius'))
  }
}

// 列表组件
@Component
export struct UserItemView {
  // 列表项
  @ObjectLink text: ListConstruction;

  build() {
    Row() {
      Text(this.text.title)
        .fontSize($r('app.integer.pinyin_list_title_size'))
        .fontColor($r('app.color.pinyin_list_title_color'))
        .width($r('app.integer.pinyin_setting_title_width'))
        .lineHeight($r('app.integer.pinyin_list_line_height'))
      Text(this.text.content)
        .fontSize($r('app.integer.pinyin_list_content_size'))
        .layoutWeight(LAYOUT_WEIGHT)
        .fontColor($r('app.color.pinyin_list_content_color'))
        .lineHeight($r('app.integer.pinyin_list_line_height'))
        .textOverflow({
          overflow: TextOverflow.MARQUEE
        })
        .maxLines(MAX_LINE)
        .textAlign(TextAlign.End)
    }
    .width($r('app.string.pinyin_list_width'))
    .height($r('app.integer.pinyin_setting_item_height'))
    .padding({
      left: $r('app.integer.pinyin_setting_item_padding_left'),
      right: $r('app.integer.pinyin_setting_item_padding_right')
    })
    .alignItems(VerticalAlign.Center)
    .width($r('app.string.pinyin_list_width'))
    .alignSelf(ItemAlign.Center)
  }
}