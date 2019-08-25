//
//  forecastJson.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/23/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation

struct Info: Decodable{
  var code: Int
  var day: String
  var night: String
  var icon: Int
}
