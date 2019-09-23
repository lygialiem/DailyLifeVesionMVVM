//
//  CityForecastCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//


import UIKit

class CityForecastCell: UITableViewCell {
  @IBOutlet var cityZone: UILabel!
  @IBOutlet var weatherDescription: UILabel!
  @IBOutlet var sunMoonImage: UIImageView!
  @IBOutlet var temperature: UILabel!
  @IBOutlet var currentDay: UILabel!
  @IBOutlet var regionCountry: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  
  func configureCell(forecast: ForecastApi?){
    guard let cityZone = forecast?.location?.name, let description = forecast?.current?.condition?.text, let temperature = forecast?.current?.temp_c,
        let region = forecast?.location?.region,
        let country = forecast?.location?.country,
        let lastUpdated = forecast?.location?.localtime
      else {return}
    if region == ""{
      self.regionCountry.text = "\(country)"
    } else {
      self.regionCountry.text = "\(region), \(country)"
    }
    
    
    self.cityZone.text = cityZone.capitalized
    
    self.weatherDescription.text = description.capitalized
    
    self.temperature.text = "\(Int(round(temperature)))ºC"
    
    self.currentDay.text = lastUpdated.changeFormatTime(from: "YYYY-MM-dd HH:mm", to: "MMMM dd, YYYY h:mma")
    
  
    let currentHour = Int(lastUpdated.changeFormatTime(from: "YYYY-MM-dd H:mm", to: "H")) ?? 0
    
    if currentHour >= 5 && currentHour < 19{
      DispatchQueue.main.async {
        self.sunMoonImage.image = R.image.day.sun()
      }
    }else {
      DispatchQueue.main.async {
         self.sunMoonImage.image = R.image.night.moon()
      }
    }
  }
}

