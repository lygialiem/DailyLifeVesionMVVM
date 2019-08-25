//
//  CoreData.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import CoreData


class CoreDataServices{
  static let instance =  CoreDataServices()
  
  func fetchCoreData(completion: ([FavoriteArtilce])-> Void){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<FavoriteArtilce>(entityName: "FavoriteArtilce")
    do {
      let ArticlesCD = try managedContext.fetch(fetchRequest)
      completion(ArticlesCD)
    } catch let error as NSError {
      print("Could Not Fetch: \(error), \(error.userInfo)")
    }
  }
  
  func fetchCoreDateCountryName(completion: @escaping ([CountrySearching]) -> Void){
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let manager = delegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<CountrySearching>(entityName: "CountrySearching")
    do{
      let countryNameCD = try manager.fetch(fetchRequest)
      completion(countryNameCD)
    }catch let error as NSError{
       print("Could Not Fetch: \(error), \(error.userInfo)")
    }
  }
}
