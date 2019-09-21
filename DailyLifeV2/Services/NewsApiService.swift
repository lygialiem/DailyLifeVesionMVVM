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

class NewsApiService{
  
  static var instance = NewsApiService()
  
  let BASE_URL_NEWSAPI = "https://newsapi.org/v2/everything?q="
  let BASE_URL_SearchNEWSAPI = "https://newsapi.org/v2/everything?qInTitle="
  let API_KEY_NEWSAPI = "3d152c6733e14015b46c1418d7567434"
  
  var TOPIC_NEWSAPI = ["General", "Entertainment", "Health", "Science", "Sports", "Technology", "Business","World", "Style", "Arts", "Travel", "Food", "Politics", "Opinion"]
  
  func getArticles(topic: String, page: Int, numberOfArticles: Int, completion: @escaping (NewsApi) -> Void){
    let totalUrl =  "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=\(numberOfArticles)&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&page=\(page)&sources=ars-technica,ary-news,time,bbc-news,espn,financial-post,bloomberg,business-insider,cbc-news,cbs-news,daily-mail,entertainment-weekly,fox-news,mtv-news,national-geographic,new-york-magazine,the-new-york-times,the-verge"
    
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
    
    let totalUrl =  "\(BASE_URL_SearchNEWSAPI)\(topic)&language=en&pageSize=\(numberOfArticles)&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&page=\(page)"
    
    Alamofire.request(totalUrl).validate().responseJSON { (response) in
      if response.result.error == nil{
        guard let data = response.data else { return }
        do{
          let jsonDecode = try JSONDecoder().decode(NewsApi.self, from: data)
          completion(jsonDecode)
        }catch let jsonError{
          debugPrint(jsonError.localizedDescription)
        }
      }else{
        debugPrint(response.result.error?.localizedDescription ?? "Error")
      }
    }
    
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


//  func getArticles(topic: String, page: Int, numberOfArticles: Int, completion: @escaping (NewsApi) -> Void){
//
//    let totalUrl =  "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=\(numberOfArticles)&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&page=\(page)&sources=ars-technica,ary-news,time,bbc-news,espn,financial-post,bloomberg,business-insider,cbc-news,cbs-news,daily-mail,entertainment-weekly,fox-news,mtv-news,national-geographic,new-york-magazine,the-new-york-times,the-verge"
//
//    guard let url = URL(string: totalUrl) else {return}
//    URLSession.shared.dataTask(with: url) {(dataApi, response, error) in
//      guard let data = dataApi else {return}
//      do{
//        let dataDecode = try JSONDecoder().decode(NewsApi.self, from: data)
//        completion(dataDecode)
//      } catch let jsonError{
//        debugPrint("API Key for NewsApi is Out Of Date: ",jsonError)
//      }
//      }.resume()
//  }
