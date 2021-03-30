//
//  NotesController.swift
//  Glancer
//
//  Created by Henry Price on 3/30/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import SafariServices
import Moya
import SwiftyJSON


class NotesController: UIViewController, TableHandlerDataSource {
    private(set) var tableHandler: TableHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableHandler.reload()
    }
    
    func buildCells(handler: TableHandler, layout: TableLayout) {
        layout.addModule(CoursesPrefModule(controller: self))
        layout.addModule(BlockPrefsModule(controller: self))
    }
}
