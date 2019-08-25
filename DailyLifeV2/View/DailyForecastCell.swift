//
//  WeatheTableViewRow2.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class DailyForecastCell: UITableViewCell {

  @IBOutlet var day: UILabel!
  @IBOutlet var icon: UIImageView!
  @IBOutlet var minTemp: UILabel!
  @IBOutlet var maxTemp: UILabel!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
      
      self.selectionStyle = .none
    }

  
  func configureCell(forecastDay: Forecastday?){
    
//    let date = NSDate(timeIntervalSince1970: forecastDay?.date_epoch ?? 0)
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "EEEE"
    let day = (forecastDay?.date_epoch ?? 0).formatEpochTime(dateFormatType: "EEEE")

    
    self.day.text = day
    
    let codeIcon = forecastDay?.day?.condition?.code ?? 0
    
    
    WeatherApiService.instance.getIconJson { (dataJson) in
      for i in 0..<dataJson.count{
        if codeIcon == dataJson[i].code{
          
          let fullDate = Date()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "HH"
          let currentDate = Int(dateFormatter.string(from: fullDate))
          
          if currentDate! > 5 && currentDate! <= 17{
            DispatchQueue.main.async {
              self.icon.image = UIImage(named: "day/\(dataJson[i].icon)")
            }
          } else{
            DispatchQueue.main.async {
              self.icon.image = UIImage(named: "night/\(dataJson[i].icon)")
            }
          }
        }
      }
    }
    self.maxTemp.text = "\(Int(round(forecastDay?.day?.maxtemp_c ?? 0)))º"
    self.minTemp.text = "\(Int(round(forecastDay?.day?.mintemp_c ?? 0)))º"
  }
}
