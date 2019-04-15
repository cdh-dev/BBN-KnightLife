//
//  CourseSchedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib

enum CourseSchedule {
	
	case everyDay(Block.ID?)
	case specificDays(Block.ID?, [DayOfWeek])
	
}

extension CourseSchedule {
	
	@discardableResult
	mutating func addMeetingDay(_ day: DayOfWeek) -> Bool {
		switch self {
		case .specificDays(let block, var days):
			days.append(day)
			self = .specificDays(block, days)
			return true
		default: return false
		}
	}
	
	@discardableResult
	mutating func removeMeetingDay(_ day: DayOfWeek) -> Bool {
		switch self {
		case .specificDays(let block, var days):
			days = days.filter({ $0 != day })
			self = .specificDays(block, days)
			return true
		default: return false
		}
	}
	
}

extension CourseSchedule {
	
	func meetingDaysContains(_ day: DayOfWeek) -> Bool {
		switch self {
		case .specificDays(_, let days):
			return days.contains(day)
		default: return false
		}
	}
	
}

extension CourseSchedule {
	
	var intValue: Int {
		switch self {
		case .everyDay(_): return 0
		case .specificDays(_, _): return 1
		}
	}
	
}
