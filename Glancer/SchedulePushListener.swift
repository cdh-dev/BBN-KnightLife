//
//  SchedulePushListener.swift
//  Glancer
//
//  Created by Dylan Hanson on 6/14/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation

class SchedulePushListener: PushRefreshListener {
	
	var refreshListenerType: [PushRefreshType] = [.SCHEDULE]
	
	func doListenerRefresh(date: Date, queue: DispatchGroup) {
		queue.enter()
		
		Schedule.fetch(for: date).subscribeOnce(with: self) { _ in
			queue.leave()
		}
	}
	
}
