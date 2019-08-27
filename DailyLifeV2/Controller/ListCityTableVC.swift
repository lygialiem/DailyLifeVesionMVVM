//
//  ListCityTableVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

protocol WordClockDidSelect{
  func addWorldClock(timezone: String)
}

struct Section {
  let letter : String
  let names : [String]
}

class ListCityTableVC: UITableViewController, UISearchResultsUpdating{
  
  var filterContents = [Section]()
  var delegate: WordClockDidSelect?
  
  let searchController = UISearchController(searchResultsController: nil)
  
  var sections = [Section]()
  var nameTemp = [String]()
  var arrayName = [Section]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.dataSource = nil
    
    setupListCities()
    setupSearchController()
    
  }
  
  func setupSearchController(){
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Typing Your City Here"
    definesPresentationContext = true
    searchController.searchBar.backgroundColor = #colorLiteral(red: 0.1569153368, green: 0.1569378376, blue: 0.156902343, alpha: 1)
    searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 0.765712738, blue: 0.0435429886, alpha: 1)
    searchController.searchBar.barTintColor = .darkGray
    searchController.searchBar.barStyle = .blackTranslucent
  }
  
  func  setupListCities(){
    
    var array = [[String.SubSequence]()]
    var stringArray = [String]()
    let cityName = TimeZone.knownTimeZoneIdentifiers
    
    for i in 0..<cityName.count{
      array.append(cityName[i].split(separator: "/").reversed())
      stringArray.append(array[i].joined(separator: ", "))
    }
    
    let groupedDictionary = Dictionary(grouping: stringArray, by: {String($0.prefix(1))})
    
    let keys = groupedDictionary.keys.sorted()
    sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted()) }
    
    sections.remove(at: 0)
    
    self.tableView.dataSource = self
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering(){
      return filterContents[section].names.count
    }
    
    return sections[section].names.count
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    if isFiltering(){
      return filterContents.count
    }
    return sections.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! listCityNameCell
    
    if isFiltering(){
      cell.textLabel?.text = filterContents[indexPath.section].names[indexPath.row].replacingOccurrences(of: "_", with: " ")
      cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      return cell
    }
    
    cell.textLabel?.text = sections[indexPath.section].names[indexPath.row].replacingOccurrences(of: "_", with: " ")
    cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].letter
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
    if isFiltering(){
      let cityName = filterContents[indexPath.section].names[indexPath.row]
      let replacedCityName = cityName.replacingOccurrences(of: ", ", with: "/")
      let IDCityName = replacedCityName.split(separator: "/")
      let reveredCityName = IDCityName.reversed()
      let joinedCityName = reveredCityName.joined(separator: "/")
      self.delegate?.addWorldClock(timezone: joinedCityName)
      self.navigationController?.popViewController(animated: true)
    } else {
      
      let cityName = sections[indexPath.section].names[indexPath.row]
      let replacedCityName = cityName.replacingOccurrences(of: ", ", with: "/")
      let IDCityName = replacedCityName.split(separator: "/")
      let reveredCityName = IDCityName.reversed()
      let joinedCityName = reveredCityName.joined(separator: "/")
      
      self.delegate?.addWorldClock(timezone: joinedCityName)
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearch(searchController.searchBar.text!)
    self.tableView.reloadData()
    
  }
  
  func filterContentForSearch(_ searchText: String, scope: String = "All"){
    self.filterContents = sections.filterBy(keyword: searchText.replacingOccurrences(of: " ", with: "_"))
  }
  
  func isFiltering() -> Bool {
    return self.searchController.isActive && !searchBarIsEmpty()
  }
  
  func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
}



extension String {
  func matchKeyword(keyword: String) -> Bool {
    return self.lowercased().contains(keyword.lowercased())
  }
}

extension Section {
  func isIncludeKeyWord(keyword: String) -> Bool {
    return names.contains { $0.matchKeyword(keyword: keyword) }
  }
  func filteredNames(keyword: String) -> [String] {
    return names.filter({ $0.matchKeyword(keyword: keyword) })
  }
}
extension Array where Element == Section {
  func filterBy(keyword: String) -> [Section] {
    return self.filter({ $0.isIncludeKeyWord(keyword: keyword) })
      .map({ section in
        Section.init(letter: section.letter, names: section.filteredNames(keyword: keyword))
      })
  }
}
