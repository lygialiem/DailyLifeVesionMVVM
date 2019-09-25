//
//  WeatherAPI.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/20/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import ObjectMapper

struct DarkSkyApi: Decodable, Mappable{
    var currently: Currently?
    var latitude: Double?
    var longitude: Double?
    var daily: Daily?
    
    init?(map: Map) {
         
     }
     mutating func mapping(map: Map) {
         currently <- map["currently"]
         latitude <- map["latitude"]
         longitude <- map["longitude"]
         daily <- map["daily"]
     }
}

struct Daily: Decodable, Mappable{
 
    var summary: String?
    var icon: String?
    var data: [Data]?
    
    init?(map: Map) {
         
     }
     
     mutating func mapping(map: Map) {
         summary <- map["summary"]
         icon <- map["icon"]
         data <- map["data"]
     }
     
}

struct Data: Decodable, Mappable{
    
    var time: Int?
    var temperatureMax: Double?
    var temperatureMin: Double?
    var icon: String?
    var precipProbability: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        time <- map["time"]
        temperatureMax <- map["temperatureMax"]
        temperatureMin <- map["temperatureMin"]
        icon <- map["icon"]
        precipProbability <- map["precipProbability"]
        
    }
}

struct Currently: Decodable, Mappable {
    
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
    var windGust: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        precipType <- map["precipType"]
        summary <- map["summary"]
        icon <- map["icon"]
        nearestStormDistance <- map["nearestStormDistance"]
        precipProbability <- map["precipProbability"]
        precipIntensity <- map["precipIntensity"]
        time <- map["time"]
        dewPoint <- map["dewPoint"]
        windBearing <- map["windBearing"]
        uvIndex <- map["uvIndex"]
        ozone <- map["ozone"]
        humidity <- map["humidity"]
        pressure <- map["pressure"]
        windSpeed <- map["windSpeed"]
        cloudCover <- map["cloudCover"]
        visibility <- map["visibility"]
        temperature <- map["temperature"]
        apparentTemperature <- map["apparentTemperature"]
        windGust <- map["windGust"]
        
    }
    
    
}



