export class TabDataModel {
  id: number = 0
  navData: string | undefined = undefined

  constructor(id: number, navData: string | undefined) {
    this.id = id
    this.navData = navData
  }
}

export const TAB_DATA: Array<TabDataModel> = [
  new TabDataModel(0, '全部'),
  new TabDataModel(1, 'UI布局'),
  new TabDataModel(2, '动效'),
  new TabDataModel(3, '三方库'),
  new TabDataModel(4, 'Native'),
  new TabDataModel(5, '其他')
]