//
//  TodayController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/25/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import SnapKit

class TodayController: DayController {
	
	private var state: TodayManager.TodayScheduleState!
	
	override func viewDidLoad() {
		self.date = Date.today
		
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.handleStateChange(state: TodayManager.instance.currentState)
	}
	
	override func setupNavigationItem() {
		self.navigationItem.title = "Today"
		if let item = self.navigationItem as? SubtitleNavigationItem {
			item.subtitle = Date.today.prettyDate
		}
	}
	
	override func registerListeners() {
		TodayManager.instance.statusWatcher.onSuccess(self) {
			state in
			
			self.handleStateChange(state: state)
		}
	}
	
	override func unregisterListeners() {
//		Stop it from unregistering
	}
	
	override func reloadData() {
		switch TodayManager.instance.currentState {
		case .LOADING:
			break
		default:
			TodayManager.instance.reloadTodayBundle()
			break
		}
		
		self.handleStateChange(state: TodayManager.instance.currentState)
	}
	
	private func handleStateChange(state: TodayManager.TodayScheduleState) {
		self.state = state
		self.tableHandler.reload()
	}
	
	override func buildCells(layout: TableLayout) {
		switch self.state! {
		case .LOADING:
			self.showLoading(layout: layout)
			break
		case .ERROR:
			self.showError(layout: layout)
			break
		case let .NO_CLASS(today, nextDay):
			self.date = today.date
			self.setupNavigationItem()
			
			self.showNoClass(layout: layout, bundle: nextDay)
			break
		case let .BEFORE_SCHOOL(bundle, firstBlock, minutesUntil):
			self.date = bundle.date
			self.setupNavigationItem()
			
			self.showBeforeSchool(layout: layout, bundle: bundle, block: firstBlock, minutes: minutesUntil)
			break
		case let .BETWEEN_CLASS(bundle, nextBlock, minutesUntil):
			self.date = bundle.date
			self.setupNavigationItem()
			
			self.showBetweenClass(layout: layout, bundle: bundle, block: nextBlock, minutes: minutesUntil)
			break
		case let .IN_CLASS(bundle, current, next, minutesLeft):
			self.date = bundle.date
			self.setupNavigationItem()
			
			self.showInClass(layout: layout, bundle: bundle, current: current, next: next, minutes: minutesLeft)
			break
		case let .AFTER_SCHOOL(bundle, nextDay):
			self.date = bundle.date
			self.setupNavigationItem()
			
			self.showAfterSchool(layout: layout, bundle: nextDay)
			break
		}
	}
	
	private func showNoClass(layout: TableLayout, bundle: DayBundle?) {
		if bundle == nil {
			self.showNone(layout: layout)
			return
		}
		
		layout.addSection().addCell(NoClassCell()).setHeight(120)
		self.addNextSchoolday(layout: layout, bundle: bundle!)
	}
	
	private func showBeforeSchool(layout: TableLayout, bundle: DayBundle, block: Block, minutes: Int) {
		layout.addSection().addCell(TodayStatusCell(state: "Before School", minutes: minutes, image: UIImage(named: "icon_clock")!, color: UIColor.black.withAlphaComponent(0.3)))

		let upcomingBlocks = bundle.schedule.getBlocks()
		self.tableHandler.addModule(BlockListModule(controller: self, composites: self.generateCompositeList(bundle: bundle, blocks: upcomingBlocks)))
	}
	
	private func showBetweenClass(layout: TableLayout, bundle: DayBundle, block: Block, minutes: Int) {
		let analyst = BlockAnalyst(schedule: bundle.schedule, block: block)
		
		let section = layout.addSection()
		section.addCell(TodayStatusCell(state: "Get to \(analyst.getDisplayName())", minutes: minutes, image: UIImage(named: "icon_class")!, color: analyst.getColor()))
		
		section.addDivider()
		section.addCell(BlockCell(controller: self, composite: self.generateCompositeBlock(bundle: bundle, block: block)))
		section.addDivider()
		
		section.addSpacerCell().setHeight(30)

		let upcomingBlocks = bundle.schedule.getBlocksAfter(block)
		self.tableHandler.addModule(BlockListModule(controller: self, composites: self.generateCompositeList(bundle: bundle, blocks: upcomingBlocks)))
	}
	
	private func showInClass(layout: TableLayout, bundle: DayBundle, current: Block, next: Block?, minutes: Int) {
		let analyst = BlockAnalyst(schedule: bundle.schedule, block: current)
		
		let section = layout.addSection()
		section.addCell(TodayStatusCell(state: "in \(analyst.getDisplayName())", minutes: minutes, image: UIImage(named: "icon_clock")!, color: analyst.getColor()))
		
		let secondPassed = Calendar.normalizedCalendar.dateComponents([.second], from: current.time.start, to: Date.today).second!
		let secondDuration = Calendar.normalizedCalendar.dateComponents([.second], from: current.time.start, to: current.time.end).second!
		
		let duration = Float(secondPassed) / Float(secondDuration)
		
		section.addCell(TodayBarCell(color: analyst.getColor(), duration: duration))
		section.addCell(BlockCell(controller: self, composite: self.generateCompositeBlock(bundle: bundle, block: current)))
		section.addDivider()
		
		section.addSpacerCell().setHeight(30)
		
		let upcomingBlocks = bundle.schedule.getBlocksAfter(current)		
		self.tableHandler.addModule(BlockListModule(controller: self, composites: self.generateCompositeList(bundle: bundle, blocks: upcomingBlocks)))
	}
	
	private func showAfterSchool(layout: TableLayout, bundle: DayBundle?) {
		guard let bundle = bundle else {
			layout.addSection().addCell(TodayDoneCell()).setHeight(self.tableView.bounds.size.height)
			return
		}
		
		let doneSection = layout.addSection()
		doneSection.addCell(TodayDoneCell()).setHeight(120)
		self.addNextSchoolday(layout: layout, bundle: bundle)
	}
	
	private func addNextSchoolday(layout: TableLayout, bundle: DayBundle) {
		let offset = self.date.dayDifference(date: bundle.date)
		var label: String = ""
		switch offset {
		case 0:
			label = "Today"
		case 1:
			label = "Tomorrow"
		case -1:
			label = "Yesterday"
		default:
			if offset < 0 {
				label = "\(abs(offset)) Days Ago"
			} else if offset < 7 {
				label = bundle.date.weekday.displayName
			} else {
				label = "\(offset) Days Away"
			}
		}
		
		let section = layout.addSection()
		section.addDivider()
		section.addCell(TitleCell(title: "Next School Day (\(label))"))
		
		let compiled = self.generateCompositeList(bundle: bundle, blocks: bundle.schedule.getBlocks())
		self.tableHandler.addModule(BlockListModule(controller: self, composites: compiled, section: section))
	}
	
}
