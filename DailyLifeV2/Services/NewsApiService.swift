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
//Liem: c3aa57a429a6432a9485160edf25e526
import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class NewsApiService{
  
  static var instance = NewsApiService()
  
  var TOPIC_NEWSAPI = ["General", "Entertainment", "Health", "Science", "Sports", "Technology", "Business","World", "Style", "Arts", "Travel", "Food", "Politics", "Opinion"]
  
  func getArticles(topic: String, page: Int, numberOfArticles: Int, completion: @escaping (NewsApi) -> Void){
    let totalUrl =  "\(URL_API.NewsAPI.keyAndPath.path)\(topic)&language=en&pageSize=\(numberOfArticles)&apiKey=\(URL_API.NewsAPI.keyAndPath.key)&sortBy=publishedAt&page=\(page)&sources=ars-technica,ary-news,time,bbc-news,espn,financial-post,bloomberg,business-insider,cbc-news,cbs-news,daily-mail,entertainment-weekly,fox-news,mtv-news,national-geographic,new-york-magazine,the-new-york-times,the-verge"
    
    Alamofire.request(totalUrl).validate().responseJSON { (response) in
      if response.result.error == nil{
        guard let data = response.data else {return}
        do {
          let dataDecode = try JSONDecoder().decode(NewsApi.self, from: data)
          completion(dataDecode)
        }catch let jsonDecodeError{
          debugPrint(jsonDecodeError.localizedDescription)
        }
      } else {
        debugPrint(response.result.error?.localizedDescription ?? "")
      }
    }
  }
 
  func getSearchArticles(topic: String, page: Int, numberOfArticles: Int, completion: @escaping (NewsApi) -> Void){
    
    let totalUrl =  "\(URL_API.SearchNewsAPI.keyAndPath.path)\(topic)&language=en&pageSize=\(numberOfArticles)&apiKey=\(URL_API.SearchNewsAPI.keyAndPath.key)&sortBy=publishedAt&page=\(page)"
    
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
