//
//  TeamListModule.swift
//  Glancer
//
//  Created by Henry Price on 12/6/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class TeamListModule: TableModule {

    let controller: ColorWarController

    let title: String?

    let bundle: ColorWars
    let teams: [ColorWars.thing]
//
//    let options: [DayModuleOptions]

    init(controller: ColorWarsViewController, bundle: ColorWars, title: String?, teams: [ColorWars.thing]) {
        self.controller = controller

        self.title = title

        self.bundle = bundle

        self.teams = teams
//        self.blocks = blocks
//
//        self.options = options

        super.init()
    }

    override func build() {
        if self.teams.isEmpty {
            return
        }

        let section = self.addSection()

//        if self.options.contains(.topBorder) { section.addDivider() }

        if let title = self.title {
            section.addCell(TitleCell(title: title))
            section.addDivider()
        }

        for teams in self.teams {
            let composite = CompositeTeam(name: self.bundle.getall, points: 23)

            section.addCell(ColorWarCell(controller: self.controller, composite: composite))

//            if self.blocks.last == block {
//                if self.options.contains(.bottomBorder) { section.addDivider() }
//            } else {
//                section.addDivider()
//            }
        }
    }

}

struct CompositeTeam {

    let name: String
    let points: Int

//    let schedule: Schedule
//    let block: Block
//
//    let lunch: Lunch?
//    let events: [Event]

}

