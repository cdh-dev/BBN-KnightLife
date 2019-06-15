//
//  UILunchItemCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import TableManager

class UILunchItemCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	
	@IBOutlet weak var attachmentsStack: UIStackView!
	@IBOutlet weak var attachmentsBottomConstraint: NSLayoutConstraint!
	
	static let rowConfiguration: Row.Configuration = { row, cell, path in
		// Cast cell to relevant class
		let cell = cell as! UILunchItemCell
		let food = row.object as! Lunch.Food
		
		row.setHeightAutomatic()
		
		// Delete all previously added attachments
		cell.attachmentsStack.arrangedSubviews.forEach({ cell.attachmentsStack.removeArrangedSubview($0) ; $0.removeFromSuperview() })
		
		cell.nameLabel.text = food.name
		
		// Set allergy attachment
		if let allergy = food.allergy {
			let attachment = LunchItemAttachmentView()
			attachment.text = allergy
			cell.attachmentsStack.addArrangedSubview(attachment)
		}
		
		// Change the bottom constraint depending on whether or not there's an allergy warning
		cell.attachmentsBottomConstraint.constant = cell.attachmentsStack.arrangedSubviews.count > 0 ? 10.0 : 0.0
	}
	
}
