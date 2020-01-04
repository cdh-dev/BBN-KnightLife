//
//  ColorWarsController.swift
//  Glancer
//
//  Created by Henry Price on 9/11/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import TableManager

class ColorWarsViewController: UITableViewController {
    
    let colorCellIdentifier = "color"
    
    var menu: ColorWars!
//    var menu: Lunch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .groupTableViewBackground
        
        // Register cell nib
        self.registerNib(name: "ColorWarCell", reuseIdentifier: self.colorCellIdentifier)
        
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        
        // Set navigation title
//        self.navigationItem.title = self.menu.title ?? "Lunch"
        
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
//        self.menu.items.forEach({
//            print("forEach")
            // Add a cell with the FoodCell ideentifier so that we know it's a Food cell
//            self.tableView.addRow(self.colorCellIdentifier).setObject($0 as AnyObject).setConfiguration(UIColorWarCell.rowConfiguration)
            
            // Divider
//            self.tableView.addSpace(height: 0.5, bgColor: Scheme.dividerColor.color)
//            self.tableView.addSpace(height: 0.5, bgColor: Scheme.dividerColor.color)
            
//        })
        self.menu.team.forEach ({
            self.tableView.addRow(self.colorCellIdentifier).setObject($0 as AnyObject).setConfiguration(UIColorWarCell.rowConfiguration)
        })
    }
    
}
