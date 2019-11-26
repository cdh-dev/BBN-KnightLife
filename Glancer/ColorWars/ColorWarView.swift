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
        
//        print(teamList[Int(otherlist[0])]!)
//        \(teamList2[Int(otherlist[0])]!)
        
        if leading != 0 {
            self.leadingTeam.text = "A TEAM IS LEADING BY \(leading) POINTS"
        }
        else {
            self.leadingTeam.text = "ALL TIED"
        }
        
//        pointList.sort(by: >)
        
//        print(pointList[0] - pointList[1])
//        let leading = pointList[0] - pointList[1]
        
        
//        let pointLead = pointList.max()
        
//        if gp == pointList[0] {
//            self.leadingTeam.text = "Gold team is leading by \(leading) points"
//        }
//
//        if bp == pointList[0] {
//            self.leadingTeam.text = "Blue team is leading by \(leading) points"
//        }
//
//        if blp == pointList[0] {
//            self.leadingTeam.text = "Blue team is leading by \(leading) points"
//        }
//
//        if wp == pointList[0] {
//            self.leadingTeam.text = "White team is leading by \(leading) points"
//        }
//
//        else {
//            self.leadingTeam.text = "All tied up"
//        }
        
    }
    
}
