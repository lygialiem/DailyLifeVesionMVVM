//
//  WeatherAPI.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/20/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation

struct CurrentlyDarkSkyApi: Decodable{
  var currently: Currently?
  var latitude: Double?
  var longitude: Double?
}

struct Currently: Decodable {
  var precipType: String?
  var summary: String?
  var icon: String?
  var nearestStormDistance: Double?
  var precipIntensity: Double?
  var precipProbability: Double?
  var time: Int?
  var dewPoint: Double?
  var windBearing: Double?
  var uvIndex: Double?
  var ozone: Double?
  var humidity: Double?
  var pressure: Double?
  var windSpeed: Double?
  var cloudCover: Double?
  var visibility: Double?
  var temperature: Double?
  var apparentTemperature: Double?
}



