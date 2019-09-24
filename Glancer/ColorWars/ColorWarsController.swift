//
//  ColorWarsController.swift
//  Glancer
//
//  Created by Henry Price on 9/11/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import Moya
import SwiftyJSON

class ColorWarController: UIViewController, TableHandlerDataSource, ErrorReloadable {
    
    
    var refreshListenerType: [PushRefreshType] = [.EVENTS]
    
    var date: Date!
    
    var bundle: Day?
    var bundleError: Error?
    var bundleDownloaded: Bool { return bundle != nil || bundleError != nil }
    
    @IBOutlet var colorWarView: ColorWarView!
    
    @IBOutlet weak var tableView: UITableView!
    var tableHandler: TableHandler!
    
    var upcomingItems: [(date: Date, items: [EventUpcomingItem])]?
    var upcomingItemsError: Error?
    var upcomingItemsLoaded: Bool {
        return self.upcomingItems != nil || self.upcomingItemsError != nil
    }
    
    func openDay(date: Date) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Day") as? DayController else {
            return
        }
        
        controller.date = date
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableHandler = TableHandler(table: self.tableView)
        self.tableHandler.dataSource = self
        
        self.colorWarView.setupViews()
        
        self.registerListeners()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.colorWarView.setupViews()
        self.setupNavigation()
        
        self.tableHandler.reload()
    }
    
    private func registerListeners() {
        TodayM.onNextDay.subscribe(with: self) { date in
            self.colorWarView.setupViews()
            self.setupNavigation()
            
            self.tableHandler.reload()
        }
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
    
    private func setupNavigation() {
        if let navigation = self.navigationItem as? SubtitleNavigationItem {
//            let formatter = Date.normalizedFormatter
//            formatter.dateFormat = "MMMM"
            navigation.subtitle = "Community"
        }
    }

   func buildCells(handler: TableHandler, layout: TableLayout) {
    
    if !self.bundleDownloaded {
        layout.addModule(LoadingModule(table: self.tableView))
        return
    }
    
    if let _ = self.bundleError {
        layout.addModule(ErrorModule(table: self.tableView, reloadable: self))
        return
    }
    
    layout.addModule(ColorWarEventsModule(bundle: self.bundle!, title: "Upcoming Color Wars", options: [.bottomBorder]))
    }
}
