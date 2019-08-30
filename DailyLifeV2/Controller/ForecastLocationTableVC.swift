//
//  ForecastLocationTableVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/29/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import PanModal
import CoreLocation

class ForecastLocationTableVC: UITableViewController {
  
  var dataForecast: DarkSkyApi?
  var shortHeightFormEnabled = true
  var coordinate: ((CLLocationCoordinate2D?) -> Void)?
  let managerLocation = CLLocationManager()
  var detailGPS: ReversedGeoLocation?
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    tableView.dataSource = self
    tableView.register(UINib.init(nibName: "DetailForecastCell", bundle: nil), forCellReuseIdentifier: "DetailForecastCell")
    
    
    let current = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H"
    let currentHour = dateFormatter.string(from: current)
    guard let nowHour = Int(currentHour) else {return}
    
    switch nowHour {
    case 0..<2:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients1"))
    case 2..<3:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients2"))
    case 3..<4:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients3"))
    case 4..<5:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients4"))
    case 5..<7:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients5"))
    case 7..<8:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients6"))
    case 8..<10:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients7"))
    case 10..<12:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients8"))
    case 12..<14:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients9"))
    case 14..<15:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients10"))
    case 15..<16:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients11"))
    case 16..<17:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients12"))
    case 17..<18:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients13"))
    case 18..<19:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients14"))
    case 19..<22:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients15"))
    case 22...23:
      tableView.backgroundView = UIImageView(image: UIImage(named: "Solar Gradients16"))
      
    default:
      break
    }
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 3
    default:
      return 8
    }
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      
      switch indexPath.row{
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as! Title_Sumary_Daily_Forecast
        cell.titleCell.text = "GPS Forecast Weather"
        return cell
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "sumaryCell") as! Title_Sumary_Daily_Forecast
        
        DispatchQueue.main.async {
          cell.tempSumary.text = "\((self.dataForecast?.currently?.temperature ?? 0).roundInt())ºC"
          cell.citySumary.text = "\(self.detailGPS?.city ?? "")"
          cell.imageSumary.checkCurrentTime(image: self.dataForecast?.currently?.icon ?? "", timeDay: 6, timeNight: 18)
        }
        return cell
      case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyForecast") as! DailyForecaseSearch
        cell.dailyForecast = dataForecast?.daily
        cell.myCollectionView.reloadData()
        return cell
      default: return UITableViewCell()
      }
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DetailForecastCell") as! DetailForecastCelll
      switch indexPath.row{
      case 0:
        cell.title1.text = "Latitude"
        cell.title2.text = "Longitude"
        cell.para1.text = "\((((dataForecast?.latitude ?? 0) * 1000).roundInt()) / 1000 )º"
        cell.para2.text = "\((((dataForecast?.longitude ?? 0) * 1000).roundInt()) / 1000 )º"
        return cell
      case 1:
        cell.title1.text = "Temperature"
        cell.title2.text = "Feels Like"
        cell.para1.text = "\((dataForecast?.currently?.temperature ?? 0).roundInt())ºC"
        cell.para2.text = "\((dataForecast?.currently?.apparentTemperature ?? 0).roundInt())ºC"
        return cell
      case 2:
        cell.title1.text = "Precip Intensity"
        cell.title2.text = "Precip Probability"
        cell.para1.text = "\(dataForecast?.currently?.precipIntensity ?? 0) mm/h"
        cell.para2.text = "\(((dataForecast?.currently?.precipProbability ?? 0) * 100).roundInt()) %"
        return cell
      case 3:
        cell.title1.text = "Humidity"
        cell.title2.text = "Pressure"
        cell.para1.text = "\(((dataForecast?.currently?.humidity ?? 0) * 100).roundInt()) %"
        cell.para2.text = "\((dataForecast?.currently?.pressure ?? 0).roundInt()) hPa"
        return cell
      case 4:
        cell.title1.text = "Wind Speed"
        cell.title2.text = "Wind Gust"
        cell.para1.text = "\(((((dataForecast?.currently?.windSpeed ?? 0) * 3.6) * 100).roundInt()) / 100 ) km/h"
        cell.para2.text = "\(((((dataForecast?.currently?.windGust ?? 0) * 3.6) * 100).roundInt()) / 100 ) km/h"
        return cell
      case 5:
        cell.title1.text = "Wind Bearing"
        cell.title2.text = "Dew Point"
        cell.para1.text = "\((dataForecast?.currently?.windBearing ?? 0).roundInt())º"
        cell.para2.text = "\((dataForecast?.currently?.dewPoint ?? 0))ºC"
        return cell
      case 6:
        cell.title1.text = "Cloud Cover"
        cell.title2.text = "Visibility"
        cell.para1.text = "\(((dataForecast?.currently?.cloudCover ?? 0) * 100).roundInt()) %"
        cell.para2.text = "\((dataForecast?.currently?.visibility ?? 0).roundInt()) km"
        return cell
      case 7:
        cell.title1.text = "Ozone"
        cell.title2.text = "UV Index"
        cell.para1.text = "\((dataForecast?.currently?.ozone ?? 0)) DU"
        cell.para2.text = "\((dataForecast?.currently?.uvIndex ?? 0).roundInt())"
        return cell
      default:
        return UITableViewCell()
      }
      
    default:
      return UITableViewCell()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      switch indexPath.row{
      case 0:
        return 40
      case 1:
        return 100
      case 2:
        return 100
      default:
        return 0
      }
    case 1:
      return 60
    default:
      return 0
    }
  }
  
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section{
    case 0:
      return 0
    case 1:
      return 20
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 1{
      let section = tableView.dequeueReusableCell(withIdentifier: "detailTitle") as! Title_Sumary_Daily_Forecast
      section.detailTitle.text = "Detail"
      return section
    }
    return UIView()
  }
  
}


extension ForecastLocationTableVC: PanModalPresentable{
  var panScrollable: UIScrollView? {
    return tableView
  }
  var shortFormHeight: PanModalHeight{
    return shortHeightFormEnabled ? .contentHeight(260) : longFormHeight
  }
}
