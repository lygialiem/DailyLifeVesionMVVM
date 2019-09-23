//
//  FavoriteVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteVC: UIViewController {
  
  @IBOutlet var myTableView: UITableView!
  @IBOutlet var swiftLabel: UILabel!
  @IBOutlet var menuButton: UIBarButtonItem!
  
  var favoriteArticlesViewModel = FavoriteArticlesViewModel()
  var articlesCoreData = [Article]()
  lazy var favoriteArticleRealmModel: Results<FavoriteArticleRealmModel> = {
    LibraryRealm.instance.realm.objects(FavoriteArticleRealmModel.self)
  }()
  
  let feedback = UINotificationFeedbackGenerator()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.swiftLabel.stopBlink()
    self.swiftLabel.startBlink()
    
    let favoriteArticles = LibraryRealm.instance.realm.objects(FavoriteArticleRealmModel.self)
    
    if favoriteArticles.isEmpty{
      self.myTableView.isHidden = true
      self.myTableView.setEditing(self.myTableView.isEditing, animated: true)
      self.navigationItem.leftBarButtonItems = [self.menuButton]
      self.myTableView.isEditing = false
    } else {
      
      self.articlesCoreData = Array(repeating: Article(), count: favoriteArticles.count)
      for i in 0..<favoriteArticles.count{
        
        self.articlesCoreData[i].title = favoriteArticles[favoriteArticles.count - 1 - i].title
        self.articlesCoreData[i].author = favoriteArticles[favoriteArticles.count - 1 - i].author
        self.articlesCoreData[i].content = favoriteArticles[favoriteArticles.count - 1 - i].content
        self.articlesCoreData[i].description = favoriteArticles[favoriteArticles.count - 1 - i].descriptions
        self.articlesCoreData[i].publishedAt = favoriteArticles[favoriteArticles.count - 1 - i].publishedAt
        self.articlesCoreData[i].url = favoriteArticles[favoriteArticles.count - 1 - i].url
        self.articlesCoreData[i].urlToImage = favoriteArticles[favoriteArticles.count - 1 - i].urlToImage
      }
      self.myTableView.isHidden = false
      self.myTableView.reloadData()
      self.navigationItem.leftBarButtonItems = [self.menuButton, self.editButtonItem]
      self.myTableView.setEditing(self.isEditing, animated: true)
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    myTableView.delegate = self
    myTableView.dataSource = self
    myTableView.estimatedRowHeight = 100
    
    self.swiftLabel.startBlink()
    myTableView.isHidden = false
    navigationController?.title = "Liked Contents"
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleMoveTabbar), name: NSNotification.Name("MoveToTabbarIndex0"), object: nil)
    myTableView.register(R.nib.smallArticleCell)
    
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func handleMoveTabbar(){
    self.tabBarController?.selectedIndex = 0
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
    
    let favoriteArticles = LibraryRealm.instance.realm.objects(FavoriteArticleRealmModel.self)
     try! LibraryRealm.instance.realm.write {
      LibraryRealm.instance.realm.delete(favoriteArticles)
    }
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    LibraryCoreData.instance.fetchCoreData { (favoriteArticlesCD) in
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
    
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.smallArticleCell, for: indexPath)!
    DispatchQueue.main.async {
      cell.configureCell(article: self.articlesCoreData[indexPath.row])
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
    return true
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {(rowAction, indexPath) in
      
      let favoriteArticles = LibraryRealm.instance.realm.objects(FavoriteArticleRealmModel.self)
      
      try! LibraryRealm.instance.realm.write {
        
        LibraryRealm.instance.realm.delete(favoriteArticles)
        self.articlesCoreData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .bottom)
        
        for i in 0..<self.articlesCoreData.count{
          let favorArticle = FavoriteArticleRealmModel()
          
          favorArticle.title = self.articlesCoreData[self.articlesCoreData.count - 1 - i].title ?? ""
          favorArticle.urlToImage = self.articlesCoreData[self.articlesCoreData.count - 1 - i].urlToImage ?? ""
          favorArticle.publishedAt = self.articlesCoreData[self.articlesCoreData.count - 1 - i].publishedAt ?? ""
          favorArticle.url = self.articlesCoreData[self.articlesCoreData.count - 1 - i].url ?? ""
          favorArticle.content = self.articlesCoreData[self.articlesCoreData.count - 1 - i].content ?? ""
          favorArticle.author = self.articlesCoreData[self.articlesCoreData.count - 1 - i].author ?? ""
          favorArticle.descriptions = self.articlesCoreData[self.articlesCoreData.count - 1 - i].description ?? ""
          
          LibraryRealm.instance.realm.add(favorArticle)
        }
      }
      
      if self.articlesCoreData.isEmpty{
        self.myTableView.isHidden = true
        self.isEditing = false
        self.navigationItem.leftBarButtonItems = [self.menuButton]
      } else {
        self.myTableView.isHidden = false
      }
      
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
    
    let itemToMove = articlesCoreData[sourceIndexPath.row]
    articlesCoreData.remove(at: sourceIndexPath.row)
    articlesCoreData.insert(itemToMove, at: destinationIndexPath.row )
    
    let favorArticles = LibraryRealm.instance.realm.objects(FavoriteArticleRealmModel.self)
    try! LibraryRealm.instance.realm.write {
      LibraryRealm.instance.realm.delete(favorArticles)
      for i in 0..<articlesCoreData.count{
        let favorArticle = FavoriteArticleRealmModel()
        
        favorArticle.title = articlesCoreData[articlesCoreData.count - 1 - i].title ?? ""
        favorArticle.urlToImage = articlesCoreData[articlesCoreData.count - 1 - i].urlToImage ?? ""
        favorArticle.publishedAt = articlesCoreData[articlesCoreData.count - 1 - i].publishedAt ?? ""
        favorArticle.url = articlesCoreData[articlesCoreData.count - 1 - i].url ?? ""
        favorArticle.content = articlesCoreData[articlesCoreData.count - 1 - i].content ?? ""
        favorArticle.author = articlesCoreData[articlesCoreData.count - 1 - i].author ?? ""
        favorArticle.descriptions = articlesCoreData[articlesCoreData.count - 1 - i].description ?? ""
        
        LibraryRealm.instance.realm.add(favorArticle)
      }
    }
  }
}

