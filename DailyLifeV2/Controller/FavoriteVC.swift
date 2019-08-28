//
//  FavoriteVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController {
  
  @IBOutlet var deleteAllButton: UIBarButtonItem!
  @IBOutlet var myTableView: UITableView!
  var articlesCoreData = [Article]()
  @IBOutlet var swiftLabel: UILabel!
  
  let feedback = UINotificationFeedbackGenerator()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.swiftLabel.stopBlink()
    self.swiftLabel.startBlink()
    CoreDataServices.instance.fetchCoreData { (favoriteArticlesCD) in
    
      articlesCoreData = Array(repeating: Article(), count: favoriteArticlesCD.count)
      for i in 0..<favoriteArticlesCD.count{
        articlesCoreData[i].title = favoriteArticlesCD[i].titleCD
        articlesCoreData[i].author = favoriteArticlesCD[i].authorCD
        articlesCoreData[i].content = favoriteArticlesCD[i].contentCD
        articlesCoreData[i].description = favoriteArticlesCD[i].descriptionCD
        articlesCoreData[i].publishedAt = favoriteArticlesCD[i].publishedAtCD
        articlesCoreData[i].url = favoriteArticlesCD[i].urlCD
        articlesCoreData[i].urlToImage = favoriteArticlesCD[i].urlToImageCD
      }
      self.myTableView.reloadData()
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
    self.deleteAllButton.isEnabled = false
    self.swiftLabel.startBlink()
    myTableView.isHidden = false
    navigationController?.title = "Liked Contents"
    navigationItem.leftBarButtonItem = editButtonItem
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleMoveTabbar), name: NSNotification.Name("MoveToTabbarIndex0"), object: nil)
  }
  
  @objc func handleMoveTabbar(){
    self.tabBarController?.selectedIndex = 0
  }
  
  func removeItemAtIndexPathCoreData(atIndexPath indexPath: IndexPath, element: [FavoriteArtilce]){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.delete(element[indexPath.row])
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
      self.feedback.notificationOccurred(.success)
      do{
        try managedContext.save()
       
        self.myTableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
      } catch {
        print("Cannot Save")
      }
    }
  }
  
  
  @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
 
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(!isEditing, animated: true)
    myTableView.setEditing(!myTableView.isEditing, animated: true)
    
    if myTableView.isEditing{
         self.deleteAllButton.isEnabled = true
    } else {
      self.deleteAllButton.isEnabled = false
    }
    
    
  }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
  
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
      
      CoreDataServices.instance.fetchCoreData(completion: { (coreDatas) in

        self.removeItemAtIndexPathCoreData(atIndexPath: indexPath, element: coreDatas)
        self.articlesCoreData.remove(at: indexPath.row)
        
        if self.articlesCoreData.isEmpty{
          self.myTableView.isHidden = true
        } else {
          self.myTableView.isHidden = false
        }
      })
    
      tableView.deleteRows(at: [indexPath], with: .bottom)
      self.feedback.notificationOccurred(.success)
      NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
    }
    
    let shareAction = UITableViewRowAction(style: .default, title: "Share") { (rowAction, indexPath) in
      let share = UIActivityViewController(activityItems: [self.articlesCoreData[indexPath.row].url ?? ""], applicationActivities: nil)
      self.present(share, animated: true, completion: nil)
    }
    shareAction.backgroundColor = #colorLiteral(red: 1, green: 0.765712738, blue: 0.0435429886, alpha: 1)
    return [deleteAction, shareAction]
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let readingFavoriteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadingFavoriteArticle") as! ReadingFavoriteArticle
    
    readingFavoriteVC.articles = articlesCoreData
    readingFavoriteVC.indexPathOfDidSelectedArticle = indexPath
    readingFavoriteVC.view.layoutIfNeeded()
    readingFavoriteVC.myCollectionView.reloadData()
    
    navigationController?.pushViewController(readingFavoriteVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let managed = delegate.persistentContainer.viewContext

    let temp1 = articlesCoreData[sourceIndexPath.row]
    let temp2 = articlesCoreData[destinationIndexPath.row]

    articlesCoreData[sourceIndexPath.row] = temp2
    articlesCoreData[destinationIndexPath.row] = temp1
    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)

    for i in 0..<articlesCoreData.count{
      print("ARTICLE MOVED",articlesCoreData[i].title ?? "")
    }

    CoreDataServices.instance.fetchCoreData { (CoreDatas) in
      for i in 0..<CoreDatas.count{
        managed.delete(CoreDatas[i])
      }
      do {
        try managed.save()
      } catch {
        print("Can't save")
      }
    }

    for i in 0..<articlesCoreData.count{
      let coreData = FavoriteArtilce(context: managed)

      coreData.titleCD = articlesCoreData[i].title
      coreData.urlToImageCD = articlesCoreData[i].urlToImage
      coreData.publishedAtCD = articlesCoreData[i].publishedAt
      coreData.urlCD = articlesCoreData[i].url
      coreData.contentCD = articlesCoreData[i].content
      coreData.authorCD = articlesCoreData[i].author
      coreData.descriptionCD = articlesCoreData[i].description
      
      do{
        try managed.save()
      } catch let error{
        debugPrint("Cant save: ",error)
      }
    }
  }
}

