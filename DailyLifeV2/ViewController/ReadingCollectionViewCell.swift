//
//  ReadingCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/15/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

protocol ReadingCollectionViewCellDelegate: class{
  func movoWebViewController(url: String?)
}

class ReadingCollectionViewCell: UICollectionViewCell {
  
  let contentCell = ContentCell()
  
  @IBOutlet var myTableView: UITableView!
  
  weak var delegate: ReadingCollectionViewCellDelegate?
  
  var article: Article?
  var articlesOfConcern = [Article]()
  var fontSize: CGFloat?
  var concernedTitle: String?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupMyTableView()
  }
  
  func setupMyTableView(){
    myTableView.estimatedRowHeight = 1000
    myTableView.delegate = self
    myTableView.dataSource = self
    myTableView.register(UINib.init(nibName: "SmallArticleCell", bundle: nil), forCellReuseIdentifier: "SmallArticleCell")
  }
}

extension ReadingCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
  
  override  func prepareForReuse() {
    super.prepareForReuse()
    myTableView.reloadData()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0{
      return 1
    } else if section == 1{
      return articlesOfConcern.count
    }
    return Int()
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 0
    case 1: return 20
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! ContentCell
      DispatchQueue.main.async {
        cell.configureContent(article: self.article ?? Article())
      }
      cell.delegate = self
      return cell
    } else if indexPath.section == 1{
      let cell = tableView.dequeueReusableCell(withIdentifier: "SmallArticleCell", for: indexPath) as! SmallArticleCell
      DispatchQueue.main.async {
        cell.configureCell(article: self.articlesOfConcern[indexPath.row])
      }
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0{
      return UITableView.automaticDimension
    } else if indexPath.section == 1{
      return 100
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return UIView()
    case 1:
      let section = tableView.dequeueReusableCell(withIdentifier: "section1") as! SearchForecast
      section.headerConcernedArticle.text = "Another Articles"
      return section
    default:
      return UIView()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1{
      delegate?.movoWebViewController(url: articlesOfConcern[indexPath.row].url)
    }
  }
}

extension ReadingCollectionViewCell: ReadingCellDelegate{
  func didPressSeeMore(url: String) {
    let webViewViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewController
    webViewViewController.urlOfContent = url
    NotificationCenter.default.post(name: NSNotification.Name("NavigateToWebViewVCFromFirstCell"), object: nil, userInfo: ["data": webViewViewController])
  }
}
