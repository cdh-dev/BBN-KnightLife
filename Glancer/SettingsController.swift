//
//  SettingsController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/29/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import SafariServices
import Moya
import SwiftyJSON
import GameKit

class SettingsController: UIViewController, TableHandlerDataSource {
	
	@IBOutlet weak var tableView: UITableView!
//    class var shared: GKAccessPoint {get}
	private(set) var tableHandler: TableHandler!
    
//    GKAccessPoint.shared.location = .topLeading
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
	}
	
	func buildCells(handler: TableHandler, layout: TableLayout) {
		layout.addModule(CoursesPrefModule(controller: self))
		layout.addModule(BlockPrefsModule(controller: self))
		layout.addModule(VariationPrefsModule())
		layout.addModule(EventsPrefsModule(controller: self))
//		layout.addModule(LunchPrefsModule())
		layout.addModule(BottomPrefsModule())
	}
	
	@IBAction func surveyClicked(_ sender: Any) {
		let provider = MoyaProvider<API>()
		provider.request(.getSurveyURL) {
			switch $0 {
			case .success(let res):
				do {
					_ = try res.filterSuccessfulStatusCodes()
					let json = try JSON(data: res.data)
					
					if let urlString = json["url"].string, let url = URL(string: urlString) {
						let safariController = SFSafariViewController(url: url)
						self.present(safariController, animated: true, completion: nil)
					} else {
						self.showError()
					}
				} catch {
					print(error)
					self.showError()
				}
			case .failure(let error):
				print(error)
				self.showError()
			}
		}
	}
	
	private func showError() {
		let alertController = UIAlertController(title: "Error", message: "Couldn't fetch the survey", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
		self.present(alertController, animated: true, completion: nil)
	}
	
}
