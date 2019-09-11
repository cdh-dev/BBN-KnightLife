//
//  Scheme.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

enum Scheme {
	
	case blue
	
	case main
	case backgroundMedium
	case backgroundColor
	
	case blackWhiteText
    case darkLightGreyText
	case text
	case lightText
	
	case nullColor
	
	case hollowText
	
	case dividerColor
    
    case redColor
	
	var color: UIColor {
		switch self {
		case .blue:
            return UIColor(named: "assetBlue")!
		case .main:
            return UIColor(named: "assetWhiteBlack")!
		case .backgroundMedium:
            return UIColor(named:"assetBackgroundLightGrey")!
		case .backgroundColor:
            return UIColor(named:"assetBlackWhiteText")!
		case .blackWhiteText:
			return UIColor(named: "assetBlackWhiteText")!
        case .darkLightGreyText:
            return UIColor(named: "assetDarkGreyLightGreyText")!
		case .text:
            return UIColor(named: "assetText")!
		case .lightText:
            return UIColor(named: "assetLightText")!
		case .nullColor:
            return UIColor(named:"assetNullColor")!
		case .hollowText:
			return UIColor(named: "assetHollowText")!
		case .dividerColor:
            return UIColor(named:
                "assetDividerColor")!
        case .redColor:
            return UIColor(named:"assetRed")!
		}
	}
	
}
