//
//  MeetingPrefModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/1/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class MeetingPrefModule: StorageHandler {
	
	var storageKey: String = "course.items"
	
	let manager: CourseManager
	
	init(_ manager: CourseManager) {
		self.manager = manager
	}
	
	func saveData() -> Any? {
		var arrayOfData: [[String: Any]] = []
		
		for course in self.manager.meetings {
			var map: [String: Any] = [:]
			
			map["name"] = course.name
			
			map["color"] = course.color.toHex ?? nil
			map["location"] = course.location
			
			map["notifications"] = course.showBeforeClassNotifications
			map["notifications_after"] = course.showAfterClassNotifications
			
			map["schedule.block"] = course.courseSchedule.block.rawValue
			
			switch course.courseSchedule.frequency {
			case .everyDay:
				map["schedule.frequency"] = "everyday"
			case .specificDays(let days):
				map["schedule.frequency"] = days.map({ return $0.rawValue })
			}
			
			arrayOfData.append(map)
		}
		
		return arrayOfData
	}
	
	func loadData(data: Any) {
		guard let list = data as? [[String: Any]] else {
			return
		}
		
		for item in list {
			guard let name = item["name"] as? String else {
				print("Invalid course name")
				continue
			}
			
			var location: String?
			if let rawLocation = item["location"] as? String {
				location = rawLocation
			}
			
			guard let rawColor = item["color"] as? String, let color = UIColor(hex: rawColor) else {
				print("Invalid course color")
				continue
			}
			
			guard let beforeClassNotifications = item["notifications"] as? Bool else {
				print("Invalid course notifications")
				continue
			}
			
			guard let rawBlock = item["schedule.block"] as? Int, let block = BlockID(rawValue: rawBlock) else {
				print("Invalid course block")
				continue
			}
			
			var frequency: CourseFrequency!
			if let _ = item["schedule.frequency"] as? String {
				frequency = CourseFrequency.everyDay
			} else if let rawFrequencyDays = item["schedule.frequency"] as? [Int] {
//				We could easily use a simple map function, but that would require force unwrapping, and I don't want to have the option of a crash.
				var days: [DayOfWeek] = []
				for id in rawFrequencyDays {
					if let day = DayOfWeek(rawValue: id) { days.append(day) }
				}
				frequency = CourseFrequency.specificDays(days)
			} else {
				print("Invalid course frequency")
				continue
			}
			
			let schedule = CourseSchedule(block: block, frequency: frequency)
			let course = Course(name: name, schedule: schedule)
			
			course.color = color
			course.showBeforeClassNotifications = beforeClassNotifications
			
			if let afterClassNotifications = item["notifications_after"] as? Bool {
				course.showAfterClassNotifications = afterClassNotifications
			}
			
			course.location = location
			
			print("Successfully loaded course: \(course.name)")
			
			self.manager.loadedCourse(course: course)
		}
	}
	
	func loadDefaults() {
//		self.loadLegacyData()
	}
	
//	private func loadLegacyData()
//	{
//		if let meta = Storage.USER_META.getValue() as? [String:[String:String?]]
//		{
//			for (rawBlockId, keyPairs) in meta
//			{
//				if let blockId = BlockID(rawValue: ["A", "B", "C", "D", "E", "F", "G"].index(of: rawBlockId) ?? 99) {
//					let name: String = {
//						if keyPairs["name"] != nil
//						{ if keyPairs["name"]! != nil
//						{ return keyPairs["name"]!! } }; return "Unknown" }()
//					let color: String? = { if keyPairs["color"] != nil { if keyPairs["color"]! != nil { return keyPairs["color"]!! } }; return nil }()
//					let room: String? = { if keyPairs["room"] != nil { if keyPairs["room"]! != nil { return keyPairs["room"]!! } }; return nil }()
//
//					let schedule = CourseSchedule(block: blockId, frequency: .everyDay)
//					let course = Course(name: name, schedule: schedule)
//					course.location = room
//
//					if color != nil, let parsedColor = UIColor(hex: color!) {
//						course.color = parsedColor
//					}
//
//					self.manager.addCourse(course)
//				}
//			}
//
//			Storage.USER_META.delete()
//		}
//	}
}
