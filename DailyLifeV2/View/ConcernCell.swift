//
//  SecondCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class ConcernCell: UITableViewCell {
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var titleArticle: UILabel!
  @IBOutlet var timePublishedArticle: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = UITableViewCell.SelectionStyle.none
    imageArticle.clipsToBounds = true
    imageArticle.layer.cornerRadius = 10
    imageArticle.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    imageArticle.layer.borderWidth = 2
  }
  
  func configureContent(article: Article?){
    
      guard let urlToImage = article?.urlToImage, let title = article?.title, let time = article?.publishedAt else {return}
      
      let url = URL(string: urlToImage)
      self.imageArticle.sd_setImage(with: url, completed: nil)
      
      let iso = ISO8601DateFormatter()
      let isoString = iso.date(from: time)
      self.timePublishedArticle.text = "\(isoString!)".replacingOccurrences(of: "+0000", with: "")
      
      self.titleArticle.text = title
    }
  }
