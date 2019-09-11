//
//  NoticeCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class NoticeCell: TableCell {
	
	init(left: String, right: String) {
		super.init("notice", nib: "NoticeCell")
		
		self.setHeight(44)
		self.setSelectionStyle(.none)
		
		self.setCallback() {
			template, cell in
			
			guard let cell = cell as? UICWTeamEventsCell else {
				return
			}
			
            cell.leftLabel.text = left
            cell.rightLabel.text = right
            
            print(ColorWarEvent.goldPoints() ?? 0)
            
//			attachment.notice = notice
		}
	}
	
}


class UICWTeamEventsCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
}
