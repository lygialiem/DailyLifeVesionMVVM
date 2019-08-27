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
  @IBOutlet var timezone: UILabel!
  @IBOutlet var continentName: UILabel!
  
  var idTimezone: String?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    
    let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
    RunLoop.current.add(timer, forMode: .tracking)
    
  }
  
  @objc func setTime(){
    
  setupCell()
    
  }
  
  func setupCell(){
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .long
    dateFormatter.timeZone = TimeZone(identifier: idTimezone ?? "")
    let timeNow = Date()
    timezone.text = dateFormatter.string(from: timeNow)
    
    continentName.text = String((idTimezone?.split(separator: "/")[0]) ?? "")
    cityName.text = String((idTimezone?.split(separator: "/")[1]) ?? "").replacingOccurrences(of: "_", with: " ")
    
  }
}
