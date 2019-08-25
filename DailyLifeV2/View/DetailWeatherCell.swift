//
//  DetailWeatherCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/23/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class DetailWeatherCell: UITableViewCell {
  
//  @IBOutlet var sunriseTitle: UILabel!
//  @IBOutlet var sunsetTitle: UILabel!
//  @IBOutlet var chanceOfRainTItle: UILabel!
//  @IBOutlet var humidityTitle: UILabel!
//  @IBOutlet var windTitle: UILabel!
//  @IBOutlet var feelsLikeTitle: UILabel!
//  @IBOutlet var precipitationTitle: UILabel!
//  @IBOutlet var pressureTitle: UILabel!
//  @IBOutlet var visibilityTitle: UILabel!
//  @IBOutlet var UVIndexTitle: UILabel!
  
  @IBOutlet var sunrise: UILabel!
  @IBOutlet var sunset: UILabel!
  @IBOutlet var precipMm: UILabel!
  @IBOutlet var humidity: UILabel!
  @IBOutlet var wind: UILabel!
  @IBOutlet var feelsLike: UILabel!
  @IBOutlet var gustKmPH: UILabel!
  @IBOutlet var pressure: UILabel!
  @IBOutlet var visibility: UILabel!
  @IBOutlet var UVIndex: UILabel!
  @IBOutlet var moonrise: UILabel!
  @IBOutlet var moonset: UILabel!
  
  

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
