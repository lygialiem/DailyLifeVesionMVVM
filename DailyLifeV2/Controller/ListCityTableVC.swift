//
//  ListCityTableVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class ListCityTableVC: UITableViewController{
  
  var citys = [Character: [String]]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  self.tableView.dataSource = nil
  setupListCities()

  }
  
  
  func  setupListCities(){
    let cityName = TimeZone.knownTimeZoneIdentifiers
    
    let alphabelt: [Character] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
//    var sections: [Character: [String]] = ["a": [String](), "b": [String]()]
    
    for character in alphabelt{
      var arrayCountry = [String]()
      for i in 0..<cityName.count{
        if character.uppercased() == cityName[i].first?.uppercased(){
          arrayCountry.append(cityName[i])
        }
      }
      citys[character] = arrayCountry
    }
    
    print(citys.count)
    
    
    
    
    
    self.tableView.dataSource = self
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
  }
}
