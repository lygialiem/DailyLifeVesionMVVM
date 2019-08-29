//
//  TabbarController.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/29/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class TabbarController: UITabBar {
  
  private var middleButton = UIButton()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupMiddleButton()
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if self.isHidden {
      return super.hitTest(point, with: event)
    }
    
    let from = point
    let to = middleButton.center
    
    return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 26 ? middleButton : super.hitTest(point, with: event)
  }
  
  func setupMiddleButton() {
    middleButton.frame.size = CGSize(width: 60, height: 60)
    middleButton.backgroundColor = #colorLiteral(red: 0.1568430364, green: 0.1568765342, blue: 0.1568385959, alpha: 1)
    middleButton.setImage(UIImage(named: "search"), for: .normal)
    middleButton.layer.cornerRadius = middleButton.frame.width / 2
    middleButton.layer.masksToBounds = true
    middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
    middleButton.addTarget(self, action: #selector(test), for: .touchUpInside)
    addSubview(middleButton)
  }
  
  @objc func test() {
    NotificationCenter.default.post(name: Notification.Name("OpenSearchVC"), object: nil)
  }
}
