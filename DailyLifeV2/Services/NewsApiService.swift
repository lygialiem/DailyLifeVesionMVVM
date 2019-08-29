//
//  ApiServices.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

//Linh: 3d152c6733e14015b46c1418d7567434
//Lam: d5b74e34a5d84c6e975e1cfe78f4803d
//Long: 2173e6f5b41e4cb7b3892eb3ace459c5
//Liem: 8eb6b45740c148be81d311edae1ffd0a
import Foundation

class NewsApiService{
  static let instance = NewsApiService()
  
  
  
  let BASE_URL_NEWSAPI = "https://newsapi.org/v2/everything?q="
  let API_KEY_NEWSAPI = "7865a5d49d1d40e79fe06e8b407ca8a8"
  
  
  var TOPIC_NEWSAPI = ["General", "Entertainment", "Health", "Science", "Sports", "Technology", "Business","World", "Style", "Arts", "Travel", "Food", "Politics", "Opinion"]
  
  func getMoreNewsApi(topic: String, page: Int, numberOfArticles: Int, completion: @escaping (NewsApi) -> Void){
    
    let totalUrl =  "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=\(numberOfArticles)&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&page=\(page)&domains=cnn.com,nytimes.com,vice.com,foxnews.com,news.google.com,espn.com"
    guard let url = URL(string: totalUrl) else {return}
    URLSession.shared.dataTask(with: url) {(dataApi, response, error) in
      guard let data = dataApi else {return}
      do{
        let dataDecode = try JSONDecoder().decode(NewsApi.self, from: data)
        completion(dataDecode)
      } catch let jsonError{
        debugPrint("API Key for NewsApi is Out Of Date: ",jsonError)
      }
      }.resume()
  }
  
  func getConcernrdNewsApi(topic: String, page: Int, numberOfArticles: Int, completion: @escaping (NewsApi) -> Void){
    
    let totalUrl = "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=\(numberOfArticles)&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&page=\(page)&domains=cnn.com,nytimes.com,vice.com,foxnews.com,news.google.com,espn.com"
    
    guard let url = URL(string: totalUrl) else {return}
    URLSession.shared.dataTask(with: url) {(dataApi, response, error) in
      guard let data = dataApi else {return}
      do{
        let dataDecode = try JSONDecoder().decode(NewsApi.self, from: data)
        completion(dataDecode)
      } catch let jsonError{
        debugPrint("API Key for NewsApi is Out Of Date: ",jsonError)
      }
      }.resume()
  }
  
}
