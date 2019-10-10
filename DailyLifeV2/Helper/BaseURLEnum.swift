//
//  BaseURLEnum.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 10/1/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation

protocol EndPoint {
    var keyAndPath: (path: String, key: String) { get }
}

enum URL_API {
    case NewsAPI
    case SearchNewsAPI
    case DarkSkyAPI
    case ApixuAPI
}

extension URL_API: EndPoint {
    var keyAndPath: (path: String, key: String) {
        switch self {
        case .NewsAPI:
            return (path: "https://newsapi.org/v2/everything?q=", key: "3d152c6733e14015b46c1418d7567434" )
        case .SearchNewsAPI:
            return (path: "https://newsapi.org/v2/everything?qInTitle=", key:  "3d152c6733e14015b46c1418d7567434")
        case .DarkSkyAPI:
            return (path: "https://api.darksky.net/forecast/", key: "060b23f6abfddd1f77ad14c3968b71db")
        case .ApixuAPI:
            return (path: "http://api.apixu.com/v1/forecast", key: "0aa988689a294ad988852842190809")
        }
    }
}
