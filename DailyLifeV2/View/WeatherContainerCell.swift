//
//  WeatherContainerCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/20/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class WeatherContainerCell: UITableViewCell {

  @IBOutlet var iconWeather: UIImageView!
  @IBOutlet var descriptionWeather: UILabel!
  @IBOutlet var titleWeather: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    
    self.selectionStyle = .none
    iconWeather.tintColor = .white
  }
  
  func setData(_ text: String, _ text2: String, _ image: UIImage) {
    descriptionWeather.text = text
    titleWeather.text = text2
    iconWeather.image = image
  }
  
}
