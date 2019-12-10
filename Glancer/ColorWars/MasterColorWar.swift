//
//  MasterColorWar.swift
//  Glancer
//
//  Created by Henry Price on 12/9/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class ColorController: UIViewController, TableHandlerDataSource, ErrorReloadable {

    @IBOutlet weak var tableView: UITableView!
    var tableHandler: TableHandler!
    
    @IBOutlet weak var tableHeightAnchor: UIView!
    
    var date: Date!
    
    var bundle: Day?
    var bundleError: Error?
    var bundleDownloaded: Bool { return bundle != nil || bundleError != nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableHandler = TableHandler(table: self.tableView)
        self.tableHandler.dataSource = self
        
        self.registerListeners()
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerListeners()
        
        self.tableHandler.reload()
//        self.setupNavigationItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        TODO: UNREGISTER ON UNWIND.
        self.unregisterListeners()
    }
    
    func reloadData() {
        self.bundle = nil
        self.bundleError = nil
        
        self.tableHandler.reload()
        
        Day.fetch(for: self.date).subscribeOnce(with: self) {
            switch $0 {
            case .success(let day):
                self.bundle = day
                self.bundleError = nil
            case .failure(let error):
                self.bundle = nil
                self.bundleError = error
            }
            
            self.tableHandler.reload()
        }
    }
    
    func registerListeners() {
        Schedule.onFirstLunchChange.subscribe(with: self) { change in
            self.tableHandler.reload()
        }.filter({ $0.dayOfWeek == self.date.weekday })
        
        DeviceProfile.shared.onUserGradeChange.subscribe(with: self) { grade in
            self.tableHandler.reload()
        }
    }
    
    func unregisterListeners() {
        Schedule.onFirstLunchChange.cancelSubscription(for: self)
    }
    
//    func setupNavigationItem() {
//
//        self.navigationItem.title = self.date.prettyDate
//
//        if let subtitleItem = self.navigationItem as? SubtitleNavigationItem {
//            if let bundle = self.bundle {
//                if bundle.schedule.selectedTimetable?.special == true {
//                    subtitleItem.subtitle = "Special"
//                    subtitleItem.subtitleColor = .red
//
//                    return
//                }
//            }
//
//            subtitleItem.subtitle = nil
//            subtitleItem.subtitleColor = UIColor.darkGray
//        }
//    }
    
    func buildCells(handler: TableHandler, layout: TableLayout) {
//        self.setupNavigationItem()
        
        if !self.bundleDownloaded {
            layout.addModule(LoadingModule(table: self.tableView))
            return
        }
        
        if let _ = self.bundleError {
            layout.addModule(ErrorModule(table: self.tableView, reloadable: self))
            return
        }
        
//
//        layout.addModule(BlockListModule(controller: self, bundle: self.bundle!, title: nil, blocks: self.bundle!.schedule.selectedTimetable!.filterBlocksByLunch(), options: [.topBorder, .bottomBorder]))
        
        layout.addSection().addSpacerCell().setBackgroundColor(.clear).setHeight(35)
    }
    
    func openLunch(menu: ColorWars) {
        let controller = ColorWarController()
        
        controller.list = menu
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
