//
//  SearchVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/29/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import PanModal

class SearchVC: UITableViewController{
  
  var shortHeightFormEnabled = true
  @IBOutlet var mySearchBar: UISearchBar!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.mySearchBar.delegate = self
      
      
    }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 30
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    cell?.backgroundColor = (indexPath .row % 2 == 0) ? .blue : .yellow
    return cell ?? UITableViewCell()
  }
}


extension SearchVC: PanModalPresentable{
  var panScrollable: UIScrollView?{
    return tableView
  }
  
  var shortFormHeight: PanModalHeight{
    return shortHeightFormEnabled ? .contentHeight(300) : longFormHeight
  }
}


extension SearchVC: UISearchBarDelegate{
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
  }
}
