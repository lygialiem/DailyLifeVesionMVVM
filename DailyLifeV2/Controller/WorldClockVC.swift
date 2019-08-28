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
  @IBOutlet var addButton: UIBarButtonItem!
  
  let feedback = UINotificationFeedbackGenerator()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    stringArray = getUserDefault()
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    myTableView.dataSource = self
    myTableView.delegate = self
    navigationItem.leftBarButtonItem = editButtonItem
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleMoveTabbar), name: NSNotification.Name("MoveToTabbarIndex0"), object: nil)
  }
  
  @objc func handleMoveTabbar(){
    self.tabBarController?.selectedIndex = 0
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(!isEditing, animated: true)
    
    myTableView.setEditing(!myTableView.isEditing, animated: true)
    
    if editing{
      let deleteAllButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(handleDeleteAllButton))
      navigationItem.rightBarButtonItems = [deleteAllButton]
    } else {
      navigationItem.rightBarButtonItems = [addButton]
    }
  }
  
  
  
  @IBAction func AddMoreCityButton(_ sender: Any) {
    
  }
  
  
  @objc func handleDeleteAllButton(){
    self.feedback.notificationOccurred(.success)
    self.stringArray = []
    self.setUserDefault()
    self.myTableView.reloadData()
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
      let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as! WorldClockCell
    switch indexPath.section{
    case 0:
      cell.idTimezone = "GMT"
      return cell
      
    case 1:
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
    if indexPath.section == 1{
    return 70
    }else {
      return 70
    }
  }
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    
    let temp1 = stringArray[sourceIndexPath.row]
    let temp2 = stringArray[destinationIndexPath.row]
    
    stringArray[sourceIndexPath.row] = temp2
    stringArray[destinationIndexPath.row] = temp1
    
    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    setUserDefault()
  }
}

extension WorldClockVC: WordClockDidSelect{
  func addWorldClock(timezone: String) {
    self.stringArray.append(timezone)
    self.setUserDefault()
    myTableView.insertRows(at: [
      NSIndexPath(row: stringArray.count - 1, section: 1) as IndexPath], with: .automatic)
  }
}



