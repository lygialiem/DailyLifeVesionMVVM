//
//  WeatherHeader0.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class WeatherHeader0: UITableViewCell {
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
    guard let cityZone = forecast?.location?.name, let description = forecast?.current?.condition?.text, let temperature = forecast?.current?.temp_c, let currentDay = forecast?.current?.last_updated_epoch,
      let region = forecast?.location?.region,
      let country = forecast?.location?.country
      else {return}
    if region == ""{
      self.regionCountry.text = "\(country)"
    } else {
       self.regionCountry.text = "\(region), \(country)"
    }
    
    
    self.cityZone.text = cityZone.capitalized
    
    self.weatherDescription.text = description.capitalized
    
    self.temperature.text = "\(Int(round(temperature)))ºC"
    
    
    self.currentDay.text = currentDay.formatEpochTime(dateFormatType: "MMMM dd, yyyy")
    
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"
    let currentHour = Int(dateFormatter.string(from: date))
    if currentHour! >= 5 && currentHour! < 17{
      DispatchQueue.main.async {
        self.sunMoonImage.image = UIImage(named: "day/Sun")
      }
    }else {
      DispatchQueue.main.async {
        self.sunMoonImage.image = UIImage(named: "night/moon")
      }
    }
  }
}
