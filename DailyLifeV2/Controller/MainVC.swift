//
//  MainVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreLocation
import PanModal


class MainVC: ButtonBarPagerTabStripViewController {
  
  @IBOutlet var temperatureButton: UIButton!
  @IBOutlet var visualEffectView: UIVisualEffectView!
  @IBOutlet var snipper: UIActivityIndicatorView!
  @IBOutlet var btnBarView: UIView!
  @IBOutlet var apiOutOfDate: UILabel!
  
  var isWeatherOpen = false
  var pageVCArray = [PageVC]()
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  var effect: UIVisualEffect!
  var forecastData: DarkSkyApi?
  var detailGPS: ReversedGeoLocation?
  
  var newestLocaton: ((CLLocation?) -> Void)?
  var statusUpdated: ((CLAuthorizationStatus?) -> Void)?
  var status: CLAuthorizationStatus{
    return CLLocationManager.authorizationStatus()
  }
  
  var dataResponseWeather: ((DarkSkyApi)-> Void)?
  let manager = CLLocationManager()
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(moveToTopic(notification:)), name: NSNotification.Name("MoveToTopic"), object: nil)
    
    setUpCoreLocation()
  }
  
  override func viewDidLoad() {
    
    temperatureButton.isEnabled = false
    
    configureButtonBar()
    super.viewDidLoad()
    
    snipper.hidesWhenStopped = true
    snipper.startAnimating()
    
    effect = visualEffectView.effect
    visualEffectView.isHidden = true
    visualEffectView.effect = nil
    
    NotificationCenter.default.addObserver(self, selector: #selector(OpenSearchVC), name: NSNotification.Name("OpenSearchVC"), object: nil)
    
    btnBarView.clipsToBounds = true
    btnBarView.layer.cornerRadius = 12
    btnBarView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    btnBarView.layer.borderWidth = 2
    btnBarView.frame(forAlignmentRect: CGRect(x: 250, y: 30, width: 300, height: 30))
    
    temperatureButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    temperatureButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    
    
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func OpenSearchVC(){
    guard let storyboard  = storyboard else {return}
    let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
    self.presentPanModal(searchVC)
    
  }
  
  @objc func moveToTopic(notification: Notification){
    let indexPath = notification.userInfo?["data"] as! IndexPath
    self.moveToViewController(at: indexPath.row, animated: false)
    
  }
  
  func setUpCoreLocation(){
    if CLLocationManager.locationServicesEnabled(){
      manager.delegate = self
      manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
      manager.startUpdatingLocation()
      
      self.newestLocaton = { [weak self] (location) in
        guard let wSelf = self, let location = location else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
          if error == nil{
            guard let placeMark = placeMarks?.first else {return}
            
            let reveresGeoCoder = ReversedGeoLocation(with: placeMark)
            self?.detailGPS = reveresGeoCoder
          }
        })
        
        WeatherApiService.instance.getWeatherApi(latitude: latitude, longitude: longitude) { (dataResponse) in
          wSelf.dataResponseWeather?(dataResponse)
          
          wSelf.forecastData = dataResponse
          guard let temper = dataResponse.currently?.temperature else {
            return
          }
          DispatchQueue.main.async {
            wSelf.temperatureButton.setTitle("\(round(temper * 10) / 10)°C", for: .normal)
             wSelf.temperatureButton.isEnabled = true
          }
         
          wSelf.manager.stopUpdatingLocation()
        }
      }
    }
  }
  
  
  @IBAction func searchButtonAction(_ sender: Any) {
    let searchVc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
    
    presentPanModal(searchVc)
    
  }
  
  
  
  func configureButtonBar() {
    settings.style.selectedBarHeight = 4
    settings.style.selectedBarBackgroundColor = #colorLiteral(red: 1, green: 0.765712738, blue: 0.0435429886, alpha: 1)
    settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.1568458378, green: 0.1568738818, blue: 0.1568369865, alpha: 1)
    settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 0.1568458378, green: 0.1568738818, blue: 0.1568369865, alpha: 1)
    settings.style.buttonBarMinimumInteritemSpacing = 0
    settings.style.buttonBarItemFont = UIFont(name: "Helvetica Neue", size: 15)!
    settings.style.buttonBarItemTitleColor = .red
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    settings.style.buttonBarHeight = 30
    settings.style.selectedBarVerticalAlignment = .bottom
    
    // Changing item text color on swipe
    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = .white
      newCell?.label.textColor = .white
    }
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    for i in 0..<NewsApiService.instance.TOPIC_NEWSAPI.count{
      let pageVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerID") as! PageVC
      
      pageVC.menuBarTitle = NewsApiService.instance.TOPIC_NEWSAPI[i]
      DispatchQueue.main.async {
        NewsApiService.instance.getArticles(topic: NewsApiService.instance.TOPIC_NEWSAPI[i], page: 3,numberOfArticles: 10) { (dataApi) in
          
          if dataApi.status == "error"{
            self.snipper.stopAnimating()
            self.apiOutOfDate.isHidden = false
            self.apiOutOfDate.text = "Your Api Is Out Of Date"
          }
          pageVC.articlesOfConcern = dataApi.articles
          
        }
        self.apiOutOfDate.isHidden = true
      }
      
      
      NewsApiService.instance.getArticles(topic: NewsApiService.instance.TOPIC_NEWSAPI[i], page: 1, numberOfArticles: 20) {(dataApi) in
        
        pageVC.articles = dataApi.articles
        if i == 0 {
          DispatchQueue.main.async {
            pageVC.newsFeedCV.reloadData()
            self.snipper.stopAnimating()
          }
        }
      }
      pageVCArray.append(pageVC)
    }
    return pageVCArray
  }

  
  @IBAction func openMenuPressed(_ sender: Any) {
    NotificationCenter.default.post(name: NSNotification.Name("OpenOrCloseSideMenu"), object: nil)
  }
  
  @IBAction func weatherButtonByPressed(_ sender: Any) {

    let forecastLocationVC = storyboard?.instantiateViewController(withIdentifier: "ForecastLocationTableVC") as! ForecastLocationTableVC
    forecastLocationVC.dataForecast = self.forecastData
    forecastLocationVC.detailGPS = self.detailGPS
    DispatchQueue.main.async {
      forecastLocationVC.tableView.reloadData()
    }
    self.presentPanModal(forecastLocationVC)

  }
  
  func animateVisualEffectOUT(){
    self.visualEffectView.effect = nil
    self.visualEffectView.isHidden = true
  }
  
  func animateVisualEffectIN(){
    self.visualEffectView.effect = self.effect
    self.visualEffectView.isHidden = false
  }
}


extension MainVC: CLLocationManagerDelegate{
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.sorted(by: {$0.timestamp > $1.timestamp}).first else {
      self.newestLocaton?(nil)
      return
    }
    self.newestLocaton?(location)
  }
  
  private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    debugPrint("Fail to get Location")
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("Location Status:",status)
    self.statusUpdated?(status)
  }
}
