//
//  FavoriteTableVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit


class FavoriteTableVC: UITableViewController {
  
  var articles = [FavoriteArticle]()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
   
    CoreDataServices.instance.fetchCoreData { (favoriteArticlesCD) in
      self.articles = favoriteArticlesCD.reversed()
      self.tableView.reloadData()
      if favoriteArticlesCD == []{
        self.tableView.isHidden = true
      }else {
        self.tableView.isHidden = false
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return articles.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
    
    cell.configureCell(article: articles[indexPath.row])
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {(rowAction, indexPath) in
      self.removeItemAtIndexPathCoreData(atIndexPath: indexPath)
      CoreDataServices.instance.fetchCoreData(completion: { (favoriteArticlesCD) in
        self.articles = favoriteArticlesCD.reversed()
      })
      
      tableView.deleteRows(at: [indexPath], with: .bottom)
      NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)

    }
    return [deleteAction]
  }
  
  func removeItemAtIndexPathCoreData(atIndexPath indexPath: IndexPath){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.delete(self.articles[indexPath.row])
    do {
      try managedContext.save()
    }catch {
      debugPrint("Could not remove: \(error.localizedDescription)")
    }
  }
  
  @IBAction func deleteAllButtonByPressed(_ sender: Any) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    CoreDataServices.instance.fetchCoreData { (favoriteArticlesCD) in
      for i in 0..<favoriteArticlesCD.count{
        managedContext.delete(favoriteArticlesCD[i])
      }
      do{
        try managedContext.save()
        self.articles = []
        self.tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
      } catch {
        print("Cannot Save")
      }
    }
    self.tableView.isHidden = true
  }
  
  
}
