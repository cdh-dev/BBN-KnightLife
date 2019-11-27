//
//  TabBar.swift
//  Glancer
//
//  Created by Henry Price on 11/26/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Hero

class TabBar: UITabBar {
    @IBInspectable override var tintColor: UIColor! {
        didSet {
            self.tintColor = UIColor.orange
        }
    }
}
