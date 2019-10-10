//
//  RealmLibrary.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 9/21/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import RealmSwift

class LibraryRealm {
  static var instance = LibraryRealm()
  let realm = try! Realm()
  private init() {
  }
}
