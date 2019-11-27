//
//  Scheme.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/1/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

let currentDate = Date()
let calendar = Calendar.current
let componets = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month], from: currentDate)

enum April {
    case YES
    var lol: Bool{
        switch self {
        case .YES:
            if componets.month == 4 && componets.day == 1 {
                return true
            }
            else {
                return false
            }
        default:
            return false
        }
    }
}

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
	
	case dividerColor
    
    case redColor
    case darkGreyColor
    case blackColor
    
    case calenderText
    case calenderAndBlocksBackground
    case statusCell
    
    case attachmentBlue
    case attachmentYellow
    case attachmentGreen
    case attachmentRed
    case attachmentOrange
	
	var color: UIColor {
        if April.YES.lol == false {
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
            case .dividerColor:
                return UIColor(named:
                    "assetDividerColor")!
            case .redColor:
                return UIColor(named:"assetRed")!
            case .darkGreyColor:
                return UIColor(named: "assetDarkGrey")!
            case .blackColor:
                return UIColor(named: "assetBlack")!
            case .calenderText:
                return UIColor(named: "assetCalenderText")!
            case .calenderAndBlocksBackground:
                return UIColor(named: "assetWhiteSuperDarkGrey")!
            case .attachmentBlue:
                return UIColor(named: "attachmentBlue")!
            case .attachmentYellow:
                return UIColor(named: "attachmentYellow")!
            case .attachmentGreen:
                return UIColor(named: "attachmentGreen")!
            case .attachmentRed:
                return UIColor(named: "attachmentRed")!
            case .attachmentOrange:
                return UIColor(named: "attachmentOrange")!
            case .statusCell:
                return UIColor(named: "statusCell")!
            }
        }
        else{
            switch self {
                case .blue:
                    return UIColor(named: "assetBlue")!
                case .main:
                    return UIColor(named: "backgrounds")!
                case .backgroundMedium:
                    return UIColor(named:"backgrounds")!
                case .backgroundColor:
                    return UIColor(named:"backgrounds")!
                case .blackWhiteText:
                    return UIColor(named: "text")!
                case .darkLightGreyText:
                    return UIColor(named: "text")!
                case .text:
                    return UIColor(named: "text")!
                case .lightText:
                    return UIColor(named: "text")!
                case .nullColor:
                    return UIColor(named:"text")!
                case .dividerColor:
                    return UIColor(named:
                        "backgrounds")!
                case .redColor:
                    return UIColor(named:"assetRed")!
                case .darkGreyColor:
                    return UIColor(named: "backgrounds")!
                case .blackColor:
                    return UIColor(named: "text")!
                case .calenderText:
                    return UIColor(named: "text")!
                case .calenderAndBlocksBackground:
                    return UIColor(named: "backgrounds")!
                case .attachmentBlue:
                    return UIColor(named: "attachmentBlue")!
                case .attachmentYellow:
                    return UIColor(named: "attachmentYellow")!
                case .attachmentGreen:
                    return UIColor(named: "attachmentGreen")!
                case .attachmentRed:
                    return UIColor(named: "attachmentRed")!
                case .attachmentOrange:
                    return UIColor(named: "attachmentOrange")!
                case .statusCell:
                    return UIColor(named: "backgrounds")!
                }
        }
	}
    
        
	
}
