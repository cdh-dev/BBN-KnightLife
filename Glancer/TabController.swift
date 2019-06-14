//
//  TabController.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Hero

class TabController: UITabBarController {
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.hero.modalAnimationType = .fade
		self.hero.tabBarAnimationType = .none
		
		_ANIMATE_SPLASH_FADE = true
	}
	
}
