//
//  ColorWarView.swift
//  Glancer
//
//  Created by Henry Price on 9/11/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import SwiftyJSON

class ColorWarView: UIView {
    
    var controller : ColorWarController!
    
    @IBOutlet weak var leadingTeam: UILabel!
    
    @IBOutlet weak var topPlace: UILabel!
    
    @IBOutlet weak var secondPlace: UILabel!
    
    @IBOutlet weak var thirdPlace: UILabel!
    
    @IBOutlet weak var fourthPlace: UILabel!
    
//    let gp = 140
//    let bp = 100
//    let blp = 150
//    let wp = 200
    
//    let teamList = [
//        140 : "GOLD TEAM",
//        100 : "BLUE TEAM",
//        200 : "BLACK TEAM",
//        200 : "WHITE TEAM"
//    ]
    
    let teamList2 = [
        "GOLD TEAM" : 140,
        "BLUE TEAM" : 100,
        "BLACK TEAM" : 200,
        "WHITE TEAM" : 230
        ] as [AnyHashable : Int]
    
    func setupViews() {
//        var pointList = [gp,bp,blp,wp]
        
        
//        print(otherlist)
        
//        for i in otherlist {
//            print(teamList[i])
//        }
        
        var uniqueValues = Set<Int>()
        var resultDict = [AnyHashable:Int](minimumCapacity: teamList2.count)
        
        for (key, value) in teamList2 {
          if !uniqueValues.contains(value) {
            uniqueValues.insert(value)
            resultDict[key] = value
          }
        }
        
        
        
        let otherlist = Array(teamList2.values).sorted(by: >)
        
        let leading = otherlist[0] - otherlist[1]
        
    }
    
}
