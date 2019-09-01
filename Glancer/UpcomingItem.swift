//
//  UpcomingItem.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/11/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

enum UpcomingItemType: String {
	
	case scheduleChanged = "special-schedule"
	case event = "event"
	
}

class UpcomingItem {
	
	let type: UpcomingItemType
	let date: Date
	
	init(type: UpcomingItemType, date: Date) {
		self.type = type
		self.date = date
	}
	
	// Override
	func generateAttachmentView() -> AttachmentView {
		return AttachmentView()
	}
	
}

class ScheduleChangedUpcomingItem: UpcomingItem {
	
	let badge: String
	
	init(badge: String, date: Date) {
		self.badge = badge
		
		super.init(type: .scheduleChanged, date: date)
	}
	
	override func generateAttachmentView() -> AttachmentView {
		return ScheduleChangedAttachment()
	}
	
}

class EventUpcomingItem: UpcomingItem {
	
	let badge: String
	let event: Event
	
	init(badge: String, event: Event, date: Date) {
		self.badge = badge
		self.event = event
		
		super.init(type: .event, date: date)
	}
	
	override func generateAttachmentView() -> AttachmentView {
		if self.event.schedule.usesTime {
			let view = TimeEventAttachmentView()
			view.event = self.event
			return view
		} else {
			let view = EventAttachmentView()
			view.event = self.event
			return view
		}
	}
	
}
