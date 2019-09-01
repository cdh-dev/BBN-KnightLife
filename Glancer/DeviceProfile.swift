//
//  DeviceProfile.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/31/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
	
	static let gradeMigratedToRealm = DefaultsKey<Bool>("migrated.grade")
	static let gradeLegacy = DefaultsKey<Int>("events.grade")
	
}

// Represents a list of settings which will be synced to server
class DeviceProfile {
	
	
	
}
