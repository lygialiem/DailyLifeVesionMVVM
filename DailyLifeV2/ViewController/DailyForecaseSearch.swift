//
//  DailyForecaseSearch.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/29/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class DailyForecaseSearch: UITableViewCell {

  @IBOutlet var myCollectionView: UICollectionView!
  var dailyForecast: Daily?
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    myCollectionView.delegate = self
    myCollectionView.dataSource = self
    
    }
}

extension DailyForecaseSearch: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dailyForecast?.data?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.collectionCell, for: indexPath)!
    
    cell.configureCell(data: (dailyForecast?.data?[indexPath.row])!)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }
}
