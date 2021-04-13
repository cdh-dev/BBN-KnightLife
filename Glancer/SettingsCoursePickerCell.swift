//
//  SettingsCoursePickerCell.swift
//  Glancer
//
//  Created by Henry Price on 8/15/20.
//  Copyright © 2020 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class SettingsPickerCell: TableCell {
    
    init(left: String, right: String, clicked: @escaping () -> Void) {
        super.init("settingspicker", nib: "SettingsPickerCell")
        
        self.setHeight(44)
        
        self.setDeselectOnSelection(true)
        
        self.setCallback() {
            template, cell in
            
            guard let textCell = cell as? UISettingsPickerCell else {
                return
            }
            
            textCell.blockLabel.text = left
            textCell.pickerLabel.text = right
        }
        
        self.setSelection() {
            template, cell in
            
            clicked()
        }
    }
    
}

class UISettingsPickerCell: UITableViewCell {
    
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var pickerLabel: UILabel!
    
}
