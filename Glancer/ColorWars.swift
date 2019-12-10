//
//  ColorWars.swift
//  Glancer
//
//  Created by Henry Price on 12/4/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyJSON
import Timepiece
import Moya
import Signals

final class ColorWars: Refreshable, Decodable {
    
    struct thing: Decodable {
        
        let name: String
        let points: Int
        
        init(json: JSON) throws {

            self.name = try Optionals.unwrap(json["name"].string)
            self.points = try Optionals.unwrap(json["points"].int)
        }
        
    }
    
    let onUpdate: Signal<ColorWars> = Signal<ColorWars>()
    
    let badge: String
    let getall: String
    
    private(set) var team: [thing]!
    
    required init(json: JSON) throws {
                
        // Load data from JSON
        self.badge = try Optionals.unwrap(json["badge"].string)
        self.getall = try Optionals.unwrap(json["bigcall"].string)
        
        self.team = try (json["team"].array ?? []).map({
            return try thing(json: $0)
        })
        
        // Receive updates on Lunch from the same day
        ColorWars.onFetch.subscribe(with: self) {
            self.updateContent(from: $0)
        }
        
    }
    
    var hasItems: Bool {
        return !self.team.isEmpty
    }
    
    func updateContent(from: ColorWars) {
        self.team = from.team
        self.onUpdate.fire(self)
    }

    @discardableResult
    func refresh() -> CallbackSignal<ColorWars> {
        // Fetches a new Lunch object which then updates this one
        return ColorWars.fetch(self.badge)
    }
    
}


extension ColorWars {
    
    static let onFetch = Signal<ColorWars>()
    private static var activeFetches: [String: CallbackSignal<ColorWars>] = [:]
    
    static func fetch(_ badge: String) -> CallbackSignal<ColorWars> {
        // If there's another active signal already happening, we tag onto it.
        if let activeSignal = ColorWars.activeFetches[badge] {
            return activeSignal
        }
        
        let signal = CallbackSignal<ColorWars>()
        
        ColorWars.activeFetches[badge] = signal
        
        // Fetch Lunch object
        let provider = MoyaProvider<API>()
        provider.request(.getPointsBy(badge: badge)) {
//            TODO: Pathing for this
            switch $0 {
            case let .success(result):
                do {
                    _ = try result.filterSuccessfulStatusCodes()
                    
                    let json = try JSON(data: result.data)
                    print("badgeways")
                    let colorwars = try ColorWars(json: json)
                    
                    signal.fire(.success(colorwars))
                    
                    // Notify listeners that a new Lunch object has been fetched
                    ColorWars.onFetch.fire(colorwars)
                } catch {
                    signal.fire(.failure(error))
                }
            case let .failure(error):
                signal.fire(.failure(error))
            }
        }
        
        // Remove the signal from the active list
        signal.subscribeOnce(with: self) { _ in
            ColorWars.activeFetches.removeValue(forKey: badge)
        }
        
        // Print errors
        signal.subscribeOnce(with: self) {
            switch $0 {
            case .failure(let error): print(error.localizedDescription)
            default: break
            }
        }
        
        return signal
    }
    
    static func fetch(for: String) -> CallbackSignal<ColorWars> {
        let signalId = `for`
        
        // If there's another active signal already happening, we tag onto it.
        if let activeSignal = ColorWars.activeFetches[signalId] {
            return activeSignal
        }
        
        let signal = CallbackSignal<ColorWars>()
        
        ColorWars.activeFetches[signalId] = signal
        
        // Fetch Lunch object
        let provider = MoyaProvider<API>()
        provider.request(.getPointsFor(team: `for`)) {
//            TODO: Path for this
            switch $0 {
            case let .success(result):
                do {
                    _ = try result.filterSuccessfulStatusCodes()
                    
                    let json = try JSON(data: result.data)
                    print(json)
                    let colorwars = try ColorWars(json: json)
                
                    signal.fire(.success(colorwars))
                    
                    // Notify listeners that a new ColorWars object has been fetched
                    ColorWars.onFetch.fire(colorwars)
                } catch {
                    signal.fire(.failure(error))
                }
            case let .failure(error):
                signal.fire(.failure(error))
            }
        }
        
        // Remove the signal from the active list
        signal.subscribeOnce(with: self) { _ in
            ColorWars.activeFetches.removeValue(forKey: signalId)
        }
        
        return signal
    }

}



