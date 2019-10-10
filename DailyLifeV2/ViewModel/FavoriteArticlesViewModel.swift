//
//  FavoriteArticlesViewModel.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 9/10/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import UIKit

class FavoriteArticlesViewModel {

  var result: (([Article]) -> Void)?

  var data = [Article]() {
    didSet {
      result?(data)
    }
  }

  var count: Int {
    return data.count
  }

  func setup() {
    LibraryCoreData.instance.fetchCoreData { (data) in
      self.data = Array(repeating: Article(), count: data.count)
      self.configureDataFromCoreDataToStructData(data: data)
    }
  }

  func configureDataFromCoreDataToStructData(data: [FavoriteArtilce]) {
    for i in 0..<data.count {
      self.data[i].title = data[data.count - 1 - i].titleCD
      self.data[i].author = data[data.count - 1 - i].authorCD
      self.data[i].content = data[data.count - 1 - i].contentCD
      self.data[i].description = data[data.count - 1 - i].descriptionCD
      self.data[i].publishedAt = data[data.count - 1 - i].publishedAtCD
      self.data[i].url = data[data.count - 1 - i].urlCD
      self.data[i].urlToImage = data[data.count - 1 - i].urlToImageCD
    }
  }
}
