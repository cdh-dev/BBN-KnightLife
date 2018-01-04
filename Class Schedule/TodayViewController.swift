//
//  TodayViewController.swift
//  Class Schedule
//
//  Created by Dylan Hanson on 1/3/18.
//  Copyright © 2018 BB&N. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding
{
	@IBOutlet weak var statusLabel: UILabel!
	
	@IBOutlet weak var containerNow: UIView!
	@IBOutlet weak var containerNext: UIView!
	
	@IBOutlet weak var blockBackground: UIView!
	@IBOutlet weak var blockLabel: UILabel!
	
	@IBOutlet weak var curClassLabel: UILabel!
	@IBOutlet weak var curTimeLabel: UILabel!
	
	@IBOutlet weak var nextBlockLabel: UILabel!
	@IBOutlet weak var nextLabel: UILabel!
	
	var timer: Timer!
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		updateView()
		self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TodayViewController.updateTime), userInfo: nil, repeats: true)
	}
	
	override func viewWillDisappear(_ animated: Bool)
	{
		self.timer.invalidate()
		self.timer = nil
	}
	
	@objc func updateTime()
	{
		updateView()
	}
	
	func updateView()
	{
		let state = ScheduleManager.instance.getCurrentScheduleInfo()
		
		print(state)
		
		if state.scheduleState == .inClass
		{
			self.statusLabel.isHidden = true
			self.containerNow.isHidden = false
			
			self.blockBackground.backgroundColor = Utils.getUIColorFromHex(state.curBlock!.analyst.getColor())
			self.blockLabel.text = state.curBlock!.analyst.getDisplayLetter()
			
			self.curClassLabel.text = state.curBlock!.analyst.getDisplayName(true)
			self.curTimeLabel.text = "for \(state.minutesRemaining) min"
			
			if let nextBlock = state.nextBlock
			{
				containerNext.isHidden = false
				
				nextBlockLabel.text = nextBlock.analyst.getDisplayName(true)
				nextLabel.text = "next"
			} else
			{
				containerNext.isHidden = true
			}
		} else if state.scheduleState == .getToClass
		{
			self.statusLabel.isHidden = true
			self.containerNext.isHidden = true
			self.containerNow.isHidden = false
			
			self.blockBackground.backgroundColor = Utils.getUIColorFromHex(state.nextBlock!.analyst.getColor())
			self.blockLabel.text = String(state.minutesRemaining)
			
			self.curClassLabel.text = state.nextBlock!.analyst.getDisplayName(true)
			self.curTimeLabel.text = "get to class"
		} else if state.scheduleState == .beforeSchool
		{
			self.statusLabel.isHidden = true
			self.containerNext.isHidden = false
			self.containerNow.isHidden = false
			
			self.blockBackground.backgroundColor = Utils.getUIColorFromHex("999999")
			self.blockLabel.text = ""
			
			self.curClassLabel.text = "School Starts"
			self.curTimeLabel.text = "in \(state.minutesRemaining) min"
			
			self.nextBlockLabel.text = state.nextBlock!.analyst.getDisplayName(true)
			self.nextLabel.text = "first class"
		} else if state.scheduleState == .beforeSchoolGetToClass
		{
			self.statusLabel.isHidden = true
			self.containerNext.isHidden = true
			self.containerNow.isHidden = false
			
			self.blockBackground.backgroundColor = Utils.getUIColorFromHex(state.nextBlock!.analyst.getColor())
			self.blockLabel.text = String(state.minutesRemaining)
			
			self.curClassLabel.text = state.nextBlock!.analyst.getDisplayName(true)
			self.curTimeLabel.text = "get to class"
		} else if state.scheduleState == .noClass
		{
			self.statusLabel.isHidden = false
			self.statusLabel.text = "No school! Enjoy"
			
			self.containerNow.isHidden = true
			self.containerNext.isHidden = true
		} else if state.scheduleState == .afterSchool
		{
			self.statusLabel.isHidden = false
			self.statusLabel.text = "School is over"
			
			self.containerNow.isHidden = true
			self.containerNext.isHidden = true
		} else
		{
			self.statusLabel.isHidden = false
			self.statusLabel.text = "An error occured"
			
			self.containerNow.isHidden = true
			self.containerNext.isHidden = true
		}
	}
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void))
	{
        completionHandler(NCUpdateResult.newData)
    }
}
