//
//  FavoriteArticleRealmModel.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 9/21/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteArticleRealmModel: Object{
  @objc dynamic var author = ""
  @objc dynamic var content = ""
  @objc dynamic var descriptions = ""
  @objc dynamic var publishedAt = ""
  @objc dynamic var title = ""
  @objc dynamic var url = ""
  @objc dynamic var urlToImage = ""
 
}
