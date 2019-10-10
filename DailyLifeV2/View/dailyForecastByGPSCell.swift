//
//  dailyForecastByGPSCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/30/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class dailyForecastByGPSCell: UICollectionViewCell {

  @IBOutlet var days: UILabel!
  @IBOutlet var myImage: UIImageView!
  @IBOutlet var hightTemp: UILabel!
  @IBOutlet var lowTemp: UILabel!
  @IBOutlet var precipPro: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

  }

  func configureCell(data: Data) {
    self.hightTemp.text = "\((data.temperatureMax ?? 0).roundInt())º"
    self.lowTemp.text = "\((data.temperatureMin ?? 0).roundInt())º"
    self.days.text = data.time?.formatEpochTime(dateFormatType: "E")
    self.myImage.checkCurrentTime(image: data.icon ?? "", timeDay: 6, timeNight: 18)

    let checkPrecipPro = (data.precipProbability ?? 0).roundInt()
    if checkPrecipPro == 0 {
      self.precipPro.text = ""
    } else {
      self.precipPro.text = "\(checkPrecipPro) %"
    }
  }
}
