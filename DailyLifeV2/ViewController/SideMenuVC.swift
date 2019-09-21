//
//  MenuVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {
  
  @IBOutlet var menuCollectionView: UICollectionView!
  @IBOutlet var visualEffectView: UIVisualEffectView!
  @IBOutlet var myTextField: UITextField!
  @IBOutlet var blurEffectView: UIVisualEffectView!
  @IBOutlet var addView: UIView!
  
  var effect: UIVisualEffect!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureMenuCollectionView()
    closeSideMenuByPan()
    configureAddView()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector
      (handleTapToDimissAddView))
    self.visualEffectView.addGestureRecognizer(tap)
  }
  
  func  configureAddView(){
    effect = visualEffectView.effect
    visualEffectView.isHidden = true
    visualEffectView.effect = nil
    addView.layer.cornerRadius = 10
  }
  
  func closeSideMenuByPan(){
    let panEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(gesture:)))
    panEdge.edges = .right
    view.addGestureRecognizer(panEdge)
  }
  
  func animateAddViewIn(){
    visualEffectView.isHidden = false
    self.view.addSubview(addView)
    addView.frame.origin.x = (self.view.frame.width - addView.frame.width) / 2
    addView.frame.origin.y = 20 + 44 + 30
    addView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    addView.layer.borderWidth = 2
    addView.alpha = 0
    myTextField.becomeFirstResponder()
    
    UIView.animate(withDuration: 0.5) {
      self.visualEffectView.effect = self.effect
      self.addView.alpha = 1
      self.addView.transform = CGAffineTransform.identity
    }
  }
  
  func animateAddViewOut(){
    UIView.animate(withDuration: 0.5, animations: {
      self.visualEffectView.effect = nil
      self.addView.alpha = 0
      self.visualEffectView.isHidden = true
    }) { (success) in
      self.addView.removeFromSuperview()
    }
  }
  
  func configureMenuCollectionView(){
    menuCollectionView.delegate = self
    menuCollectionView.dataSource = self
    menuCollectionView.showsVerticalScrollIndicator = false
  }
}

extension SideMenuVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return LibraryAPI.instance.TOPIC_NEWSAPI.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellOfSideMenu", for: indexPath) as! SideMenuCell

      cell.imageName = LibraryAPI.instance.TOPIC_NEWSAPI[indexPath.row]
      cell.topicName = LibraryAPI.instance.TOPIC_NEWSAPI[indexPath.row]
      return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (self.view.frame.width - 15 - 15 - 15) / 2
    return CGSize(width: width, height: width * 40 / 33)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15
    
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

      NotificationCenter.default.post(name: NSNotification.Name("MoveToTopic"), object: nil, userInfo: ["data": indexPath])
      NotificationCenter.default.post(name: NSNotification.Name("OpenOrCloseSideMenu"), object: nil)
      NotificationCenter.default.post(name: NSNotification.Name("MoveToTabbarIndex0"), object: nil)
  }
}

// @objc function:
extension SideMenuVC{
  @objc func handleEdgePan(gesture: UIScreenEdgePanGestureRecognizer){
    NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenyByEdgePan"), object: nil, userInfo: ["data": gesture])
    
  }
  
  @objc func handleTapToDimissAddView(){
    myTextField.resignFirstResponder()
    animateAddViewOut()
  }
}

// Button Action:

extension SideMenuVC{
  
  @IBAction func CloseMenuByPressed(_ sender: Any) {
    NotificationCenter.default.post(name: NSNotification.Name("OpenOrCloseSideMenu"), object: nil)
  }
  
  
  @IBAction func AddNewTopicButton(_ sender: Any) {
    animateAddViewIn()
  }
  
  
  @IBAction func cancleButton(_ sender: Any) {
    myTextField.resignFirstResponder()
    animateAddViewOut()
  }
}
