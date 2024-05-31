// 尺寸信息
export class Size {
  height: number;
  width: number;

  constructor(height: number, width: number) {
    this.height = height;
    this.width = width;
  }
}

export class IconAndDescription {
  icon: Resource;
  description: string | Resource;

  constructor(icon: Resource, description: string | Resource) {
    this.icon = icon;
    this.description = description
  }
}