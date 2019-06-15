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

class LunchViewController: UITableViewController {
	
	let foodCellIdentifier = "food"
	
	var menu: Lunch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .groupTableViewBackground
		
		// Register cell nib
		self.registerNib(name: "UILunchItemCell", reuseIdentifier: self.foodCellIdentifier)
		
		self.tableView.allowsSelection = false
		self.tableView.separatorStyle = .none
		
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
		self.menu.items.forEach({
			
			// Add a cell with the FoodCell ideentifier so that we know it's a Food cell
			self.tableView.addRow(self.foodCellIdentifier).setObject($0 as AnyObject).setConfiguration(UILunchItemCell.rowConfiguration)
			
			// Divider
			self.tableView.addSpace(height: 0.5, bgColor: Scheme.dividerColor.color)
			
		})
	}
	
}
