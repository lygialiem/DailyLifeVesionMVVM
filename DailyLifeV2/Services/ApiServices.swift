//
//  ApiServices.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation

class ApiServices {
  static let instance = ApiServices()

  let BASE_URL_NEWSAPI = "https://newsapi.org/v2/everything?q="
  let API_KEY_NEWSAPI = "bfc1a410e0eb4b488db084a4664e69e9"
  var TOPIC_NEWSAPI = ["World", "Politics", "Business", "Opinion", "Technology", "Science", "Arts", "Food", "Health", "Entertainment", "Style", "Travel", "Sport"]

  func getNewsApi(topic: String, completion: @escaping (NewsApi) -> Void) {
    let totalUrl = "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=20&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&page=1&domains=vice.com,abc.com,nytimes.com,espn.com"
//    vice.com,abc.com,nytimes.com
    guard let url = URL(string: totalUrl) else {return}
    URLSession.shared.dataTask(with: url) { (data, _, _) in
      guard let data = data else {return}
      do {
        let dataDecode = try JSONDecoder().decode(NewsApi.self, from: data)
        completion(dataDecode)
      } catch let jsonError {
        debugPrint(jsonError)
      }
    }.resume()
  }

  func getMoreNewsApi(topic: String, page: Int, size: Int, completion: @escaping (NewsApi) -> Void) {

    let totalUrl =  "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=\(size)&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&page=\(page)&domains=vice.com,abc.com,nytimes.com"
    guard let url = URL(string: totalUrl) else {return}
    URLSession.shared.dataTask(with: url) {(dataApi, _, _) in

      guard let data = dataApi else {return}
      do {
        let dataDecode = try JSONDecoder().decode(NewsApi.self, from: data)
        completion(dataDecode)
      } catch let jsonError {
        debugPrint("LOI: ", jsonError)
      }
    }.resume()
  }
}
