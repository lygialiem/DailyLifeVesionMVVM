//
//  Memento.swift
//  DailyLifeV2
//
//  Created by Liem Ly Gia on 9/19/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import UIKit

protocol Memento{
    var stateName: String {get}
    var cityID: String{get set}
    
    func save()
    
    func restore()
    
    func persist()
    
    func recover()
    
}

extension Memento{
    func save(){
        UserDefaults.standard.set(cityID, forKey: stateName)
    }
    
   mutating func restore(){
        if let cityName = UserDefaults.standard.string(forKey: stateName){
            self.cityID = cityName
        } else {
            self.cityID = ""
        }
    }
}
