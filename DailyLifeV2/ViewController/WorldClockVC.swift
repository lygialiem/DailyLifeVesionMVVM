//
//  WorldClockVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class WorldClockVC: UIViewController {
    
    var stringArray = [String]()
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    let feedback = UINotificationFeedbackGenerator()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stringArray = getUserDefault()
        
        self.myTableView.reloadData()
        
        if stringArray.isEmpty{
            self.navigationItem.leftBarButtonItems = [menuButton]
            self.navigationItem.rightBarButtonItem = addButton
            self.myTableView.setEditing(isEditing, animated: false)
        }else{
            self.navigationItem.rightBarButtonItem = addButton
            self.navigationItem.leftBarButtonItems = [menuButton, editButtonItem]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMoveTabbar), name: NSNotification.Name("MoveToTabbarIndex0"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleMoveTabbar(){
        self.tabBarController?.selectedIndex = 0
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        myTableView.setEditing(!myTableView.isEditing, animated: true)
        
        if editing{
            let deleteAllButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(handleDeleteAllButton))
            navigationItem.rightBarButtonItems = [deleteAllButton]
        } else {
            navigationItem.rightBarButtonItems = [addButton]
        }
    }
    
    @IBAction func menuButtonByPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("OpenOrCloseSideMenu"), object: nil)
    }
    
    @objc func handleDeleteAllButton(){
        self.navigationItem.leftBarButtonItems = [menuButton]
        self.navigationItem.rightBarButtonItem = addButton
        self.isEditing = false
        self.feedback.notificationOccurred(.success)
        self.stringArray = []
        self.setUserDefault()
        self.myTableView.reloadData()
        self.navigationItem.rightBarButtonItem = self.addButton
    }
    
    func setUserDefault(){
        UserDefaults.standard.set(stringArray, forKey: "WorldClock")
        UserDefaults.standard.synchronize()
    }
    
    func getUserDefault() -> [String]{
        guard let userDefault = UserDefaults.standard.value(forKey: "WorldClock") as? [String] else {return [String]()}
        return userDefault
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let typeInfo = R.segue.worldClockVC.listCities(segue: segue){
            let vc = typeInfo.destination
            vc.delegate = self
        }
    }
}

extension WorldClockVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0: return 1
        case 1: return stringArray.count
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cityCell, for: indexPath)!
        switch indexPath.section{
        case 0:
            cell.idTimezone = "GMT"
            return cell
            
        case 1:
            cell.idTimezone = stringArray[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        switch indexPath.section {
        case 0:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.navigationItem.leftBarButtonItems = [menuButton]
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.navigationItem.leftBarButtonItems = [menuButton, editButtonItem]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            stringArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            setUserDefault()
            if stringArray.isEmpty{
                self.navigationItem.leftBarButtonItems = [menuButton]
            } else {
                self.navigationItem.leftBarButtonItems = [menuButton, editButtonItem]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 70
        }else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        switch indexPath.section{
        case 1:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let itemToMove = stringArray[sourceIndexPath.row]
        stringArray.remove(at: sourceIndexPath.row)
        stringArray.insert(itemToMove, at: destinationIndexPath.row)
             tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        setUserDefault()
    }
    
        func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
          
            let desSection = proposedDestinationIndexPath.section
            
            switch desSection{
            case 0:
                return IndexPath(row: 0, section: 1)
            case 1:
                return IndexPath(row: proposedDestinationIndexPath.row, section: proposedDestinationIndexPath.section)
            default:
                return IndexPath()
            }
            
        }
}

extension WorldClockVC: WordClockDidSelect{
    func addWorldClock(timezone: String) {
        
        if !self.stringArray.contains(timezone){
            self.stringArray.append(timezone)
            self.setUserDefault()
            myTableView.insertRows(at: [
                NSIndexPath(row: stringArray.count - 1, section: 1) as IndexPath], with: .automatic)
        }
    }
}



