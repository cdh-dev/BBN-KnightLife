//
//  BlockMetaID.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

extension BlockMeta {
	
	enum ID: String {
		
		case lunch
		case activities
		case advisory
		case classMeeting
		case assembly
		case x
		case block1
        case block2
        case block3
        case block4
        
		case free
		
	}
	
}

extension BlockMeta.ID {
	
	var displayName: String {
		switch self {
		case .lunch:
			return "Lunch"
		case .x:
			return "X Block"
		case .activities:
			return "Activities"
		case .advisory:
			return "Advisory"
		case .classMeeting:
			return "Class Meeting"
		case .assembly:
			return "Assembly"
        case .block1:
            return "Block 1"
        case .block2:
            return "Block 2"
        case .block3:
            return "Block 3"
        case .block4:
            return "Block 4"
		case .free:
			return "Free Blocks"
		}
	}
	
}

extension BlockMeta.ID {
	
	static var values: [BlockMeta.ID] = [
		.lunch,
		.activities,
		.advisory,
		.classMeeting,
		.assembly,
		.x,
        .block1,
        .block2,
        .block3,
        .block4,
		.free]
	
}

extension BlockMeta.ID {
	
	init?(id: Block.ID) {
		
		switch id {
		case .lab:
			return nil
		case .custom:
			return nil
		case .x:
			self = .x
		case .lunch:
			self = .lunch
		case .activities:
			self = .activities
		case .advisory:
			self = .advisory
		case .classMeeting:
			self = .classMeeting
		case .assembly:
			self = .assembly
        case .block1:
            self = .block1
        case .block2:
            self = .block2
        case .block3:
            self = .block3
        case .block4:
            self = .block4
		default:
			self = .free
		}
		
	}
	
}
