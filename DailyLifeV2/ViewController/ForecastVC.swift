//
//  WeatherVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/20/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastVC: UIViewController {

  @IBOutlet var weatherTableView: UITableView!
  @IBOutlet var detailTableView: UITableView!

  @IBOutlet var visualEffectView: UIVisualEffectView!
  @IBOutlet var searchView: UIView!
  @IBOutlet var searchTextfield: UITextField!
  @IBOutlet var addCityBtn: UIButton!
  @IBOutlet var addCityLabel: UILabel!
  @IBOutlet var detailView: UIView!
  @IBOutlet var snipper: UIActivityIndicatorView!
  @IBOutlet var imageBackground: UIImageView!

  var indexPathDidSelect: IndexPath?
  var forecastData: ForecastApi?
  var hourlyData: HourlyDarkSkyApi?
  var effect: UIVisualEffect!
  let feedback = UINotificationFeedbackGenerator()
  var scrollable = true

  override func viewWillAppear(_ animated: Bool) {

    scrollable = false

    self.addCityBtn.isHidden = true
    self.addCityLabel.isHidden = true
    self.navigationController?.navigationBar.isHidden = true
    snipper.startAnimating()
    LibraryCoreData.instance.fetchCoreDataCountryName { (name) in
      if name.isEmpty {
        DispatchQueue.main.async {
          self.addCityBtn.isHidden = false
          self.addCityLabel.isHidden = false
          self.addCityLabel.text = "Search Your City/Country By Clicking Button Beside"

          self.weatherTableView.isHidden = true

          self.snipper.stopAnimating()
          self.snipper.isHidden = true
        }
      } else {
        LibraryAPI.instance.getCountryForecast(nameOfCountry: name.first?.nameCD ?? "" ) { (data) in
          self.imageBackgroundChangeBasedHour(data: data)

          DispatchQueue.main.async {

            self.forecastData = data

            self.snipper.stopAnimating()
            self.snipper.isHidden = true
          }

          guard let lat = data.location?.lat, let lon = data.location?.lon else {
            print("ERROR")
            return
          }

          LibraryAPI.instance.getHourlyForecast(latitude: lat, longitude: lon) { (data) in

            DispatchQueue.main.async {
              self.hourlyData = data
              self.weatherTableView.dataSource = self
              self.weatherTableView.reloadData()

              self.addCityLabel.isHidden = true
              self.addCityBtn.isHidden = true

              self.feedback.notificationOccurred(.success)
            }
          }
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    setupSearchCityView()
    setupTapToDimiss()

    self.searchTextfield.delegate = self
    self.navigationController?.navigationBar.isHidden = true
    self.tabBarController?.delegate = self
    self.tabBarController?.tabBar.backgroundColor = .clear

    NotificationCenter.default.addObserver(self, selector: #selector(handleMoveTabbar), name: .MoveToTabbarIndex0, object: nil)

    weatherTableView.register(R.nib.detailForecastCell)
    detailTableView.register(R.nib.detailForecastCell)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  func imageBackgroundChangeBasedHour(data: Any?) {
    guard let data = data as? ForecastApi else {return}

    guard let StringCurrentHour = data.location?.localtime?.changeFormatTime(from: "YYYY-MM-dd HH:mm", to: "H") else {return}

    let currentHour = Int(StringCurrentHour) ?? 0

    DispatchQueue.main.async {
      switch currentHour {
      case 0..<2:
        self.imageBackground.image = R.image.solarGradients1()
      case 2..<3:
        self.imageBackground.image = R.image.solarGradients2()
      case 3..<4:
        self.imageBackground.image = R.image.solarGradients3()
      case 4..<5:
        self.imageBackground.image = R.image.solarGradients4()
      case 5..<7:
        self.imageBackground.image = R.image.solarGradients5()
      case 7..<8:
       self.imageBackground.image = R.image.solarGradients6()
      case 8..<10:
        self.imageBackground.image = R.image.solarGradients7()
      case 10..<12:
       self.imageBackground.image = R.image.solarGradients8()
      case 12..<14:
        self.imageBackground.image = R.image.solarGradients9()
      case 14..<15:
        self.imageBackground.image = R.image.solarGradients10()
      case 15..<16:
        self.imageBackground.image = R.image.solarGradients11()
      case 16..<17:
        self.imageBackground.image = R.image.solarGradients12()
      case 17..<18:
        self.imageBackground.image = R.image.solarGradients13()
      case 18..<19:
        self.imageBackground.image = R.image.solarGradients14()
      case 19..<22:
        self.imageBackground.image = R.image.solarGradients15()
      case 22...23:
        self.imageBackground.image = R.image.solarGradients16()

      default:
        break
      }
    }
  }

  @objc func handleMoveTabbar() {
    self.tabBarController?.selectedIndex = 0
  }

  @IBAction func addCityBtnAction(_ sender: Any) {
    animationIn(searchView)
  }
  func setupTapToDimiss() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.visualEffectView.addGestureRecognizer(tap)
  }

  @objc func handleTap() {
    self.searchTextfield.resignFirstResponder()
    animationOut(searchView)
    animationOut(detailView)
  }

  func setupSearchCityView() {
    effect = visualEffectView.effect
    visualEffectView.isHidden = true
    visualEffectView.effect = nil

  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  func  setupTableView() {

    weatherTableView.delegate = self
    weatherTableView.dataSource = nil

    detailTableView.delegate = self
    detailTableView.dataSource = nil

  }
  @IBAction func searchBtn(_ sender: Any) {
    animationIn(searchView)
  }

  @IBAction func cancelSearchCityBtn(_ sender: Any) {
    searchTextfield.resignFirstResponder()
    animationOut(searchView)
  }

  func animationIn(_ viewToShow: UIView) {
    visualEffectView.isHidden = false
    self.view.addSubview(viewToShow)

    viewToShow.frame.origin.x = (self.view.frame.width - viewToShow.frame.width) / 2
    viewToShow.frame.origin.y = (self.view.frame.height - viewToShow.frame.height ) / 2

    viewToShow.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    viewToShow.layer.borderWidth = 1
    viewToShow.clipsToBounds = true
    viewToShow.layer.cornerRadius = 15
    viewToShow.alpha = 0
    searchTextfield.becomeFirstResponder()

    UIView.animate(withDuration: 0.15) {
      self.visualEffectView.effect = self.effect
      viewToShow.alpha = 1
      viewToShow.transform = CGAffineTransform.identity
    }
  }

  func animationOut(_ viewToShow: UIView) {
    UIView.animate(withDuration: 0.075, animations: {
      viewToShow.alpha = 0
      self.visualEffectView.effect = nil
      self.visualEffectView.isHidden = true
    }) {(_) in
      viewToShow.removeFromSuperview()
    }
  }

  func saveCountryNameToCoreDate(nameToSave: String?) {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let manager = delegate.persistentContainer.viewContext
    let coreData = CountrySearching(context: manager)

    coreData.nameCD = nameToSave

    do {
      try manager.save()
    } catch {
      debugPrint("Can't Save Country Name To CoreData")
    }
  }
}

extension ForecastVC: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {

    if tableView.tag == 0 {
      return 6
    } else {
      return 1
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if tableView.tag == 0 {
      switch section {
      case 0:
        return 1
      case 1:
        return 1
      case 2:
        return self.forecastData?.forecast?.forecastday?.count ?? 0
      case 3:
        return 1
      case 4:
        return 6
      case 5:
        return 0
      default:
        return Int()
      }
    } else {
      switch section {
      case 0:
        return 8
      default:
        return 0
      }
    }
  }
    
    //Feature1.......

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if tableView.tag == 0 {
      switch indexPath.section {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell0, for: indexPath)!
        cell.configureCell(forecast: self.forecastData)
        return cell
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell1, for: indexPath)!
        cell.hourlyData = self.hourlyData
        cell.forecastHourlyCollectionView.dataSource = cell
        DispatchQueue.main.async {
          cell.forecastHourlyCollectionView.reloadData()
        }
        return cell
      case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell2, for: indexPath)!
        cell.configureCell(forecastDay: self.forecastData?.forecast?.forecastday?[indexPath.row])
        return cell
      case 3:
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell3, for: indexPath)!
        cell.summary.text = "Today: \(forecastData?.current?.condition?.text ?? "") currently. The high temperature will be \((forecastData?.forecast?.forecastday?[0].day?.maxtemp_c ?? 0).roundInt())ºC. Cloudy tonight with a low temperature of \(String(describing: (forecastData?.forecast?.forecastday?[0].day?.mintemp_c ?? 0).roundInt()))ºC"
        return cell

      case 4:
        let detailForecastCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.detailForecastCell, for: indexPath)!

        switch indexPath.row {
        case 0:

          detailForecastCell.title1.text = "Sunrise"
          detailForecastCell.title2.text = "Sunset"
          detailForecastCell.para1.text = forecastData?.forecast?.forecastday?[0].astro?.sunrise ?? ""
          detailForecastCell.para2.text = forecastData?.forecast?.forecastday?[0].astro?.sunset ?? ""

          return detailForecastCell

        case 1:
          detailForecastCell.title1.text = "Moonrise"
          detailForecastCell.title2.text = "Moonset"
          detailForecastCell.para1.text = forecastData?.forecast?.forecastday?[0].astro?.moonrise ?? ""
          detailForecastCell.para2.text = forecastData?.forecast?.forecastday?[0].astro?.moonset ?? ""
          return detailForecastCell

        case 2:
          detailForecastCell.title1.text = "Precipitation"
          detailForecastCell.title2.text = "Humidity"
          detailForecastCell.para1.text = "\(forecastData?.current?.precip_mm ?? 0) mm/h"
          detailForecastCell.para2.text = "\(Int(forecastData?.current?.humidity ?? 0))%"
          return detailForecastCell

        case 3:
          detailForecastCell.title1.text = "Wind"
          detailForecastCell.title2.text = "Feels Like"
          detailForecastCell.para1.text = "\(forecastData?.current?.wind_dir ?? "") \(forecastData?.current?.wind_kph ?? 0) km/h"
          detailForecastCell.para2.text = "\((forecastData?.current?.feelslike_c ?? 0).roundInt())ºC"
          return detailForecastCell

        case 4:
          detailForecastCell.title1.text = "Wind Gust"
          detailForecastCell.title2.text = "Pressure"
          detailForecastCell.para1.text = "\(forecastData?.current?.gust_kph ?? 0) km/h"
          detailForecastCell.para2.text = "\(forecastData?.current?.pressure_mb ?? 0) hPa"
          return detailForecastCell

        case 5:
          detailForecastCell.title1.text = "Visibility"
          detailForecastCell.title2.text = "UV Index"
          detailForecastCell.para1.text = "\(forecastData?.current?.vis_km ?? 0) km"
          detailForecastCell.para2.text = "\(Int(forecastData?.current?.uv ?? 0))"
          return detailForecastCell

        default:
          return UITableViewCell()
        }
      default:
        return UITableViewCell()
      }
    } else if tableView.tag == 1 {
        let detailDailyForecasrCell = tableView.dequeueReusableCell(withIdentifier: "DetailForecastCell") as! DetailForecastCelll
      guard let indexPathDidSelected = indexPathDidSelect else {return UITableViewCell()}
      switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.dateCell, for: indexPath)!
        guard let indexPath = indexPathDidSelect else {return UITableViewCell()}
        cell.dateForecast.text = "\((forecastData?.forecast?.forecastday?[indexPath.row].date ?? "").changeFormatTime(from: "YYYY-MM-dd", to: "MMMM dd, YYYY"))"
        return cell

      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.summaryCell, for: indexPath)!
        guard let indexPath = indexPathDidSelect else {return UITableViewCell()}
        cell.summary.text = "\((forecastData?.forecast?.forecastday?[indexPath.row].day?.condition?.text ?? "").capitalized)"
        return cell

      case 2:

        detailDailyForecasrCell.title1.text = "Sunrise"
        detailDailyForecasrCell.title2.text = "Sunset"
        detailDailyForecasrCell.para1.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].astro?.sunrise ?? "")"
        detailDailyForecasrCell.para2.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].astro?.sunset ?? "")"
        return detailDailyForecasrCell

      case 3:
        detailDailyForecasrCell.title1.text = "Moonrise"
        detailDailyForecasrCell.title2.text = "Moonset"
        detailDailyForecasrCell.para1.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].astro?.moonrise ?? "")"
        detailDailyForecasrCell.para2.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].astro?.moonset ?? "")"
        return detailDailyForecasrCell

      case 4:
        detailDailyForecasrCell.title1.text = "Highest Temp"
        detailDailyForecasrCell.title2.text = "Lowest Temp"
        detailDailyForecasrCell.para1.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].day?.maxtemp_c ?? 0)ºC"
        detailDailyForecasrCell.para2.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].day?.mintemp_c ?? 0)ºC"
        return detailDailyForecasrCell

      case 5:
        detailDailyForecasrCell.title1.text = "Avg Temp"
        detailDailyForecasrCell.title2.text = "Precipitation"
        detailDailyForecasrCell.para1.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].day?.avgtemp_c ?? 0)ºC"
        detailDailyForecasrCell.para2.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].day?.totalprecip_mm ?? 0) mm/h"
        return detailDailyForecasrCell

      case 6:
        detailDailyForecasrCell.title1.text = "Wind Gust"
        detailDailyForecasrCell.title2.text = "Humidity"
        detailDailyForecasrCell.para1.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].day?.maxwind_kph ?? 0) km/h"
        detailDailyForecasrCell.para2.text = "\(Int(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].day?.avghumidity ?? 0)) %"
        return detailDailyForecasrCell

      case 7:
        detailDailyForecasrCell.title1.text = "Visibility"
        detailDailyForecasrCell.title2.text = "UV Index"
        detailDailyForecasrCell.para1.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].day?.avgvis_km ?? 0) km"
        detailDailyForecasrCell.para2.text = "\(forecastData?.forecast?.forecastday?[indexPathDidSelected.row].day?.uv ?? 0)"
        return detailDailyForecasrCell
      default:
        return UITableViewCell()
      }
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if tableView.tag == 0 {
      switch section {
      case 0:

        let header = tableView.dequeueReusableCell(withIdentifier: "header0")
        return header
      case 1:
        let header = tableView.dequeueReusableCell(withIdentifier: "header1") as! SearchForecast
        header.hourlyTitleHeader.text = "Hourly"
        return header
      case 2:
        let header = tableView.dequeueReusableCell(withIdentifier: "header2") as! SearchForecast
        header.dailyTitleHeader.text = "Daily"
        return header
      case 3:
        let header = tableView.dequeueReusableCell(withIdentifier: "header3") as! SearchForecast
        header.summaryTitleHeader.text = "Summary"
        return header
      case 4:
        let header = tableView.dequeueReusableCell(withIdentifier: "header4") as! SearchForecast
        header.detailTitleHeader.text = "Detail"
        return header
      case 5:
        let header = tableView.dequeueReusableCell(withIdentifier: "header5") as! SearchForecast
        header.delegate = self
        return header
      default:
        return UIView()
      }
    }
    return UIView()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    if tableView.tag == 0 {
      switch indexPath.section {
      case 0:
        return 170
      case 1:
        return 100
      case 2:
        return 40
      case 3:
        return UITableView.automaticDimension
      case 4:
        return 60
      case 5:
        return 0
      default:
        return CGFloat()
      }
    } else {
      switch indexPath.row {
      case 0: return 20
      case 1: return UITableView.automaticDimension
      default: return 50
      }
    }
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

    if tableView.tag == 0 {
      switch section {
      case 0:
        return 0
      case 5:
        return 40
      default:
        return 20
      }
    } else {
      return 0
    }
  }

  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    view.tintColor = .clear
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.tag == 0 {
      switch indexPath.section {
      case 2:
        indexPathDidSelect = indexPath
        self.detailTableView.dataSource = self
        self.detailTableView.reloadData()

        self.animationIn(detailView)
      default: break
      }
    } else {

    }
  }
}

//Feature1


extension ForecastVC: moveToWebVC {
  func moveToWebVCFromWeatherVC(url: String) {
    let webVC = UIStoryboard(name: "WebViewController", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewController
    webVC.urlOfContent = url
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.pushViewController(webVC, animated: true)
  }
}

extension ForecastVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.snipper.isHidden = false
    self.snipper.startAnimating()
    self.addCityBtn.isHidden = true
    self.addCityLabel.isHidden = true
    self.weatherTableView.isHidden = true

    LibraryCoreData.instance.fetchCoreDataCountryName { (countryName) in
      guard (countryName.first?.nameCD) != nil else {return}
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
      let managedContext = appDelegate.persistentContainer.viewContext
      managedContext.delete(countryName.first!)
      do {
        try managedContext.save()
      } catch {
        print("Cannot Save")
      }
    }

    LibraryAPI.instance.getCountryForecast(nameOfCountry: textField.text ?? "") { (data) in

      if data.error != nil {
        DispatchQueue.main.async {

          self.weatherTableView.dataSource = self
          self.weatherTableView.reloadData()
          self.weatherTableView.isHidden = true

          self.addCityBtn.isHidden = false
          self.addCityLabel.isHidden = false
          self.addCityLabel.text = data.error?.message?.capitalized ?? ""

          self.snipper.stopAnimating()
          self.snipper.isHidden = true
        }
      } else {

        self.imageBackgroundChangeBasedHour(data: data)

        DispatchQueue.main.async {
          self.forecastData = data
          self.weatherTableView.dataSource = self
          self.weatherTableView.reloadData()
          self.addCityBtn.isHidden = true
          self.addCityLabel.isHidden = true
        }

        guard let lat = data.location?.lat, let lon = data.location?.lon else {return}

        LibraryAPI.instance.getHourlyForecast(latitude: lat, longitude: lon) { (data) in
          DispatchQueue.main.async {
            self.saveCountryNameToCoreDate(nameToSave: textField.text)
            self.weatherTableView.isHidden = false
            self.weatherTableView.dataSource = self
            self.weatherTableView.reloadData()
            self.hourlyData = data
            self.snipper.stopAnimating()
            self.snipper.isHidden = true
          }
        }
      }
    }

    self.feedback.notificationOccurred(.success)
    self.animationOut(self.searchView)
    textField.resignFirstResponder()
    self.weatherTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.weatherTableView.frame.width, height: self.weatherTableView.frame.height), animated: true)

    return true
  }
}

extension ForecastVC: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    if tabBarController.selectedIndex == 2 {
      if scrollable == false {
        scrollable = true
      } else {
        self.weatherTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20), animated: true)
      }
    }
  }
}
