//
//  LibraryAPI.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 9/18/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import UIKit

class LibraryAPI {
  static var instance = LibraryAPI()

  let newsApiService = NewsApiService()
  let weatherApiService = WeatherApiService()

  var TOPIC_NEWSAPI = ["General", "Entertainment", "Health", "Science", "Sports", "Technology", "Business", "World", "Style", "Arts", "Travel", "Food", "Politics", "Opinion"]

  private init() {}
}

// MARK: - Articles Library API:
extension LibraryAPI {
  func getArticles(topic: String, page: Int, numberOfArticles: Int, completion: @escaping (NewsApi) -> Void) {

    newsApiService.getArticles(topic: topic, page: page, numberOfArticles: numberOfArticles, completion: completion)
  }

  func getSearchArticle(topic: String, page: Int, numberOfArticles: Int, completion: @escaping (NewsApi) -> Void) {

    newsApiService.getSearchArticles(topic: topic, page: page, numberOfArticles: numberOfArticles, completion: completion)
  }
}

// MARK: - Weather Forecast Library API:
extension LibraryAPI {
  func getForecast(latitude: Double, longitude: Double, completion: @escaping (DarkSkyApi) -> Void) {

    weatherApiService.getWeatherApi(latitude: latitude, longitude: longitude, completion: completion)
  }
  func getCountryForecast(nameOfCountry: String, completion: @escaping (ForecastApi) -> Void) {
    weatherApiService.getCountryForecastApi(nameOfCountry: nameOfCountry, completion: completion)
  }

  func getHourlyForecast(latitude: Double, longitude: Double, completion: @escaping (HourlyDarkSkyApi) -> Void) {

    weatherApiService.getHourlyDarkSkyApi(latitude: latitude, longitude: longitude, completion: completion)
  }

  func getIcon(completion: @escaping ([IconApi]) -> Void) {
    weatherApiService.getIconJson(completion: completion)
  }
}
