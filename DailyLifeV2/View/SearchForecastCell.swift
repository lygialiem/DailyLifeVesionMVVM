//
//  WeatherHeader1-2.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

protocol moveToWebVC: class {
  func moveToWebVCFromWeatherVC(url: String)
}

class SearchForecast: UITableViewCell {
  
  @IBOutlet var dailyTitleHeader: UILabel!
  @IBOutlet var hourlyTitleHeader: UILabel!
  @IBOutlet var summaryTitleHeader: UILabel!
  @IBOutlet var detailTitleHeader: UILabel!
  
  @IBOutlet var darkSkyBtn: UIButton!
  @IBOutlet var apixuBtn: UIButton!
  @IBOutlet var seatchBtn: UIButton!
  
  @IBOutlet var headerConcernedArticle: UILabel!
  
 weak var delegate: moveToWebVC?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    
  }

  @IBAction func darkSkyBtnByPressed(_ sender: Any) {

      self.movoToWebViewController(linkToMove: "https://darksky.net/dev")
    
  }
  
  @IBAction func apixuBtnByPressed(_ sender: Any) {
    
    movoToWebViewController(linkToMove: "https://www.apixu.com/")
  }
  
  func movoToWebViewController(linkToMove: String){
    
    self.delegate?.moveToWebVCFromWeatherVC(url: linkToMove )
  }
}
