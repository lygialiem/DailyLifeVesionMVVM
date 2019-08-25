//
//  WeatherRow3.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/23/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class WeatherRow3: UITableViewCell {

  @IBOutlet var summary: UILabel!
  
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
       self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
