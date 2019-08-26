//
//  GTMCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class GTMCell: UITableViewCell {

  @IBOutlet var gtm: UILabel!
  @IBOutlet var timeZone: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
  
    let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setupTime), userInfo: nil, repeats: true)
    RunLoop.current.add(timer, forMode: .common)
    
    
    }

  @objc func setupTime(){
    
    timeZone.text = getTime()
    
  }
  
  func getTime() -> String{
    var stringTime = ""
    let dateFormater = DateFormatter()
    dateFormater.timeStyle = .short
    dateFormater.timeZone = TimeZone(identifier: "GTM")
    
    let timeNow = Date()
    stringTime = dateFormater.string(from: timeNow)
    return stringTime
  }
  
}
