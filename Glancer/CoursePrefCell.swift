//
//  CoursePrefCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class CoursePrefCell: TableCell {
	
	init(module: CoursesPrefModule, course: Course) {
		super.init("coursepref", nib: "CoursePrefCell")
		
		self.setHeight(44)
		
		self.setSelection() {
			template, cell in
			
			module.presentCourse(course: course)
		}
		
		self.setCallback() {
			template, cell in
			
			guard let prefCell = cell as? UICoursePrefCell else {
				return
			}
			
			let selectedBackground = UIView()
			selectedBackground.backgroundColor = Scheme.backgroundMedium.color

			prefCell.blockStack.isHidden = false
			
			prefCell.titleLabel.text = course.name
			prefCell.titleLabel.textColor = course.color
			
			prefCell.blockLabel.text = course.scheduleBlock == nil ? "Not Set" : course.scheduleBlock!.displayName
			
			prefCell.tagImage.image = prefCell.tagImage.image?.withRenderingMode(.alwaysTemplate)
		}
	}
	
}

class UICoursePrefCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var blockLabel: UILabel!
	@IBOutlet weak var blockStack: UIStackView!
	
	@IBOutlet weak var tagImage: UIImageView!
	
}
