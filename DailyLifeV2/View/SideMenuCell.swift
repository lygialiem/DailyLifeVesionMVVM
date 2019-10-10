//
//  SideMenuCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/12/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class SideMenuCell: UICollectionViewCell {

  @IBOutlet var topic: UILabel!
  @IBOutlet var imageSideMenu: UIImageView!

  var imageName: String! {
    didSet {
      imageSideMenu.clipsToBounds = true
      imageSideMenu.layer.cornerRadius = 15
      imageSideMenu.layer.borderWidth = 1
      imageSideMenu.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      imageSideMenu.image = UIImage(named: imageName)
    }
  }

  var topicName: String! {
    didSet {
    topic.text = topicName

    }
  }
}
