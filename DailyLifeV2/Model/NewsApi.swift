//
//  NewsApi.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation

struct NewsApi: Decodable, Hashable{
  var status: String?
  var totalResults: Int?
  var articles: [Article]
  var code: String?
  var message: String?
}

struct Article: Decodable, Hashable{
  var source: Source?
  var author: String?
  var title: String?
  var description: String?
  var url: String?
  var urlToImage: String?
  var publishedAt: String?
  var content: String?
//  
//  init(author: String, title: String, content: String, publishedAt: String, description: String, url: String, urlToImage: String){
//    self.author = author
//    self.title = title
//    self.content = content
//    self.publishedAt = publishedAt
//    self.description = description
//    self.urlToImage = urlToImage
//    self.url = url
//  }
}

struct Source: Decodable, Hashable{
  var id: String?
  var name: String?
}
