//
//  ProgressBar.swift
//  Glancer
//
//  Created by Henry Price on 9/13/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class ProgressBar: TableCell {
    
    init(color: UIColor, points: Int) {
        super.init("progressbar", nib: "ProgressBarCell")
        
        self.setSelectionStyle(.none)
        
        self.setCallback() {
            template, cell in
            
            guard let progressCell = cell as? UIProgressBar else {
                return
            }
            
            progressCell.backgroundColor = Scheme.dividerColor.color
            progressCell.ProgressBar.backgroundColor = color
            
            let screenHeight = UIScreen.main.bounds.height
            let barHeight = screenHeight * CGFloat(points)
            
            let trailing = screenHeight - barHeight
            
            progressCell.trailingConstraint.constant = trailing
        }
    }
    
}



class UIProgressBar : UITableViewCell{
    @IBOutlet weak var HeightView: UIView!
    
    @IBOutlet weak var ProgressBar: UIView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
}
