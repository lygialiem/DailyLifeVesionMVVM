//
//  PageVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase


class PageVC: UIViewController, IndicatorInfoProvider, UITabBarControllerDelegate {
  
  
  @IBOutlet var outOfDateApi: UILabel!
  @IBOutlet var newsFeedCV: UICollectionView!
  
  var articles = [Article]()
  var menuBarTitle: String = ""
  var currentPage = 2
  var articlesOfConcern = [Article]()
  let refreshControl = UIRefreshControl()
  
    override func viewWillAppear(_ animated: Bool) {
        
        Analytics.logEvent("\(menuBarTitle.uppercased())", parameters: nil)
//
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set("Topic", value: "\(menuBarTitle)")
//
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as [NSObject : AnyObject])
//
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    print(LibraryRealm.instance.realm.configuration.fileURL!)
    setupRefreshControl()
    configureCollectionView()
    self.navigationItem.backBarButtonItem?.title = ""
    self.tabBarController?.delegate = self
    NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name("reload"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleShareAction(notification:)), name: NSNotification.Name("shareAction"), object: nil)
    
    
    DispatchQueue.global(qos: .userInitiated).async {
      
      LibraryAPI.instance.getArticles(topic: self.menuBarTitle, page: 1, numberOfArticles: 7){ (articles) in
        let uniqueArticles = articles.articles.uniqueValues(value: {$0.title})
        self.articles = uniqueArticles.filter({!($0.urlToImage == nil || $0.urlToImage == "")})
        
        DispatchQueue.main.async {
          self.newsFeedCV.reloadData()
        }
      }
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func scrollToTop() {
    self.newsFeedCV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  }
  
  @objc func handleShareAction(notification: Notification){
    let url = notification.userInfo!["data"]
    let share = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
    self.present(share, animated: true, completion: nil)
  }
  @objc func handleReload(){
    self.newsFeedCV.reloadData()
  }
  func setupRefreshControl(){
    refreshControl.tintColor = #colorLiteral(red: 1, green: 0.765712738, blue: 0.0435429886, alpha: 1)
    refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
    newsFeedCV.refreshControl = refreshControl
  }
  func configureCollectionView(){
    newsFeedCV.delegate = self
    newsFeedCV.dataSource = self
  }
  
  @objc func handleRefreshControl(){
    
    LibraryAPI.instance.getArticles(topic: menuBarTitle, page: 1, numberOfArticles: 7) { (data) in
      
      self.articles = data.articles.filter({!($0.urlToImage == nil)})
      DispatchQueue.main.async {
        self.newsFeedCV.reloadData()
        self.refreshControl.endRefreshing()
      }
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "\(menuBarTitle)")
  }
}

extension PageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return articles.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.cellOfArticles, for: indexPath) as! PageCell
    
    DispatchQueue.main.async {
      cell.confiureCell(articles: self.articles[indexPath.row])
    }
    cell.likeButton.setImage(R.image.greenLikeButton(), for: .normal)
    cell.isLikedStateButton = false
    
    let favoriteArticles = LibraryRealm.instance.realm.objects(FavoriteArticleRealmModel.self)
      favoriteArticles.forEach { (article) in
        if article.title == self.articles[indexPath.row].title{
            cell.likeButton.setImage(R.image.redLikeButton(), for: .normal)
          cell.isLikedStateButton = true
        }
      }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = self.view.frame.width - 40
    return CGSize(width: width, height: width * 9 / 16 + 60)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let storyboard = self.storyboard else { return }
    let readingVC = storyboard.instantiateViewController(withIdentifier: "ReadingVC") as! ReadingVC
    
    readingVC.articles = self.articles
    readingVC.indexPathOfDidSelectedArticle = indexPath
    readingVC.concernedTitle = menuBarTitle
    readingVC.title = menuBarTitle
    readingVC.navigationItem.backBarButtonItem?.title = ""
    readingVC.view.layoutIfNeeded()
    readingVC.readingCollectionView.reloadData()
    
    self.navigationController?.pushViewController(readingVC, animated: true)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    if indexPath.row == articles.count - 2{
      let numberOfPage = 9
      if currentPage <= numberOfPage{
        
        LibraryAPI.instance.getArticles(topic: menuBarTitle, page: currentPage, numberOfArticles: 7) { (articles) in
          let musHaveImageArticle = articles.articles.filter({!($0.urlToImage == nil || $0.urlToImage == "")})
          let uniqueArticles = musHaveImageArticle.uniqueValues(value: {$0.title})
          for article in uniqueArticles{
            self.articles.append(article)
            collectionView.insertItems(at: [IndexPath(row: self.articles.count - 1, section: indexPath.section)])
          }
          self.currentPage += 1
        }
      }
    }
  }
}
