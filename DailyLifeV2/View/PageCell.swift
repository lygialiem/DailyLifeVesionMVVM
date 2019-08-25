//
//  PageCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 7/15/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class PageCell: UICollectionViewCell {
  
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var titleArticle: UILabel!
  @IBOutlet var timePublishedArticle: UILabel!
  @IBOutlet var likeButton: UIButton!
  
  var articles: Article?
  
  // false: Non-Saved...
  var isLikedStateButton = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    imageArticle.clipsToBounds = true
    imageArticle.layer.cornerRadius = 15
    imageArticle.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    imageArticle.layer.borderWidth = 1
    
  }
  
  func confiureCell(articles: Article?){
    DispatchQueue.main.async {
      self.articles = articles
      
      guard let title = articles?.title else {return}
      self.titleArticle.text = title.capitalized
      
      guard let timePublished = articles?.publishedAt else {return}
      let isoFormatter = ISO8601DateFormatter()
      let timePublishedFormatter = isoFormatter.date(from: timePublished)
      self.timePublishedArticle.text = "\(timePublishedFormatter!)".replacingOccurrences(of: "+0000", with: "", options: .caseInsensitive, range: nil)
      
      guard let image = articles?.urlToImage else {return}
      self.imageArticle.sd_setImage(with: URL(string: image))
    }
  }
  
  @IBAction func shareButtonByPressed(_ sender: Any) {
    NotificationCenter.default.post(name: NSNotification.Name("shareAction"), object: nil, userInfo: ["data": self.articles!.url!])
  }
  
  @IBAction func likeButtonByPress(_ sender: Any) {
    if isLikedStateButton{
      likeButton.setImage(UIImage(named: "greenLikeButton"), for: .normal)
      //delete article in CoreData:
      CoreDataServices.instance.fetchCoreData { (favoriteArticlesCD) in
        for i in 0..<favoriteArticlesCD.count{
          if favoriteArticlesCD[i].titleCD == articles?.title{
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(favoriteArticlesCD[i])
            do{
              try managedContext.save()
            } catch {
              print("Cannot Delete CoreData")
              return
            }
          }
        }
        self.isLikedStateButton = false
      }
    } else {
      likeButton.setImage(UIImage(named: "redLikeButton"), for: .normal)
      //save new article in CoreData:
      saveArticeToCoreData()
      self.isLikedStateButton = true
    }
  }
  
  func saveArticeToCoreData(){
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let managedContext = appDelegate!.persistentContainer.viewContext
    let coreData = FavoriteArtilce(context: managedContext)
    
    coreData.authorCD = articles?.author
    
    coreData.contentCD = articles?.content
    coreData.descriptionCD = articles?.description
    coreData.publishedAtCD = articles?.publishedAt
    coreData.titleCD = articles?.title
    coreData.urlCD = articles?.url
    coreData.urlToImageCD = articles?.urlToImage
    
    do {
      try managedContext.save()
    }catch let error as NSError{
      print("Could Not Save Data: \(error) ,\(error.userInfo)")
    }
  }
}
