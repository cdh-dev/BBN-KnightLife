//
//  NoteTestViewController.swift
//  Glancer
//
//  Created by Henry Price on 4/6/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//

import UIKit

class NoteTestViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteDate: UILabel!
    @IBOutlet weak var noteBlock: UILabel!
    @IBOutlet weak var noteTextTextView: UITextView! {
        didSet {
            noteTextTextView.delegate = self
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let topicLabel = noteTitleLabel,
               let dateLabel = noteDate,
               let blockLabel = noteBlock,
               let textView = noteTextTextView {
                topicLabel.text = detail.noteTitle
//                topicLabel.textColor = Scheme.darkLightGreyText.color
                dateLabel.text = NoteDateHelper.convertDate(date: Date.init(seconds: detail.noteTimeStamp))
                blockLabel.text = detail.noteBlock
//                dateLabel.textColor = Scheme.darkLightGreyText.color
                textView.text = detail.noteText
//                textView.textColor = Scheme.darkLightGreyText.color
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
    
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        return self.textLimit(existingText: textView.text,
                              newText: text,
                              limit: 10)
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

