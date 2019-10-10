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
  let effectTap = UINotificationFeedbackGenerator()

  // false: Non-Saved...
  var isLikedStateButton = false

  override func awakeFromNib() {
    super.awakeFromNib()

    imageArticle.clipsToBounds = true
    imageArticle.layer.cornerRadius = 15
    imageArticle.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    imageArticle.layer.borderWidth = 1

  }

  func confiureCell(articles: Article?) {
    self.articles = articles

    self.titleArticle.text = articles?.title ?? ""
    self.imageArticle.sd_setImage(with: URL(string: articles?.urlToImage ?? ""))

    let subString = (articles?.publishedAt ?? "").replacingOccurrences(of: "T", with: " ")
    let subString2 = subString.replacingOccurrences(of: "Z", with: "")
    let splitSubString = subString2.split(separator: " ")

    let timePublish = (articles?.publishedAt ?? "").changeFormatTime(from: "yyyy-MM-dd", to: "MMMM dd, yyyy")
    self.timePublishedArticle.text = "\(timePublish) \(String(splitSubString[1]).changeFormatTime(from: "HH:mm:ss", to: "h:mma"))"
  }

  func checkLikedButtonState(article: Article) {

  }

  @IBAction func shareButtonByPressed(_ sender: Any) {
    NotificationCenter.default.post(name: .shareAction, object: nil, userInfo: ["data": self.articles!.url!])
  }

  @IBAction func likeButtonByPress(_ sender: Any) {
    effectTap.notificationOccurred(.success)
    if isLikedStateButton {
        likeButton.setImage(R.image.greenLikeButton(), for: .normal)

      //delete article in CoreData:

      let predicate = NSPredicate(format: "title CONTAINS[c] $letter")
      let letter = articles?.title ?? ""
      let favoriteArticleToDelete = LibraryRealm.instance.realm.objects(FavoriteArticleRealmModel.self).filter(predicate.withSubstitutionVariables(["letter": "\(letter)"]))

      try! LibraryRealm.instance.realm.write {
        LibraryRealm.instance.realm.delete(favoriteArticleToDelete)
      }
      isLikedStateButton = !(isLikedStateButton)
    } else {
        likeButton.setImage(R.image.redLikeButton(), for: .normal)

      //save new article in CoreData:

      try! LibraryRealm.instance.realm.write {
        let favoriteAtticleToSave = FavoriteArticleRealmModel()
        favoriteAtticleToSave.author = articles?.author ?? ""
        favoriteAtticleToSave.content = articles?.content ?? ""
        favoriteAtticleToSave.descriptions = articles?.description ?? ""
        favoriteAtticleToSave.title = articles?.title ?? ""
        favoriteAtticleToSave.url = articles?.url ?? ""
        favoriteAtticleToSave.urlToImage = articles?.urlToImage ?? ""
        favoriteAtticleToSave.publishedAt = articles?.publishedAt ?? ""

        LibraryRealm.instance.realm.add(favoriteAtticleToSave)
      }

      isLikedStateButton = !(isLikedStateButton)
    }
  }

  func saveArticeToCoreData() {
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
    } catch let error as NSError {
      print("Could Not Save Data: \(error) ,\(error.userInfo)")
    }
  }
}
