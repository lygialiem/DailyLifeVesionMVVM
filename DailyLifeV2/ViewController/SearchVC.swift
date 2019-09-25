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
  weak  var delegate: SearchVCToReadingFavoriteVC?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.mySearchBar.delegate = self
    self.mySearchBar.backgroundColor = .black
    self.mySearchBar.barStyle = .black
    self.mySearchBar.placeholder = self.getUserDefault().replacingOccurrences(of: "%20", with: " ")
    self.tableView.register(R.nib.smallArticleCell)
    
    let topic = self.getUserDefault()
    
    if topic != ""{
      
      LibraryAPI.instance.getSearchArticle(topic: topic, page: 1, numberOfArticles: 15) { (articles) in
        let musHaveImageArticle = articles.articles?.filter({!($0.urlToImage == nil || $0.urlToImage == "")})
        let uniqueArticles = (musHaveImageArticle?.uniqueValues(value: {$0.title})) ?? [Article]()
        self.articles = uniqueArticles
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  func tapToResignFirstResponder(){
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.tableView.addGestureRecognizer(tap)
  }
  
  @objc func handleTap(){
    
  }
  
  func getUserDefault() -> String{
    guard let value = UserDefaults.standard.value(forKey: "searchTopic") as? String else {return String()}
    return value
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let topic = self.getUserDefault()
    if indexPath.row == articles.count - 5{
      let numberOfPage = 9
      if currentPage <= numberOfPage{
        
        LibraryAPI.instance.getSearchArticle(topic: topic, page: currentPage, numberOfArticles: 15) { (articles) in
          
          let uniqueArticles = articles.articles?.uniqueValues(value: {$0.title})
          let alwaysHaveImageArticles = (uniqueArticles?.filter({$0.urlToImage != nil || $0.urlToImage == ""})) ?? []
          
          for article in alwaysHaveImageArticles{
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
    
    let topic = self.getUserDefault()
    
    NotificationCenter.default.post(name: NSNotification.Name("searchVCToReadingVC"), object: nil, userInfo: ["data": articles, "indexPath": indexPath, "topic": topic])
    self.dismiss(animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.smallArticleCell, for: indexPath)!
    
    DispatchQueue.main.async {
      cell.configureCell(article: self.articles[indexPath.row])
    }
    
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
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if searchBar.text == "" || searchBar.text == " "{
      searchBar.placeholder = "Type What You Need"
    } else {
      let topic = searchBar.text?.replacingOccurrences(of: " ", with: "%20") ?? ""
      LibraryAPI.instance.getSearchArticle(topic: topic , page: 1, numberOfArticles: 10) { (articles) in
        
        let uniqueArticles = articles.articles?.uniqueValues(value: {$0.title})
        let alwaysHaveImageArticles = (uniqueArticles?.filter({$0.urlToImage != nil || $0.urlToImage == ""})) ?? []
        self.articles = alwaysHaveImageArticles
        
        DispatchQueue.main.async {
          UserDefaults.standard.set(topic, forKey: "searchTopic")
          UserDefaults.standard.synchronize()
          self.tableView.reloadData()
          searchBar.resignFirstResponder()
        }
      }
    }
  }
}

protocol SearchVCToReadingFavoriteVC: class {
  func searchVCToReadingFavoriteVC(articles: [Article], indexPathDidSelect: IndexPath)
}
