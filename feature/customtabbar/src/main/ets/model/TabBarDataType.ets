export class TabBarDataType {
  id:number;
  title:ResourceStr;
  selectedIcon: ResourceStr;
  defaultIcon: ResourceStr;

  constructor(id: number, title: ResourceStr, selectedIcon: ResourceStr, defaultIcon: ResourceStr) {
    this.id = id;
    this.title = title;
    this.selectedIcon = selectedIcon;
    this.defaultIcon = defaultIcon;
  }
}