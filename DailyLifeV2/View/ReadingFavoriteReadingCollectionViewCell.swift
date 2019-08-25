//
//  ReadingFavoriteReadingCollectionViewCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/18/19.
//  Copyright © 2019 LGL. All rights reserved.
//


import UIKit
import SDWebImage


protocol ReadingFavoriteCollectionViewCellDelegate{
  func moveToWebViewController(url: String)
}

class ReadingFavoriteReadingCollectionViewCell: UICollectionViewCell {
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var titleArticle: UILabel!
  @IBOutlet var contentArticle: UITextView!
  @IBOutlet var authorArticle: UILabel!
  
  var article: FavoriteArtilce?
  var indexPathOfDidSelectedArticle: IndexPath?
  let seeMore = "See more"
  var delegate: ReadingFavoriteCollectionViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    
  }
  
  func configureContent(article: FavoriteArtilce?){
    
    guard let urlToImage = article?.urlToImageCD else {return}
    imageArticle.sd_setImage(with: URL(string: urlToImage), completed: nil)
    titleArticle.text = article?.titleCD?.capitalized
    authorArticle.text = article?.authorCD
    
    contentArticle.layer.cornerRadius = 7
    contentArticle.delegate = self
    
    let attributedOfString = [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)]
    
    let stringContent = "\(article!.contentCD!) - \(seeMore)"
    let completedConent = stringContent.replacingOccurrences(of: "[", with: "(", options: String.CompareOptions.literal, range: nil)
    let completedConent1 = completedConent.replacingOccurrences(of: "+", with: "", options: String.CompareOptions.literal, range: nil)
    let finalContent = completedConent1.replacingOccurrences(of: "]", with: ")", options: String.CompareOptions.literal, range: nil)
    let attributedString = NSMutableAttributedString(string: finalContent, attributes: attributedOfString as [NSAttributedString.Key : Any])
    
    guard let url = article?.urlCD else {return}
    attributedString.setAsLink(textToFind: seeMore, urlString: url)
    
    contentArticle.attributedText = attributedString
  }
}

extension ReadingFavoriteReadingCollectionViewCell:  UITextViewDelegate{
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    
    delegate?.moveToWebViewController(url: URL.absoluteString)
    
    return false
  }
}
