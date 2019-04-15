//
//  GetScheduleWebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import AddictiveLib
import Unbox

class GetScheduleWebCall: UnboxWebCall<KnightlifeListPayload<GetScheduleResponseDay>, [DayOfWeek: DaySchedule]> {
	
	init() {
		super.init(call: "schedule/template")
	}
	
	override func convertToken(_ response: KnightlifeListPayload<GetScheduleResponseDay>) -> [DayOfWeek: DaySchedule]? {
		var days: [DayOfWeek: DaySchedule] = [:]
		guard let content = response.content else {
			print(response.error ?? "Unknown error occurred while parsing template payload")
			return nil
		}
		
		for item in content {
			guard let dayId = DayOfWeek.fromShortName(shortName: item.day) else {
				print("Recieved an invalid day id: \(item.day)")
				continue
			}
			
			var blocks: [Block] = []
			
			for block in item.blocks {
				guard let blockId = Block.ID(rawValue: block.id) else {
					print("Recieved an invalid block id: \(block.id)")
					continue
				}
				
				guard let start = Date.fromWebTime(string: block.start), let end = Date.fromWebTime(string: block.end) else {
					print("Failed to parse a date.")
					continue
				}
				
				let duration = TimeDuration(start: start, end: end)
				blocks.append(Block(id: blockId, variation: block.variation, time: duration, custom: nil))
			}
			
			let schedule = DaySchedule(day: dayId, blocks: blocks)
			
			if days[dayId] != nil {
				print("Already set information for day: \(dayId.rawValue)")
			} else {
				days[dayId] = schedule
			}
		}
		return days
	}
	
}

class GetScheduleResponseDay: DayPayload {
	
	let day: String
	
	required init(unboxer: Unboxer) throws {
		self.day = try unboxer.unbox(key: "id")
		try super.init(unboxer: unboxer)
	}
	
}
