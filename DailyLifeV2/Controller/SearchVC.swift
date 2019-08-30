//
//  SearchVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/29/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import PanModal

class SearchVC: UITableViewController{
  
  var shortHeightFormEnabled = true
  @IBOutlet var mySearchBar: UISearchBar!
  var articles = [Article]()
  
  var searchText = ""
  var currentPage = 2
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tapToResignFirstResponder()
    self.mySearchBar.delegate = self
    self.mySearchBar.backgroundColor = .black
    self.mySearchBar.barStyle = .black
    self.mySearchBar.placeholder = "Please Type What You Need"
    self.tableView.register(UINib.init(nibName: "SmallArticleCell", bundle: nil), forCellReuseIdentifier: "SmallArticleCell")
    
    guard let userDefault = UserDefaults.standard.value(forKey: "searchTopic") as? String else {return}
    
    NewsApiService.instance.getSearchArticles(topic: userDefault, page: 1, numberOfArticles: 20) { (articles) in
     
      DispatchQueue.main.async {
         self.articles = articles.articles
        self.tableView.reloadData()
      }
    }
  }
  
  func tapToResignFirstResponder(){
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.tableView.addGestureRecognizer(tap)
  }
  
  @objc func handleTap(){
    self.mySearchBar.becomeFirstResponder()
   
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == articles.count - 3{
      let numberOfPage = 5
      if currentPage <= numberOfPage{
        NewsApiService.instance.getSearchArticles(topic: searchText , page: currentPage, numberOfArticles: 20 ) { (dataApi) in
          for article in dataApi.articles{
            self.articles.append(article)
          }
          self.currentPage += 1
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        }
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(1)
    let readingFavoriteArticle = storyboard?.instantiateViewController(withIdentifier: "ReadingFavoriteArticle") as! ReadingFavoriteArticle
    
    readingFavoriteArticle.articles = self.articles
    readingFavoriteArticle.indexPathOfDidSelectedArticle = indexPath
    readingFavoriteArticle.view.layoutIfNeeded()
    readingFavoriteArticle.myCollectionView.reloadData()
    
    self.navigationController?.pushViewController(readingFavoriteArticle, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SmallArticleCell") as! SmallArticleCell
    
    cell.configureCell(article: articles[indexPath.row])
    
    return cell
  }
}


extension SearchVC: PanModalPresentable{
  var panScrollable: UIScrollView?{
    return tableView
  }
  
  var shortFormHeight: PanModalHeight{
    return longFormHeight
  }
}


extension SearchVC: UISearchBarDelegate{

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    print("DID END")
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    self.dismiss(animated: true, completion: nil)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchText = searchBar.text ?? ""
    if searchBar.text == "" || searchBar.text == " "{
      searchBar.placeholder = "Please Type What You Need"
    } else {
      NewsApiService.instance.getSearchArticles(topic: searchBar.text?.replacingOccurrences(of: " ", with: "%20") ?? "", page: 1, numberOfArticles: 20) { (articles) in
        self.articles = articles.articles
        
        DispatchQueue.main.async {
          UserDefaults.standard.set(searchBar.text?.replacingOccurrences(of: " ", with: "%20") ?? "", forKey: "searchTopic")
          UserDefaults.standard.synchronize()
          self.tableView.reloadData()
          searchBar.resignFirstResponder()
        }
      }
    }
  }
}
