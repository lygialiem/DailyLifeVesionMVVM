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
  @IBOutlet var gmt: UILabel!
  
  var idTimezone: String?
  let feedback = UINotificationFeedbackGenerator()
  
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
    //    dateFormatter.timeStyle = .long
    dateFormatter.dateFormat = "h:mm:ss a ZZZZZ"
    dateFormatter.timeZone = TimeZone(identifier: idTimezone ?? "")
    let timeNow = Date()
    let stringDate = dateFormatter.string(from: timeNow)
    let splitSubStringDate = stringDate.split(separator: " ")
    
    timezone.text = "\(String(splitSubStringDate[0])) \(String(splitSubStringDate[1]))"
    
    if String(splitSubStringDate[2]) == "Z"{
      gmt.text = "GMT+0"
    }
    gmt.text = "GMT\(String(splitSubStringDate[2]))"
    
    continentName.text = String((idTimezone?.split(separator: "/")[0]) ?? "")
    
    let splitString = idTimezone?.split(separator: "/")
    guard let splitStringNoneOptional = splitString else {return}
    
    if splitStringNoneOptional.count == 1{
      cityName.text = "Zulu Time"
      self.continentName.text = ""
    } else {
      cityName.text = (splitStringNoneOptional[1]).replacingOccurrences(of: "_", with: " ")
    }
  }
}
