//
//  SmallArticleCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/30/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class SmallArticleCell: UITableViewCell {

  @IBOutlet var myImage: UIImageView!
  @IBOutlet var myTitle: UILabel!
  @IBOutlet var myPublish: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
       self.selectionStyle = .none
    }
  
  func configureCell(article: Article ){
    guard let urlToImage = article.urlToImage, let timePublishedArticle = article.publishedAt, let titleArticle = article.title   else {return}
    
    myImage.sd_setImage(with:  URL(string: urlToImage), completed: nil)
    myImage.clipsToBounds = true
    myImage.layer.cornerRadius = 10
    myImage.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    myImage.layer.borderWidth = 2
    
 
    let subString = timePublishedArticle.replacingOccurrences(of: "T", with: " ")
    let subString2 = subString.replacingOccurrences(of: "Z", with: "")
    let splitSubString = subString2.split(separator: " ")
  
    
    let timePublish = timePublishedArticle.changeFormatTime(from: "yyyy-MM-dd", to: "MMMM dd, yyyy")
    self.myPublish.text = "\(timePublish) \(splitSubString[1])"
   
    self.myTitle.text = titleArticle.capitalized
  }
}

