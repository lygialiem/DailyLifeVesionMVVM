//
//  FavoriteCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import  SDWebImage
class FavoriteCell: UITableViewCell {
  
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var timePublishedArticle: UILabel!
  @IBOutlet var titleArticle: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    imageArticle.clipsToBounds = true
    imageArticle.layer.cornerRadius = 10
    imageArticle.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    imageArticle.layer.borderWidth = 2
  
    self.selectionStyle = UITableViewCell.SelectionStyle.none
  }
  func configureCell(article: FavoriteArtilce){
    guard let urlToImageCD = article.urlToImageCD else {return}
    imageArticle.sd_setImage(with:  URL(string: urlToImageCD), completed: nil)
    
    guard let timePublishedArticle = article.publishedAtCD else {return}
    let iso = ISO8601DateFormatter()
    let formatString = iso.date(from: timePublishedArticle)
    self.timePublishedArticle.text = "\(formatString!)".replacingOccurrences(of: "+0000", with: "")
    
    guard let titleArticle = article.titleCD else {return}
    self.titleArticle.text = titleArticle.uppercased()
  
  }
  
}
