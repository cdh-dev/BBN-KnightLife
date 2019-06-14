//
//  LunchController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/27/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import TableManager

class LunchController: UITableViewController {
	
	let foodCellIdentifier = "food"
	
	var menu: Lunch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Register cell nib
		self.registerNib(name: "LunchItemCell", reuseIdentifier: self.foodCellIdentifier)
		
		self.tableView.allowsSelection = false
		self.tableView.separatorStyle = .singleLine
		self.tableView.separatorColor = .gray
		
		// Set navigation title
		self.navigationItem.title = self.menu.title ?? "Lunch"
		
		// Listen to menu updates
		self.menu.onUpdate.subscribe(with: self) { _ in
			self.configureCells()
		}
		
		// Initial layout of table
		self.configureCells()
	}
	
	deinit {
		// Stop listening to menu updates when this controller is dismissed
		self.menu.onUpdate.cancelSubscription(for: self)
	}
	
	private func configureCells() {
		self.tableView.clearRows()
		
		// Add a cell for each food
		self.menu.items.forEach({ food in
			self.tableView.addRow(self.foodCellIdentifier).setConfiguration({ row, cell, path in
				// Cast cell to relevant class
				guard let cell = cell as? UILunchItemCell else {
					return
				}
				
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
			})
		})
	}
	
}
