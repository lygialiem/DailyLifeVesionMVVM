//
//  ReadingFavoriteArticle.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/18/19.
//  Copyright © 2019 LGL. All rights reserved.
//


import UIKit
import SDWebImage

class ReadingFavoriteArticle: UIViewController {
  
  @IBOutlet var myCollectionView: UICollectionView!
  
  var articles = [Article]()
  var indexPathOfDidSelectedArticle: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupReadingCollectionView()
    
    view.layoutIfNeeded()
    myCollectionView.reloadData()
    
    setupReadingCollectionView()
  }
  
  func setupReadingCollectionView(){
    myCollectionView.delegate = self
    myCollectionView.dataSource = self
    myCollectionView.isPagingEnabled = true
    myCollectionView.scrollToItem(at: indexPathOfDidSelectedArticle!
      , at: .centeredHorizontally, animated: false)
  }
  @IBAction func shareButton(_ sender: Any) {
    let shareAction = UIActivityViewController(activityItems: [self.articles[indexPathOfDidSelectedArticle?.row ?? 0].url ?? ""], applicationActivities: nil)
    self.present(shareAction, animated: true, completion: nil)
  }
}

extension ReadingFavoriteArticle: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return articles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let readingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ReadingFavoriteReadingCollectionViewCell
    
    readingCell.delegate = self
    readingCell.configureContent(article: articles[indexPath.row])
    
    return readingCell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: view.frame.width, height: self.myCollectionView.frame.height)
  }
}

extension ReadingFavoriteArticle: ReadingFavoriteCollectionViewCellDelegate{
  func moveToWebViewController(url: String) {
    let webViewViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewController
    webViewViewController.urlOfContent = url
    self.navigationController?.pushViewController(webViewViewController, animated: true)
  }
}



