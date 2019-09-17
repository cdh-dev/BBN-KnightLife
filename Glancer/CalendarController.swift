//
//  CalendarController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/26/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import SnapKit
import Moya
import SwiftyJSON
import Timepiece

class CalendarController: UIViewController, TableHandlerDataSource, ErrorReloadable, PushRefreshListener {
	
	var refreshListenerType: [PushRefreshType] = [.EVENTS, .SCHEDULE]
	
	@IBOutlet weak var tableView: UITableView!
	var tableHandler: TableHandler!
	
	@IBOutlet weak var calendarView: CalendarView!
	
	var upcomingItems: [(date: Date, items: [UpcomingItem])]?
	var upcomingItemsError: Error?
	var upcomingItemsLoaded: Bool {
		return self.upcomingItems != nil || self.upcomingItemsError != nil
	}
	
	func openDay(date: Date) {
		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Day") as? DayController else {
			return
		}
		
		controller.date = date
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.dataSource = self
		
		self.calendarView.controller = self
		
		self.fetchUpcoming {
			self.tableHandler.reload()
		}
		
		self.registerListeners()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.calendarView.setupViews()
		self.setupNavigation()
		
		self.tableHandler.reload()
	}
	
	private func registerListeners() {
		PushNotificationManager.instance.addListener(type: .REFRESH, listener: self)
		
		TodayM.onNextDay.subscribe(with: self) { date in
			self.calendarView.setupViews()
			self.setupNavigation()
			
			self.tableHandler.reload()
		}
	}
	
	private func setupNavigation() {
		if let navigation = self.navigationItem as? SubtitleNavigationItem {
			let formatter = Date.normalizedFormatter
			formatter.dateFormat = "MMMM"
			navigation.subtitle = "\(formatter.string(from: Date.today))"
		}
	}
	
	private func setupRefresh() {
		if self.tableView.refreshControl != nil {
			return
		}
		
		let refreshControl = UIRefreshControl()
		self.tableView.refreshControl = refreshControl
		
		refreshControl.backgroundColor = .clear
		refreshControl.tintColor = Scheme.dividerColor.color
		
		refreshControl.addTarget(self, action: #selector(self.refreshSubmitted(_:)), for: .valueChanged)
	}
	
	private func removeRefresh() {
		if self.tableView.refreshControl != nil {
			self.tableView.refreshControl?.endRefreshing()
			self.tableView.refreshControl?.removeFromSuperview()
			self.tableView.refreshControl = nil
		}
	}
	
	@objc func refreshSubmitted(_ sender: Any) {
		self.fetchUpcoming {
			self.tableView.refreshControl?.endRefreshing()
			self.tableHandler.reload()
		}
	}
	
	func doListenerRefresh(date: Date, queue: DispatchGroup) {
		queue.enter()
		
		self.fetchUpcoming {
			self.tableHandler.reload()
			queue.leave()
		}
		
		self.tableHandler.reload()
	}
	
	func fetchUpcoming(then: @escaping () -> Void = {}) {
		self.upcomingItems = nil
		self.upcomingItemsError = nil
		
		let provider = MoyaProvider<API>()
		provider.request(.getUpcoming) {
			switch $0 {
			case .success(let response):
				do {
					_ = try response.filterSuccessfulStatusCodes()
					let json = try JSON(data: response.data)
					
					var upcomingItems: [(date: Date, items: [UpcomingItem])] = []
					
					for (dateString, subItem): (String, JSON) in json["upcoming"] {
						// All UpcomingItems for this day
						var items: [UpcomingItem] = []
						
						// Parse date from key
						do {
							let date = try Optionals.unwrap(dateString.dateFromInternetFormat)
							
							for rawItem in subItem.arrayValue {
								do {
									// Parse type
									let type = try Optionals.unwrap(UpcomingItemType(rawValue: try Optionals.unwrap(rawItem["type"].string)))
									
									// Grab badge
									let badge = try Optionals.unwrap(rawItem["badge"].string)
									
									var item: UpcomingItem!
									
									switch type {
									case .scheduleChanged:
										// TODO: Set up for schedule changes
										item = ScheduleChangedUpcomingItem(badge: badge, date: date)
										break
									case .event:
										do {
											let event = try Event.instantiate(json: rawItem["details"])
											item = EventUpcomingItem(badge: badge, event: event, date: date)
										} catch {
											print("An error prevented the parsing of an Upcoming Item.")
											print(error)
											continue
										}
									}
									
									// Item shouldn't be null
									items.append(item)
								} catch {
									print(error)
								}
							}
							
							// Append a new date items map
							upcomingItems.append((date, items))
						} catch {
							print(error)
						}
					}
					
					// Sort by date
					upcomingItems.sort(by: { $0.date < $1.date })
					
					self.upcomingItemsError = nil
					self.upcomingItems = upcomingItems
					
					// Trigger callback after a brief delay
					Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
						then()
					}
				} catch {
					self.upcomingItemsError = error
					self.upcomingItems = nil
				}
			case .failure(let error):
				self.upcomingItemsError = error
				self.upcomingItems = nil
			}
		}
	}
	
	func buildCells(handler: TableHandler, layout: TableLayout) {
		if !self.upcomingItemsLoaded {
			self.removeRefresh()
			layout.addSection().addCell(LoadingCell()).setHeight(self.tableView.bounds.size.height)
			return
		}
		
		if let _ = self.upcomingItemsError {
			self.removeRefresh()
			layout.addSection().addCell(ErrorCell(reloadable: self)).setHeight(self.tableView.bounds.size.height)
			return
		}
		
		self.setupRefresh()
		let list = self.upcomingItems!
		
		if list.isEmpty {
			layout.addSection().addCell(NothingUpcomingCell()).setHeight(self.tableView.bounds.size.height)
			//			No items
			return
		}
		
		for dateItemsPair in list {
			let section = layout.addSection()
			
			section.addDivider()
			section.addCell(TitleCell(title: dateItemsPair.date.prettyDate))
			section.addDivider()
			
			var views: [AttachmentView] = []
			for upcoming in dateItemsPair.items {
				views.append(upcoming.generateAttachmentView())
			}
			
			let cell = AttachmentCell(attachmentViews: views)
			cell.clickHandler = {
				self.openDay(date: dateItemsPair.date)
			}
			section.addCell(cell)
		}
		
		let newSection = layout.addSection()
		newSection.addDivider()
		newSection.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	func reloadData() {
		self.fetchUpcoming {
			self.tableHandler.reload()
		}
		self.tableHandler.reload()
	}
	
}
