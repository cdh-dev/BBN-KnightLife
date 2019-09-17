//
//  ColorWarEvent.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/19/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyJSON

class ColorWarEvent: Event {
	
	override var eventType: EventTypes {
		return .colorwars
	}
	
	private(set) var score: ColorWarScore?
	
	var hasScore: Bool {
		return self.score != nil
	}
	
	required init(json: JSON) throws {
		try super.init(json: json)
		
		if (json["points"].exists()) {
			self.score = try? ColorWarScore(json: json["points"])
		}
	}
    
    class func goldPoints() -> String? {
        let json: JSON! = 0
        let points = try? Optionals.unwrap(json["points"]["gold"].string)
        return points
    }
    
    class func bluePoints() -> String? {
        let json: JSON! = 0
        let points = try? Optionals.unwrap(json["points"]["blue"].string)
        return points
    }
    
    class func whitePoints() -> String? {
        let json: JSON! = 0
        let points = try? Optionals.unwrap(json["points"]["white"].string)
        return points
    }
    
    class func blackPoints() -> String? {
        let json: JSON! = 0
        let points = try? Optionals.unwrap(json["points"]["black"].string)
        return points
    }
    
	override func updateContent(from: Event) {
		super.updateContent(from: from)
		
		if let cwEvent = from as? ColorWarEvent {
			self.score = cwEvent.score
		}
	}
	
}

struct ColorWarScore: Decodable {
	
	let gold: Int
	let blue: Int
	let white: Int
	let black: Int
	
	var mapped: [String: Int] {
		return [
			"gold": self.gold,
			"blue": self.blue,
			"white": self.white,
			"black": self.black
		]
	}
	
	init(json: JSON) throws {
		
		self.gold = try Optionals.unwrap(json["points"]["gold"].int)
		self.blue = try Optionals.unwrap(json["points"]["blue"].int)
		self.white = try Optionals.unwrap(json["points"]["white"].int)
		self.black = try Optionals.unwrap(json["points"]["black"].int)
		
	}
	
}
