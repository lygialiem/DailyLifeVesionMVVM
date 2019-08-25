//
//  NewsApi.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation

struct NewsApi: Decodable{
  var status: String?
  var totalResults: Int?
  var articles: [Article]
  var code: String?
  var message: String?
}

struct Article: Decodable{
  var source: Source?
  var author: String?
  var title: String?
  var description: String?
  var url: String?
  var urlToImage: String?
  var publishedAt: String?
  var content: String?
}

struct Source: Decodable{
  var id: String?
  var name: String?
}