import { util } from '@kit.ArkTS'

@Observed
export class ToDo {
  key: string = util.generateRandomUUID(true)
  name: string
  isFinished: boolean = false

  constructor(name: string) {
    this.name = name
  }
}