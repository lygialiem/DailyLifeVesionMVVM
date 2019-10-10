//
//  LocationService.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/20/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import CoreLocation
import AlamofireObjectMapper
import Alamofire

class WeatherApiService {

  let weatherTitles = ["time", "summary", "latitude", "longitude", "temperature", "humidity", "pressure", "nearest Storm Distance", "precip Intensity", "precip Type", "precip Probability", "dew point", "wind Bearing", "ozone", "cloud Cover", "visibility", "UV Index"]

  func getWeatherApi(latitude: Double, longitude: Double, completion: @escaping (DarkSkyApi) -> Void) {
    let totalUrl = URL(string: "\(URL_API.DarkSkyAPI.keyAndPath.path)\(URL_API.DarkSkyAPI.keyAndPath.key)/\(latitude),\(longitude)/?exclude=hourly,minutely,alerts,flags&units=ca")
    guard let url = totalUrl else {return}

    Alamofire.request(url).validate().responseObject { (response: DataResponse<DarkSkyApi>) in
        if response.result.error == nil {
                guard let weatherResponse = response.result.value else {return}
                completion(weatherResponse)
        } else {
            debugPrint(response.result.error!.localizedDescription)
        }
    }
  }

  func getHourlyDarkSkyApi(latitude: Double, longitude: Double, completion: @escaping (HourlyDarkSkyApi) -> Void) {
    guard let url = URL(string: "\(URL_API.DarkSkyAPI.keyAndPath.path)\(URL_API.DarkSkyAPI.keyAndPath.key)/\(latitude),\(longitude)/?exclude=daily,currently,minutely,alerts,flags&units=si") else {return}

    Alamofire.request(url).validate().responseObject {(response: DataResponse<HourlyDarkSkyApi>) in
        if response.result.error == nil {
            guard let hourlyData = response.result.value else {return}
            completion(hourlyData)
        } else {
            debugPrint(response.result.error!.localizedDescription)
        }
    }
  }

    func getCountryForecastApi(nameOfCountry: String, completion: @escaping (ForecastApi) -> Void) {
        let url = "\(URL_API.ApixuAPI.keyAndPath.path).json?key=\(URL_API.ApixuAPI.keyAndPath.key)&q=\(nameOfCountry.replacingOccurrences(of: " ", with: "%20"))&days=7"
      guard let urlRequest = URL(string: url) else {return}

      URLSession.shared.dataTask(with: urlRequest) {(data, _, error) in
        if error == nil {
          guard let data = data else {return}
          do {
            let dataDecoded = try JSONDecoder().decode(ForecastApi.self, from: data)
            completion(dataDecoded)
          } catch let jsonError {
            debugPrint("JSON ERROR: ", jsonError, "Error: ", error ?? Error())
          }
        }
        }.resume()
    }

  func getIconJson(completion: @escaping ([IconApi]) -> Void) {
    let urlRequest = URL(string: "http://www.apixu.com/doc/Apixu_weather_conditions.json")

    guard let url = urlRequest else {return}

    URLSession.shared.dataTask(with: url) { (data, _, error) in
      guard let data = data else {return}
      do {
        let dataDecoded = try JSONDecoder().decode([IconApi].self, from: data)
        completion(dataDecoded)

      } catch {
        debugPrint("ErrorCallAPi: \(String(describing: error))")
        }
      }.resume()
  }
}
