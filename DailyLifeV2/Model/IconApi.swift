//
//  forecastJson.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/23/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import ObjectMapper

struct IconApi: Decodable, Mappable {

  var code: Int?
  var day: String?
  var night: String?
  var icon: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        day <- map["day"]
        night <- map["night"]
        icon <- map["icon"]
    }
}
