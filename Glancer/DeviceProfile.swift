//
//  DeviceProfile.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/31/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import SwiftyJSON
import Signals
import Moya

extension DefaultsKeys {
	
	static let deviceId = DefaultsKey<String>("deviceId", defaultValue: "")
	
	static let userGrade = DefaultsKey<Int?>("userGrade")
	static let gradeMigratedToRealm = DefaultsKey<Bool>("migrated.grade", defaultValue: false)
	static let gradeLegacy = DefaultsKey<Int>("events.grade", defaultValue: 0)
	
}

// Represents a list of settings which will be synced to server
class DeviceProfile {
	
	static let shared = DeviceProfile()
	
	private var syncing = false
	
	fileprivate init() {
		
	}
	
	// Syncs the status of the DeviceProfile to server
	func sync() {
		if self.syncing {
			return
		}
		
		print("Attempting to sync DeviceProfile settings to server.")
		
		self.syncing = true
		
		self.pushToServer().subscribe(with: self) {
			var successful: Bool = false
			
			switch $0 {
			case .success(let success):
				successful = success
			case .failure(let error):
				print(error)
			}
			
			if successful {
				// Done syncing
				self.syncing = false
				
				print("Successfully synced DeviceProfile settings to server.")
			} else {
				print("Failed to sync DeviceProfile with server. Retrying in five seconds.")
				
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
					self.syncing = false
					self.sync()
				}
			}
		}
	}
	
	private func pushToServer() -> CallbackSignal<Bool> {
		let signal = CallbackSignal<Bool>()
		
		let provider = MoyaProvider<API>()
		provider.request(.updateDeviceProfile(profile: self)) {
			switch $0 {
			case .success(let response):
				do {
					_ = try response.filterSuccessfulStatusCodes()
					
					// Parse
					let json = try JSON(data: response.data)
					let success = json["success"].boolValue
					
					signal.fire(.success(success))
				} catch {
					signal.fire(.failure(error))
				}
			case .failure(let error):
				signal.fire(.failure(error))
			}
		}
		
		return signal
	}
	
	// Converts the profile to a JSON object which can be passed to the server
	var toJSON: JSON {
		return JSON([
			"grade": self.userGrade?.rawValue
		])
	}
	
	// MARK: USER GRADE
	
	let onUserGradeChange: Signal<Grade?> = Signal<Grade?>()
	
	var userGrade: Grade? {
		get {
			// Not yet migrated so fetch via legacy
			if !Defaults[.gradeMigratedToRealm] {
				Defaults[.gradeMigratedToRealm] = true
				
				let legacyGrade = Defaults[.gradeLegacy]
				
				if let grade = Grade(rawValue: legacyGrade - 1) {
					// Save legacy in new value
					Defaults[.userGrade] = grade.rawValue
					
					print("Loaded user legacy grade \( grade.singular )")
					
					return grade
				}
			}
			
			return Grade(rawValue: Defaults[.userGrade] ?? -1)
		}
		
		set {
			// Set migrated to true so we don't accidentally overwrite new settings
			Defaults[.gradeMigratedToRealm] = true
			
			Defaults[.userGrade] = newValue == nil ? nil : newValue!.rawValue
			self.onUserGradeChange.fire(newValue)
			
			// Update server on this device's grade
			print("User has changed their grade. Attempting to sync with server.")
			self.sync()
		}
	}
	
}
