//
//  ColorWarCell.swift
//  Glancer
//
//  Created by Henry Price on 12/6/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import TableManager

class UIColorWarCell: UITableViewCell {
    
    @IBOutlet weak var teamLabel: UILabel!
    
    @IBOutlet weak var pointLabel: UILabel!
    
    static let rowConfiguration: Row.Configuration = { row, cell, path in
        // Cast cell to relevant class
        let cell = cell as! UIColorWarCell
//        let food = row.object as! ColorWars.thing
        let food = row.object as! Lunch.Food
        
        row.setHeightAutomatic()
        
        // Delete all previously added attachments
//        cell.attachmentsStack.arrangedSubviews.forEach({ cell.attachmentsStack.removeArrangedSubview($0) ; $0.removeFromSuperview() })
        
        cell.teamLabel.text = food.name
        print(food.name)
//        cell.pointLabel.text = String(food.points)
        
        // Set allergy attachment
//        if let allergy = food.allergy {
//            let attachment = LunchItemAttachmentView()
//            attachment.text = allergy
//            cell.attachmentsStack.addArrangedSubview(attachment)
//        }
        
        // Change the bottom constraint depending on whether or not there's an allergy warning
//        cell.attachmentsBottomConstraint.constant = cell.attachmentsStack.arrangedSubviews.count > 0 ? 10.0 : 0.0
    }
}


//class ColorWarCell: TableCell {
//    private let controller: ColorWarController
//    private let composite: CompositeTeam
//    
//    init(controller: ColorWarController, composite: CompositeTeam) {
//        self.controller = controller
//        self.composite = composite
//        
//        super.init("block", nib: "ColorWarCell")
//        
//        self.setEstimatedHeight(70)
//        self.setSelectionStyle(.none)
//        
//        self.setCallback() {
//            template, cell in
//            
//            if let blockCell = cell as? UIBlockCell {
//                self.layout(cell: blockCell)
//            }
//        }
//    }
//    
//    private func layout(cell: UIBlockCell) {
//            let analyst = self.composite.block.analyst
//            let block = self.composite.block
//            
//    //        Setup
//            cell.nameLabel.text = analyst.displayName
//            cell.blockNameLabel.text = block.id.displayName
//            
//            cell.fromLabel.text = block.schedule.start.prettyTime
//            cell.toLabel.text = block.schedule.end.prettyTime
//            
//            cell.locationLabel.text = analyst.location
//            
//    //        Formatting
//            var heavy = !analyst.courses.isEmpty
//            if block.id == .lab, let before = self.composite.schedule.selectedTimetable!.getBlockBefore(block: block) {
//                if !before.analyst.courses.isEmpty {
//                    heavy = true
//                }
//            }
//            
//            cell.nameLabel.font = UIFont.systemFont(ofSize: 22, weight: heavy ? .bold : .semibold)
//            cell.nameLabel.textColor = analyst.color
//            
//            cell.tagIcon.image = cell.tagIcon.image!.withRenderingMode(.alwaysTemplate)
//            cell.rightIcon.image = cell.rightIcon.image!.withRenderingMode(.alwaysTemplate)
//            
//    //        Attachments
//            for arranged in cell.attachmentsStack.arrangedSubviews { cell.attachmentsStack.removeArrangedSubview(arranged) ; arranged.removeFromSuperview() }
//            
////            if block.id == .lunch {
////                if let menu = self.composite.lunch {
////                    let lunchView = LunchAttachmentView(menuName: menu.title)
////                    lunchView.clickHandler = {
////                        self.controller.openLunch(menu: menu)
////                    }
////                    cell.attachmentsStack.addArrangedSubview(lunchView)
////                }
////            }
//            
//            for event in composite.events {
//                if !event.gradeRelevant {
//                    continue // Don't show if it's not relevant
//                }
//                
//                let view = EventAttachmentView()
//                view.text = event.oldCompleteTitle
//                cell.attachmentsStack.addArrangedSubview(view)
//            }
//            
//            cell.attachmentStackBottomConstraint.constant = cell.attachmentsStack.arrangedSubviews.count > 0 ? 10.0 : 0.0
//        }
//}
//
//class UIColorWarCell: UITableViewCell {
//    @IBOutlet weak var teamLabel: UILabel!
//    
//    @IBOutlet weak var pointLabel: UILabel!
//}
