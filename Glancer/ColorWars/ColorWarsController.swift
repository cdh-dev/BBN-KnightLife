//
//  ColorWarsController.swift
//  Glancer
//
//  Created by Henry Price on 9/11/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import Moya
import SwiftyJSON

class ColorWarController: UIViewController, TableHandlerDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var tableHandler: TableHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableHandler = TableHandler(table: self.tableView)
        self.tableHandler.dataSource = self
        
        self.navigationItem.title = "Color War Scores!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableHandler.reload()
    }
    
    func buildCells(handler: TableHandler, layout: TableLayout) {

        let section = layout.addSection()
        section.addDivider()
        section.addCell(ColorWarCell(left: "Black Team Points", right: "\(ColorWarEvent.blackPoints() ?? "0")"))
        section.addDivider()
        section.addCell(ColorWarCell(left: "White Team Points", right: "\(ColorWarEvent.whitePoints() ?? "0")"))
        section.addDivider()
        section.addCell(ColorWarCell(left: "Gold Team Points", right: "\(ColorWarEvent.goldPoints() ?? "0")"))
        section.addDivider()
        section.addCell(ColorWarCell(left: "Blue Team Points", right: "\(ColorWarEvent.bluePoints() ?? 0)"))
        section.addDivider()

    }
    
}
