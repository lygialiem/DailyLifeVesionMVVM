//
//  DetailForecastCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class DetailForecastCell: UITableViewCell {

  @IBOutlet var sunRise: UILabel!
  @IBOutlet var sunSet: UILabel!
  @IBOutlet var moonRise: UILabel!
  @IBOutlet var moonSet: UILabel!
  @IBOutlet var precipitation: UILabel!
  @IBOutlet var humidity: UILabel!
  @IBOutlet var agvTemp: UILabel!
  @IBOutlet var highestTemp: UILabel!
  @IBOutlet var windGust: UILabel!
  @IBOutlet var lowestTemp: UILabel!
  @IBOutlet var visibility: UILabel!
  @IBOutlet var UVIndex: UILabel!

  @IBOutlet var dateForecast: UILabel!
  @IBOutlet var summary: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
  selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
