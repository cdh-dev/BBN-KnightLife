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
    
    @IBOutlet weak var goldHeight: NSLayoutConstraint!
    
    @IBOutlet weak var blueHeight: NSLayoutConstraint!
    
    @IBOutlet weak var leadingTeam: UILabel!
    

    
    let gp = 140
    let bp = 100
    let blp = 400
    let wp = 500
    
    
    
    func setupViews() {
        let pointList = [gp,bp,blp,wp]
        
        let pointLead = pointList.max()
        self.goldHeight.constant = CGFloat(gp)
        self.blueHeight.constant = CGFloat(bp)
        self.leadingTeam.text = "Gold team is leading by \(pointList.max() ?? 0)"
    }
    
}
