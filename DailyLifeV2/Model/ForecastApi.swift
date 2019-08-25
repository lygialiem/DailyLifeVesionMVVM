//
//  ForecastApi.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation


struct ForecastApi: Decodable{
  var location: Location?
  var current: Current?
  var forecast: Forecast?
  var error: Error?
}

struct Error: Decodable{
  var code: Int?
  var message: String?
}

struct Location: Decodable{
  var name: String?
  var region : String?
  var country: String?
  var lat: Double?
  var lon: Double?
  var localtime_epoch: Int?
}

struct Current: Decodable{
  var last_updated_epoch: Int?
  var temp_c: Double?
  var condition: Condition?
  var wind_kph: Double?
  var wind_degree: Double?
  var wind_dir: String?
  var pressure_mb: Double?
  var pressure_in: Double?
  var precip_mm: Double?
  var precip_in: Double?
  var humidity: Double?
  var cloud: Double?
  var feelslike_c: Double?
  var vis_km: Double?
  var uv: Double?
  var gust_mph: Double?
  var gust_kph: Double?
}

struct Condition: Decodable{
  var text: String?
  var icon: String?
  var code: Int?
}

struct Forecast: Decodable{
  var forecastday: [Forecastday?]?
}

struct Forecastday: Decodable{
  var date: String?
  var date_epoch: TimeInterval?
  var day: Day?
  var astro: Astro?
}

struct Astro: Decodable{
  var sunrise: String?
  var sunset: String?
  var moonrise: String?
  var moonset: String?
}

struct Day: Decodable{
  var maxtemp_c: Double?
  var mintemp_c: Double?
  var avgtemp_c: Double?
  var totalprecip_mm: Double?
  var maxwind_kph: Double?
  var avgvis_km: Double?
  var condition: ConditionDay?
  var uv: Double?
}

struct ConditionDay: Decodable{
  var text: String?
  var icon: String?
  var code: Int?
}


