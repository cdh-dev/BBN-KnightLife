//
//  NoteTableModule.swift
//  Glancer
//
//  Created by Henry Price on 4/1/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

class NoteTableModule : TableModule {
    let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
        
        super.init()
    }
    
    override func build() {
        let section = self.addSection()
        
        section.addDivider()
        section.addCell(TitleCell(title: "Block Configuration"))
        section.addDivider()
        for index in 1...5  {
            section.addDivider()
            section.addCell(NoteTableCell(title: "test"))
        }
        section.addDivider()
    }
}
