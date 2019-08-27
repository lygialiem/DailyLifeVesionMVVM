//
//  WorldClockVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class WorldClockVC: UIViewController {
  
  var stringArray = [String]()
  @IBOutlet var editButton: UIBarButtonItem!
  @IBOutlet var myTableView: UITableView!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  stringArray = getUserDefault()
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    myTableView.dataSource = self
    myTableView.delegate = self
    navigationItem.leftBarButtonItem = editButtonItem
    
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(!isEditing, animated: true)
    
    myTableView.setEditing(!myTableView.isEditing, animated: true)
  }
  
  
  
  @IBAction func AddMoreCityButton(_ sender: Any) {
    
  }
  
  @IBAction func editButton(_ sender: Any) {
    if myTableView.isEditing{
      myTableView.setEditing(false, animated: true)
      navigationItem.leftBarButtonItem?.title = "Done"
      
    } else {
      myTableView.setEditing(true, animated: true)
      navigationItem.leftBarButtonItem?.title = "Edit"
    }
  }
  
  func setUserDefault(){
    UserDefaults.standard.set(stringArray, forKey: "WorldClock")
    UserDefaults.standard.synchronize()
  }
  
  func getUserDefault() -> [String]{
    guard let userDefault = UserDefaults.standard.value(forKey: "WorldClock") as? [String] else {return [String]()}
    return userDefault
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "listCities"{
      guard let vc = segue.destination as? ListCityTableVC else {return}
      vc.delegate = self
    }
  }
}



extension WorldClockVC: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section{
    case 0: return 1
    case 1: return stringArray.count
    default: return 0
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section{
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "GTMCell") as! GTMCell
      return cell
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! WorldClockCell
      cell.idTimezone = stringArray[indexPath.row]
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    switch indexPath.section {
    case 0:
      return false
    default:
      return true
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete{
      stringArray.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      setUserDefault()
    }
  }
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    
    switch indexPath.section{
    case 1:
      return true
    default:
      return false
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 50
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
  tableView.beginUpdates()
    let temp1 = stringArray[sourceIndexPath.row]
    let temp2 = stringArray[destinationIndexPath.row]
    
    stringArray[sourceIndexPath.row] = temp2
    stringArray[destinationIndexPath.row] = temp1
  
    tableView.reloadRows(at: [sourceIndexPath,destinationIndexPath], with: .none)
    tableView.endUpdates()
    setUserDefault()
  }
  
  
}

extension WorldClockVC: WordClockDidSelect{
  func addWorldClock(timezone: String) {
    self.stringArray.append(timezone)
    self.setUserDefault()
    self.myTableView.reloadData()
  }
}



