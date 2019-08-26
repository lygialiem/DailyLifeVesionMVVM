//
//  WorldClockCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class WorldClockCell: UITableViewCell {
  
  @IBOutlet var cityName: UILabel!
  @IBOutlet var timeZone: UILabel!
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
    RunLoop.current.add(timer, forMode: .tracking)
  }
  
  @objc func setTime(){
    timeZone.text = getTime()
  }
  
  func getTime() -> String{
  
    var timeString = ""
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    dateFormatter.timeZone = TimeZone(identifier: cityName.text ?? "")
    
    let timeNow = Date()
    timeString = dateFormatter.string(from: timeNow)
    
    return timeString
  }

  
}
