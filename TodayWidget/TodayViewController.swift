//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import UIKit
import NotificationCenter
import AddictiveLib

class TodayViewController: UIViewController, NCWidgetProviding {
	
	private var state: TodayManager.ScheduleState? // Null if error
	
	@IBOutlet weak var activeStack: UIStackView!
	var activeView: UIView?
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	private func setup() {
		Globals.BundleID = "MAD.BBN.KnightLife.TodayWidget"
		Globals.StorageID = "group.KnightLife.MAD.Storage"
		
		Globals.storeUrlBase(url: "https://www.bbnknightlife.com/api/")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.registerListener()
		
		_ = TodayM
		self.handleStateChange(state: TodayM.state)
	}
	
	private func registerListener() {
		TodayM.onStateChange.subscribe(with: self) { state in
			self.handleStateChange(state: state)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		TodayM.startTimer()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		TodayM.stopTimer()
	}
	
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		TodayM.fetchTodayBundle().subscribeOnce(with: self) {
			switch $0 {
			case .success(_):
				completionHandler(.newData)
			case .failure(_):
				completionHandler(.failed)
			}
		}
	}
	
	private func handleStateChange(state: TodayManager.ScheduleState?) {
		self.state = state
		self.updateViews()
	}
	
	@IBAction func openContainingApp(_ sender: Any) {
		self.extensionContext?.open(URL(string: "MAD.BBN.KnightLife.URL.OpenApp://")!, completionHandler: nil)
	}
	
	private func updateViews() {
		guard let state = self.state else {
			self.setView(view: NoConnectionView())
			return
		}
		
		switch state {
		case .ERROR:
			self.setView(view: NoConnectionView())
		case .LOADING:
			self.setView(view: LoadingView())
		case .NO_CLASS(_, _):
			self.setView(view: NoClassView())
		case .AFTER_SCHOOL(_, _):
			self.setView(view: AfterSchoolView())
		case let .IN_CLASS(bundle, block, _, minutes):
			self.setView(view: InClassView(schedule: bundle.schedule, block: block, minutes: minutes))
		case let .BETWEEN_CLASS(bundle, block, minutes):
			self.setView(view: BetweenClassView(schedule: bundle.schedule, block: block, minutes: minutes))
		case let .BEFORE_SCHOOL(bundle, block, minutes):
			self.setView(view: BeforeSchoolView(schedule: bundle.schedule, block: block, minutes: minutes))
		case let .BEFORE_SCHOOL_GET_TO_CLASS(bundle, block, minutes):
			self.setView(view: BetweenClassView(schedule: bundle.schedule, block: block, minutes: minutes))
		}
	}
	
	func setView(view: UIView) {
		if let activeView = self.activeView {
			activeView.removeFromSuperview()
			self.activeView = nil
		}
		
		self.activeStack.addArrangedSubview(view)
		self.activeView = view
	}
	
}
