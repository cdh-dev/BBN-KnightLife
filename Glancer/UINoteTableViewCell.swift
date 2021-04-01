//
//  UINoteTableViewCell.swift
//  Glancer
//
//  Created by Henry Price on 3/30/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class NoteTableCell: TableCell {
    
    init(title: String){
        
        super.init("noteTable", nib: "UINoteTableViewCell")
        
        self.setEstimatedHeight(32)
        self.setSelectionStyle(.none)
        
        self.setCallback {
            template, cell in
            
            guard let noteCell = cell as? UINoteTableViewCell else {
                return
            }
            
            noteCell.backgroundColor = UIColor.clear
            noteCell.NoteLabel.text = title
            
        }
        
    }
}

class UINoteTableViewCell: UITableViewCell {
    @IBOutlet weak var NoteLabel: UILabel!
}
