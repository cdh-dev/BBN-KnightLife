//
//  UINoteTableViewCell.swift
//  Glancer
//
//  Created by Henry Price on 3/30/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//


import UIKit

class UINoteTableViewCell : UITableViewCell {
    private(set) var noteTitle : String = ""
    private(set) var noteText  : String = ""
    private(set) var noteDate  : String = ""
 
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    
    
}
