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

  override func viewDidLoad() {
    super.viewDidLoad()
    configureMenuCollectionView()
  }
  @IBAction func CloseMenuByPressed(_ sender: Any) {
    NotificationCenter.default.post(name: NSNotification.Name("OpenSideMenu"), object: nil)
  }

  func configureMenuCollectionView() {
    menuCollectionView.delegate = self
    menuCollectionView.dataSource = self
  }
}

extension SideMenuVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ApiServices.instance.TOPIC_NEWSAPI.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellOfSideMenu", for: indexPath) as!
  }

}
