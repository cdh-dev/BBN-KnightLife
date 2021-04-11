//
//  NoteTestViewController.swift
//  Glancer
//
//  Created by Henry Price on 4/6/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//

import UIKit

class NoteTestViewController: UIViewController {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteDate: UILabel!
    @IBOutlet weak var noteTextTextView: UITextView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let topicLabel = noteTitleLabel,
               let dateLabel = noteDate,
               let textView = noteTextTextView {
                topicLabel.text = detail.noteTitle
                dateLabel.text = NoteDateHelper.convertDate(date: Date.init(seconds: detail.noteTimeStamp))
                textView.text = detail.noteText
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: NoteData? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChangeNoteSegue" {
            let changeNoteViewController = segue.destination as! NoteCreateChangeViewController
            if let detail = detailItem {
                changeNoteViewController.setChangingNote(
                    changingNote: detail)
            }
        }
    }
}

