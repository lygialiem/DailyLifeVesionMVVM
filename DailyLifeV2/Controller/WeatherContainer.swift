//
//  WeatherContainer.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/20/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class WeatherContainer: UIViewController {
  
  @IBOutlet var detailWeatherTableView: UITableView!
  @IBOutlet var titleWeather: UILabel!
  @IBOutlet var panBar: UIView!
  @IBOutlet var handleAreaBar: UIView!
  @IBOutlet var myImageBackground: UIImageView!
  
  var longitude: Double?
  var latitude: Double?
  var time: Int?
  var summary: String?
  var temperature: Double?
  var apparentTemperature: Double?
  var humidity: Double?
  var pressure: Double?
  var nearestStormDistance: Double?
  var precipIntensity: Double?
  var precipType: String?
  var precipProbability: Double?
  var dewPoint: Double?
  var windBearing: Double?
  var ozone: Double?
  var cloudCover: Double?
  var visibility: Double?
  var uvIndex: Double?
  var icon: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupTableView()
    setupPanBar()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  
  }
  
  func setupPanBar(){
    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanBar(gesture:)))
    self.handleAreaBar.addGestureRecognizer(pan)
  }
  
  @objc func handlePanBar(gesture: UIPanGestureRecognizer){
    
    NotificationCenter.default.post(name: NSNotification.Name("HandleAreaBar"), object: nil, userInfo: ["data": gesture])
  }
  
  func setupTableView(){
    self.detailWeatherTableView.delegate = self
    self.detailWeatherTableView.dataSource = nil
    self.detailWeatherTableView.estimatedRowHeight = 30
  }
  
  func setupView(){
    self.view.clipsToBounds = true
    self.view.layer.cornerRadius = 20
    self.view.layer.masksToBounds = true
    self.view.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
  }
}

extension WeatherContainer: UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return WeatherApiService.instance.weatherTitles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! WeatherContainerCell
    switch indexPath.row {
      
    case 0:
      let date = Calendar.current.date(byAdding: .calendar, value: time ?? 0, to: Date())
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMMM dd, yyyy"
      if let datee = date {
        let timeFormattered = dateFormatter.string(from: datee)
        cell.descriptionWeather.text = "\(timeFormattered)"
        cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
        cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
        cell.iconWeather.tintColor = .white
        return cell
      }
      
    case 1:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = summary!.capitalized
      cell.iconWeather.image = UIImage(named: "\(icon!)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 2:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(round((latitude ?? 0) * 1000) / 1000)°"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 3:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(round((longitude ?? 0) * 1000) / 1000)°"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 4:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(round(temperature ?? 0))°C"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 5:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(((humidity ?? 0) * 100).roundInt()) %"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 6:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(pressure ?? 0) hPa"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 7:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(0) km"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 8:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(precipIntensity ?? 0) mm/h"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 9:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(precipType ?? "None")"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 10:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(((precipProbability ?? 0) * 100).roundInt()) % "
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 11:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(dewPoint ?? 0)°C"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 12:
    cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(windBearing ?? 0)°"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 13:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(ozone ?? 0) DU"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 14:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(((cloudCover ?? 0) * 100).roundInt()) %"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 15:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(visibility ?? 0) km"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    case 16:
      cell.titleWeather.text = WeatherApiService.instance.weatherTitles[indexPath.row].capitalized
      cell.descriptionWeather.text = "\(uvIndex ?? 0)"
      cell.iconWeather.image = UIImage(named: "\(indexPath.row)")?.withRenderingMode(.alwaysTemplate)
      return cell
      
    default:
      break
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
