//
//  Extensions.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/14/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import UIKit

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

//public extension Array where Element: Hashable {
//  
//  /// Return the array with all duplicates removed.
//  ///
//  /// i.e. `[ 1, 2, 3, 1, 2 ].uniqued() == [ 1, 2, 3 ]`
//  ///
//  /// - note: Taken from stackoverflow.com/a/46354989/3141234, as
//  ///         per @Alexander's comment.
//  func uniqued() -> [Element] {
//    var seen = Set<Element>()
//    return self.filter { seen.insert($0).inserted }
//  }
//}

extension Array where Element: Hashable {
  var uniques: Array {
    var buffer = Array()
    var added = Set<Element>()
    for elem in self {
      if !added.contains(elem) {
        buffer.append(elem)
        added.insert(elem)
      }
    }
    return buffer
  }
}

extension UITextView{
  func textViewDidChangeHeight() {
    self.translatesAutoresizingMaskIntoConstraints = true
    let fixedWidth = self.frame.size.width
    self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    var newFrame = self.frame
    newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    self.frame = newFrame
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

