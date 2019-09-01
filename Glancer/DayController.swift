//
//  DayController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/25/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class DayController: UIViewController, TableHandlerDataSource, ErrorReloadable {

	@IBOutlet weak var tableView: UITableView!
	var tableHandler: TableHandler!
	
	@IBOutlet weak var tableHeightAnchor: UIView!
	
	var date: Date!
	
	var bundle: Day?
	var bundleError: Error?
	var bundleDownloaded: Bool { return bundle != nil || bundleError != nil }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.dataSource = self
		
		self.registerListeners()
		self.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {		
		super.viewWillAppear(animated)
		
		self.registerListeners()
		
		self.tableHandler.reload()
		self.setupNavigationItem()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//		TODO: UNREGISTER ON UNWIND.
		self.unregisterListeners()
	}
	
	func reloadData() {
		self.bundle = nil
		self.bundleError = nil
		
		self.tableHandler.reload()
		
		Day.fetch(for: self.date).subscribeOnce(with: self) {
			switch $0 {
			case .success(let day):
				self.bundle = day
				self.bundleError = nil
			case .failure(let error):
				self.bundle = nil
				self.bundleError = error
			}
			
			self.tableHandler.reload()
		}
	}
	
	func registerListeners() {
		Schedule.onFirstLunchChange.subscribe(with: self) { change in
			self.tableHandler.reload()
		}.filter({ $0.dayOfWeek == self.date.weekday })
		
		DeviceProfile.shared.onUserGradeChange.subscribe(with: self) { grade in
			self.tableHandler.reload()
		}
	}
	
	func unregisterListeners() {
		Schedule.onFirstLunchChange.cancelSubscription(for: self)
	}
	
	func setupNavigationItem() {
		self.setupMailButtonItem()
		
		self.navigationItem.title = self.date.prettyDate
		
		if let subtitleItem = self.navigationItem as? SubtitleNavigationItem {
//			if let bundle = self.bundle {
//				if bundle.schedule.changed {
//					subtitleItem.subtitle = "Special"
//					subtitleItem.subtitleColor = .red
//
//					return
//				}
//			}

			subtitleItem.subtitle = nil
			subtitleItem.subtitleColor = UIColor.darkGray
		}
	}
	
	private func buildMailButtonItem(badge: Int) -> UIBarButtonItem {
		let button = UIButton()
		button.setImage(UIImage(named: "icon_mail")?.withRenderingMode(.alwaysTemplate), for: .normal)
		button.tintColor = Scheme.blue.color
		
		button.addTarget(self, action: #selector(self.messagesButtonClicked(_:)), for: .touchUpInside)
		
		let badgeWrapper = UIView()
		badgeWrapper.backgroundColor = UIColor.red
		badgeWrapper.cornerRadius = 7.0
		
		let badgeLabel = UILabel()
		badgeLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
		badgeLabel.text = "\(badge)"
		badgeLabel.textColor = UIColor.white
		
		badgeWrapper.addSubview(badgeLabel)
		badgeLabel.snp.makeConstraints() { $0.center.equalToSuperview() }
		
		button.addSubview(badgeWrapper)
		badgeWrapper.snp.makeConstraints() {
			constrain in
			
			constrain.width.equalTo(14.0)
			constrain.height.equalTo(14.0)
			
			constrain.centerX.equalTo(button.snp.trailing).inset(1)
			constrain.centerY.equalTo(button.snp.top).inset(2)
		}
		
		return UIBarButtonItem(customView: button)
	}
	
	func setupMailButtonItem() {
//		if let bundle = self.bundle {
//			if bundle.schedule.notices.isEmpty {
//				self.removeMailButton()
//			} else {
//				self.addMailButton(badge: bundle.schedule.notices.count)
//			}
//		} else {
			self.removeMailButton()
//		}
	}
	
	private func removeMailButton() {
		if self.navigationItem.rightBarButtonItem != nil {
			self.navigationItem.setRightBarButton(nil, animated: true)
		}
	}
	
	private func addMailButton(badge: Int) {
		self.navigationItem.setRightBarButton(self.buildMailButtonItem(badge: badge), animated: false)
	}
	
	@objc func messagesButtonClicked(_ sender: Any) {
		guard let bundle = self.bundle else {
			self.setupNavigationItem()
			return
		}
		
//		if bundle.schedule.notices.isEmpty {
//			self.setupNavigationItem()
//			return
//		}
		
		guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as? NoticesController else {
			return
		}
		
//		controller.notices = bundle.schedule.notices
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func buildCells(handler: TableHandler, layout: TableLayout) {
		self.setupNavigationItem()
		
		if !self.bundleDownloaded {
			layout.addModule(LoadingModule(table: self.tableView))
			return
		}
		
		if let _ = self.bundleError {
			layout.addModule(ErrorModule(table: self.tableView, reloadable: self))
			return
		}
		
		self.showNotices()
		
		if !self.bundle!.schedule.hasSchool {
			layout.addModule(NoClassModule(table: self.tableView, fullHeight: self.bundle!.events.timeEvents.isEmpty))
			layout.addModule(AfterSchoolEventsModule(bundle: self.bundle!, title: "Events", options: [.topBorder, .bottomBorder]))
			
			return
		}
		
		layout.addModule(BlockListModule(controller: self, bundle: self.bundle!, title: nil, blocks: self.bundle!.schedule.selectedTimetable!.filterBlocksByLunch(), options: [.topBorder, .bottomBorder]))
		layout.addModule(AfterSchoolEventsModule(bundle: self.bundle!, title: "After School", options: [.bottomBorder]))
		
		layout.addSection().addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	func openLunch(menu: Lunch) {
		let controller = LunchViewController()
		
		controller.menu = menu
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func showNotices() {
		if let bundle = self.bundle {
//			This will only display the first notice, but I really think that's OK.
//			bundle.schedule.notices.filter({ $0.priority == .warning && !self.hasDisplayedNoticeAlready(notice: $0) }).forEach({ self.showNotice(notice: $0) })
		}
	}
	
//	private func hasDisplayedNoticeAlready(notice: DateNotice) -> Bool {
//		guard let displayedNotices: [String: [String]] = Globals.getData("displayedNotices") else {
//			let array: [String: [String]] = [:]
//			Globals.setData("displayedNotices", data: array)
//			return false
//		}
//
//		guard let todayNotices = displayedNotices[self.date.webSafeDate] else {
//			return false
//		}
//
//		let noticeHash = "\(notice.priority.rawValue)\(notice.message)"
//		return todayNotices.contains(noticeHash)
//	}
//
//	private func showNotice(notice: DateNotice) {
//		var displayedNotices: [String: [String]] = Globals.getData("displayedNotices")!
//		if displayedNotices[self.date.webSafeDate] == nil {
//			displayedNotices[self.date.webSafeDate] = []
//		}
//
//		let noticeHash = "\(notice.priority.rawValue)\(notice.message)"
//		displayedNotices[self.date.webSafeDate]!.append(noticeHash)
//
//		Globals.setData("displayedNotices", data: displayedNotices) // Make sure it gets set properly again
//
//		let alert = UIAlertController(title: "Alert", message: notice.message, preferredStyle: .alert)
//		alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
//
//		self.present(alert, animated: true)
//	}
	
}
