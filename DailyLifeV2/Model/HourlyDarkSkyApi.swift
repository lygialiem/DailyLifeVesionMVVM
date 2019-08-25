//
//  HourlyDarkSkyApi.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation

struct HourlyDarkSkyApi: Decodable{
  var hourly: Hourly?
}

struct Hourly: Decodable{
  var data:  [HourlyData?]?
}

struct  HourlyData: Decodable {
  var time: Int?
  var icon: String?
  var temperature: Double?
  var apparentTemperature: Double?
  var precipProbability: Double?
  
}
