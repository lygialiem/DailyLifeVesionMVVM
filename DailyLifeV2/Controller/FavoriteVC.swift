//
//  FavoriteVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController {
  
  @IBOutlet var myTableView: UITableView!
  var articlesCoreData = [FavoriteArtilce]()
  @IBOutlet var swiftLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.swiftLabel.stopBlink()
    self.swiftLabel.startBlink()
    CoreDataServices.instance.fetchCoreData { (favoriteArticlesCD) in
      self.articlesCoreData = favoriteArticlesCD.reversed()
      
      if favoriteArticlesCD == []{
        self.myTableView.isHidden = true
      } else {
        self.myTableView.isHidden = false
      }
      self.myTableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    myTableView.delegate = self
    myTableView.dataSource = self
    self.swiftLabel.startBlink()
    myTableView.isHidden = false
    
  }
  
  func removeItemAtIndexPathCoreData(atIndexPath indexPath: IndexPath){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.delete(self.articlesCoreData[indexPath.row])
    do {
      try managedContext.save()
    }catch {
      debugPrint("Could not remove: \(error.localizedDescription)")
    }
  }
  
  @IBAction func deleteAllButtonByPressed(_ sender: Any) {
    self.myTableView.isHidden = true
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    CoreDataServices.instance.fetchCoreData { (favoriteArticlesCD) in
      for i in 0..<favoriteArticlesCD.count{
        managedContext.delete(favoriteArticlesCD[i])
      }
      do{
        try managedContext.save()
        self.articlesCoreData = []
        self.myTableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
      } catch {
        print("Cannot Save")
      }
    }
  }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return articlesCoreData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
    
    cell.configureCell(article: articlesCoreData[indexPath.row])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 102
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {(rowAction, indexPath) in
      self.removeItemAtIndexPathCoreData(atIndexPath: indexPath)
      self.articlesCoreData.remove(at: indexPath.row)
      
      if self.articlesCoreData == []{
        self.myTableView.isHidden = true
      } else {
        self.myTableView.isHidden = false
      }
      
      tableView.deleteRows(at: [indexPath], with: .bottom)
      NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
    }
    
    let shareAction = UITableViewRowAction(style: .default, title: "Share") { (rowAction, indexPath) in
      let share = UIActivityViewController(activityItems: [self.articlesCoreData[indexPath.row].urlCD!], applicationActivities: nil)
      self.present(share, animated: true, completion: nil)
    }
    shareAction.backgroundColor = #colorLiteral(red: 0.1203624085, green: 0.8030965108, blue: 0.7143992782, alpha: 1)
    return [deleteAction, shareAction]
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Articles"
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let readingFavoriteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadingFavoriteArticle") as! ReadingFavoriteArticle
    
    readingFavoriteVC.articles = self.articlesCoreData
    readingFavoriteVC.indexPathOfDidSelectedArticle = indexPath
    readingFavoriteVC.view.layoutIfNeeded()
    readingFavoriteVC.myCollectionView.reloadData()
    
    navigationController?.pushViewController(readingFavoriteVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let temp1 = articlesCoreData[sourceIndexPath.row]
    let temp2 = articlesCoreData[destinationIndexPath.row]
    
    articlesCoreData[sourceIndexPath.row] = temp2
    articlesCoreData[destinationIndexPath.row] = temp1
    
    tableView.reloadData()
    
    
    CoreDataServices.instance.fetchCoreData { (coreData) in
      
    }
    
    
    
    
  }
}

