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
  var delegate: SearchVCToReadingFavoriteVC?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.mySearchBar.delegate = self
    self.mySearchBar.backgroundColor = .black
    self.mySearchBar.barStyle = .black
    self.mySearchBar.placeholder = self.getUserDefault()
    self.tableView.register(UINib.init(nibName: "SmallArticleCell", bundle: nil), forCellReuseIdentifier: "SmallArticleCell")
    
    let topic = self.getUserDefault()
    
    
    if topic != ""{
      NewsApiService.instance.getSearchArticles(topic: topic, page: 1, numberOfArticles: 10) { (articles) in
      
        self.articles = articles.articles
        
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
    if indexPath.row == articles.count - 3{
      let numberOfPage = 5
      if currentPage <= numberOfPage{
        NewsApiService.instance.getSearchArticles(topic: topic , page: currentPage, numberOfArticles: 20 ) { (dataApi) in
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
    
    let topic = self.getUserDefault()
    
    NotificationCenter.default.post(name: NSNotification.Name("searchVCToReadingVC"), object: nil, userInfo: ["data": articles, "indexPath": indexPath, "topic": topic])
    self.dismiss(animated: true, completion: nil)
    
    
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
    
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if searchBar.text == "" || searchBar.text == " "{
      searchBar.placeholder = "Type What You Need"
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

protocol SearchVCToReadingFavoriteVC {
  func searchVCToReadingFavoriteVC(articles: [Article], indexPathDidSelect: IndexPath)
}