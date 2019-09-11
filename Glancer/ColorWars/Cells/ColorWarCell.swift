//
//  ColorWarCell.swift
//  Glancer
//
//  Created by Henry Price on 9/11/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class ColorWarCell: TableCell {
    
    init(left: String, right: String) {
        super.init("colorwar", nib: "ColorWarCell")
        
        self.setHeight(44)
        self.setSelectionStyle(.none)
        
        self.setCallback() {
            template, cell in
            
            guard let cell = cell as? UIColorWarCell else {
                return
            }
            
            cell.leftLabel.text = left
            cell.rightLabel.text = right
            
            print(ColorWarEvent.goldPoints() ?? 0)
            
//            attachment.notice = notice
        }
    }
    
}


class UIColorWarCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
}
