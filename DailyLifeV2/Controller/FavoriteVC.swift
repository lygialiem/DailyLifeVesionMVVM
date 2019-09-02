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
  var articlesCoreData = [Article]()
  @IBOutlet var swiftLabel: UILabel!
  @IBOutlet var menuButton: UIBarButtonItem!
  
  let feedback = UINotificationFeedbackGenerator()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.swiftLabel.stopBlink()
    self.swiftLabel.startBlink()
    CoreDataServices.instance.fetchCoreData { (favoriteArticlesCD) in
      
      articlesCoreData = Array(repeating: Article(), count: favoriteArticlesCD.count)
      for i in 0..<favoriteArticlesCD.count{
      
        articlesCoreData[i].title = favoriteArticlesCD[favoriteArticlesCD.count - 1 - i].titleCD
        articlesCoreData[i].author = favoriteArticlesCD[favoriteArticlesCD.count - 1 - i].authorCD
        articlesCoreData[i].content = favoriteArticlesCD[favoriteArticlesCD.count - 1 - i].contentCD
        articlesCoreData[i].description = favoriteArticlesCD[favoriteArticlesCD.count - 1 - i].descriptionCD
        articlesCoreData[i].publishedAt = favoriteArticlesCD[favoriteArticlesCD.count - 1 - i].publishedAtCD
        articlesCoreData[i].url = favoriteArticlesCD[favoriteArticlesCD.count - 1 - i].urlCD
        articlesCoreData[i].urlToImage = favoriteArticlesCD[favoriteArticlesCD.count - 1 - i].urlToImageCD
      }
      self.myTableView.reloadData()
      if favoriteArticlesCD == []{
        self.myTableView.isHidden = true
        self.myTableView.setEditing(myTableView.isEditing, animated: true)
        navigationItem.leftBarButtonItems = [menuButton]
        self.myTableView.isEditing = false
        
      } else {
        self.myTableView.isHidden = false
        self.navigationItem.leftBarButtonItems = [menuButton,editButtonItem]
        myTableView.setEditing(isEditing, animated: true)
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
    navigationController?.title = "Liked Contents"
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleMoveTabbar), name: NSNotification.Name("MoveToTabbarIndex0"), object: nil)
    myTableView.register(UINib.init(nibName: "SmallArticleCell", bundle: nil), forCellReuseIdentifier: "SmallArticleCell")
    
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
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    myTableView.setEditing(!myTableView.isEditing, animated: true)
  
    if editing{
      let deleteAllButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(handleDeleteAllButton))
      navigationItem.rightBarButtonItems = [deleteAllButton]
    } else {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  
  @objc func handleDeleteAllButton(){
    isEditing = false
    self.myTableView.isHidden = true
    self.navigationItem.leftBarButtonItems = [menuButton]
    self.navigationItem.rightBarButtonItem = nil
 
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
  
  
  @IBAction func menuButtonPressed(_ sender: Any) {
    
    NotificationCenter.default.post(name: NSNotification.Name("OpenOrCloseSideMenu"), object: nil)
  }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return articlesCoreData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "SmallArticleCell", for: indexPath) as! SmallArticleCell
    
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
        
        self.removeItemAtIndexPathCoreData(atIndexPath: indexPath, element: coreDatas.reversed())
        self.articlesCoreData.remove(at: indexPath.row)
        
        if self.articlesCoreData.isEmpty{
          self.myTableView.isHidden = true
           self.isEditing = false
           self.navigationItem.leftBarButtonItems = [self.menuButton]
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
      
      coreData.titleCD = articlesCoreData[articlesCoreData.count - 1 - i].title
      coreData.urlToImageCD = articlesCoreData[articlesCoreData.count - 1 - i].urlToImage
      coreData.publishedAtCD = articlesCoreData[articlesCoreData.count - 1 - i].publishedAt
      coreData.urlCD = articlesCoreData[articlesCoreData.count - 1 - i].url
      coreData.contentCD = articlesCoreData[articlesCoreData.count - 1 - i].content
      coreData.authorCD = articlesCoreData[articlesCoreData.count - 1 - i].author
      coreData.descriptionCD = articlesCoreData[articlesCoreData.count - 1 - i].description
      
      do{
        try managed.save()
      } catch let error{
        debugPrint("Cant save: ",error)
      }
    }
  }
}

