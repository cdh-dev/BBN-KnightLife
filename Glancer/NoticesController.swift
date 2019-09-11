//
//  NoticesController.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import Moya
import SwiftyJSON

class NoticesController: UIViewController, TableHandlerDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	private var tableHandler: TableHandler!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.dataSource = self
		
		self.navigationItem.title = "Messages"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
	}
	
	func buildCells(handler: TableHandler, layout: TableLayout) {

        let section = layout.addSection()
        section.addDivider()
//        section.addCell(TitleCell(title: "\(ColorWarEvent.blackPoints() ?? "0")"))
        section.addCell(ColorWarCell(left: "Black Team", right: "\(ColorWarEvent.blackPoints() ?? "0")"))
        section.addDivider()

//        "\(ColorWarEvent.blackPoints())"
	}
	
}
