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

import { TripDataType } from './DataType';

// 模拟行程数据
export const TRIP_DATA: Array<TripDataType> = [
  {
    id: 0,
    trainNumber: "K101",
    wholeCourse: "全程2h8m/100km",
    startingTime: "8:46",
    endingTime: "9:36",
    timeDifference: "距出发 50m",
    origin: "北京",
    destination: "",
    ticketEntrance: "候车地点:第七候车室",
    vehicleModel: "普快"
  },
  {
    id: 1,
    trainNumber: "G101",
    wholeCourse: "全程2h8m/100km",
    startingTime: "9:26",
    endingTime: "13:36",
    timeDifference: "距出发 14h50m",
    origin: "北京",
    destination: "洛阳",
    ticketEntrance: "检票口15A",
    vehicleModel: "高铁"
  }
]