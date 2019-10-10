//
//  HourlyDarkSkyApi.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import ObjectMapper

struct HourlyDarkSkyApi: Decodable, Mappable {
    var hourly: Hourly?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        hourly <- map["hourly"]
    }
}

struct Hourly: Decodable, Mappable {

    var data: [HourlyData]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}

struct HourlyData: Decodable, Mappable {

    var time: Int?
    var icon: String?
    var temperature: Double?
    var apparentTemperature: Double?
    var precipProbability: Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        time <- map["time"]
        icon <- map["icon"]
        temperature <- map["temperature"]
        apparentTemperature <- map["apparentTemperature"]
        precipProbability <- map["precipProbability"]
    }
}
