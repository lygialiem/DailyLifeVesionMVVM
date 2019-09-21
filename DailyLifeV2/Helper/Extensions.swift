//
//  Extensions.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/14/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class Dog: Object{
  @objc dynamic var name = ""
  @objc dynamic var age = 0
}


extension NSMutableAttributedString {
  func setAsLink(textToFind:String, urlString: String) {
    let foundRange = self.mutableString.range(of: textToFind)
    self.addAttribute(NSAttributedString.Key.link, value: urlString, range: foundRange)
  }
}

extension UILabel {
  func startBlink() {
    UIView.animate(withDuration: 1.5,
                   delay:0.0,
                   options:[.curveEaseInOut, .autoreverse, .repeat],
                   animations: { self.alpha = 0 },
                   completion: nil)
  }
  
  func stopBlink() {
    layer.removeAllAnimations()
    alpha = 1
  }
}

extension Array
{
  func uniqueValues<V:Equatable>( value:(Element)->V) -> [Element]
  {
    var result:[Element] = []
    for element in self
    {
      if !result.contains(where: { value($0) == value(element) })
      { result.append(element) }
    }
    return result
  }
}

extension Int{
  func formatEpochTime(dateFormatType: String) -> String{
    let date = NSDate(timeIntervalSince1970: TimeInterval(self))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormatType
    return (dateFormatter.string(from: date as Date)).capitalized
  }
}

extension Double{
  func roundInt() -> Int{
    return Int(self.rounded())
  }
}

extension UIImageView{
  func checkCurrentTime(image: String, timeDay: Int, timeNight: Int){
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"
    let curretnDate = Int(dateFormatter.string(from: date))
    
    if curretnDate! >= timeDay && curretnDate! < timeNight{
      DispatchQueue.main.async {
        self.image = UIImage(named: "hourlyDay/\(image)")
      }
    }else {
      DispatchQueue.main.async {
        self.image = UIImage(named: "hourlyNight/\(image)")
      }
    }
  }
}

extension String{
  func changeFormatTime(from: String, to: String) -> String{
    let inputFormat = DateFormatter()
    let outputFormat = DateFormatter()
    
    inputFormat.dateFormat = from
    outputFormat.dateFormat = to
    
    let dateInput = inputFormat.date(from: self)
    return outputFormat.string(from: dateInput ?? Date())
  }
}

