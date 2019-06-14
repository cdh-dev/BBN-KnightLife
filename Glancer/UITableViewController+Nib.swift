//
//  UITableViewController+Nib.swift
//  Glancer
//
//  Created by Dylan Hanson on 6/14/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewController {
	
	func registerNib(name: String, reuseIdentifier: String) {
		self.tableView.register(UINib.init(nibName: name, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
	}
	
}
