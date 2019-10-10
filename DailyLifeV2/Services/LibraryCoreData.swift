//
//  LibraryCoreData.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 9/18/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import UIKit

class LibraryCoreData {
  static let instance = LibraryCoreData()
  var coreDataServices = CoreDataServices()
  private init() {}

  func fetchCoreData(completion: @escaping ([FavoriteArtilce]) -> Void) {
    coreDataServices.fetchCoreData(completion: completion)
  }

  func fetchCoreDataCountryName(completion: @escaping ([CountrySearching]) -> Void) {
    coreDataServices.fetchCoreDateCountryName(completion: completion)
  }
}
