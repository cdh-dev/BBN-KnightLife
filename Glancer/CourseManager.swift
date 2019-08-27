//
//  CourseManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/25/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import Signals
import AddictiveLib
import SwiftyUserDefaults

private(set) var CourseM = CourseManager()

extension DefaultsKeys {
	
	fileprivate static let courseMigratedToRealm = DefaultsKey<Bool>("migrated.course")
	
}

class CourseManager {
	
	let onMeetingUpdate = Signal<Course>()
	
	fileprivate init() {
		self.loadLegacyData()
	}
	
	func loadLegacyData() {
		if !Defaults[.courseMigratedToRealm] {
			let oldStorage = MeetingPrefModule(self)
			StorageHub.instance.loadPrefs(oldStorage)
			
			Defaults[.courseMigratedToRealm] = true
		}
	}
	
	func loadLegacyCourse(course: Course) {
		try! Realms.write {
			Realms.add(course, update: true)
		}
		
		print("Loaded legacy course \( course.name )")
	}
	
	var courses: [Course] {
		return Array(Realms.objects(Course.self))
	}
	
	func createCourse(name: String) -> Course {
		let course = Course()
		
		course.name = name
		
		try! Realms.write {
			Realms.add(course)
		}
		
		return course
	}
	
	func deleteCourse(course: Course) {
		try! Realms.write {
			Realms.delete(course)
		}
	}
	
	func getCourses(block: Block) -> [Course] {
		return self.getCourses(schedule: block.timetable.schedule, block: block.id)
	}
	
	func getCourses(schedule: Schedule, block: Block.ID) -> [Course] {
		return self.getCourses(schedule: schedule).filter({ $0.scheduleBlock == block })
	}
	
	func getCourses(schedule: Schedule) -> [Course] {
		return self.courses.filter({ self.doesMeetOnDate($0, schedule: schedule) })
	}
	
	private func doesMeetOnDate(_ meeting: Course, schedule: Schedule) -> Bool {
		// No school means it doesn't meet
		guard let timetable = schedule.selectedTimetable else {
			return false
		}
		
		switch meeting.schedule {
		case let .everyDay(blockId):
			if let blockId = blockId {
				if timetable.hasBlock(id: blockId) {
					return true
				}
			}
			return false
		case let .specificDays(block, days):
			if let block = block {
				if days.contains(schedule.dayOfWeek) && timetable.hasBlock(id: block) {
					return true
				}
			}
			return false
		}
	}
	
}
