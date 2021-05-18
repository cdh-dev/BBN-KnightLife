//
//  NoteCreateChangeViewController.swift
//  Glancer
//
//  Created by Henry Price on 4/6/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//

import UIKit

class NoteCreateChangeViewController: UIViewController, UITextViewDelegate {
    
    var cheese: Course!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextTextView: UITextView! {
       didSet {
           noteTextTextView.delegate = self
       }
   }
    @IBOutlet weak var noteDoneButton: UIButton!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var noteBlockButton: UIButton!
    
    private let noteCreationTimeStamp : Int64 = Date().toSeconds()
    private(set) var changingNote : NoteData?

    @IBAction func noteTitleChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if self.changingNote != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( sender.text?.isEmpty ?? true ) || ( noteTextTextView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }
    
    
    @IBAction func blockAlertView(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "No Block Set", message: "What block does this note pertain too?", preferredStyle: .actionSheet)
        
        //        Array of tuples instead of dictionary so that it retains its order
        
        
        func myHandler(action: UIAlertAction){
            print("this ran")
            sender.setTitle(action.title, for: .normal)
        }
        
        for course in CourseM.courses {
            alert.addAction(UIAlertAction(title: course.name, style: .default, handler: myHandler))
        }
        //self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: myHandler))
        
        self.present(alert, animated: true)
        
    }
    

    @IBAction func doneButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
        // distinguish change mode and create mode
        if self.changingNote != nil {
            // change mode - change the item
            changeItem()
        } else {
            // create mode - create the item
            addItem()
        }
    }
    

    func setChangingNote(changingNote : NoteData) {
        self.changingNote = changingNote
    }
    
    private func addItem() -> Void {
        let note = NoteData(
            noteTitle:     noteTitleTextField.text!,
            noteText:      noteTextTextView.text,
            noteTimeStamp: noteCreationTimeStamp,
            noteBlock: noteBlockButton.currentTitle)

        NoteDataStorage.storage.addNote(noteToBeAdded: note)
        
        performSegue(
            withIdentifier: "backToMasterView",
            sender: self)
    }

    private func changeItem() -> Void {
        // get changed note instance
        if let changingNote = self.changingNote {
            // change the note through note storage
            NoteDataStorage.storage.changeNote(
                noteToBeChanged: NoteData(
                    noteId:        changingNote.noteId,
                    noteTitle:     noteTitleTextField.text!,
                    noteText:      noteTextTextView.text,
                    noteTimeStamp: noteCreationTimeStamp,
                    noteBlock: noteBlockButton.currentTitle)
            )
            // navigate back to list of notes
            performSegue(
                withIdentifier: "backToMasterView",
                sender: self)
        } else {
            // create alert
            let alert = UIAlertController(
                title: "Unexpected error",
                message: "Cannot change the note, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default ) { (_) in self.performSegue(
                                              withIdentifier: "backToMasterView",
                                              sender: self)})
            // show alert
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        initializeHideKeyboard()
        // set text view delegate so that we can react on text change
        noteTextTextView.delegate = self
        
        // check if we are in create mode or in change mode
        if let changingNote = self.changingNote {
            // in change mode: initialize for fields with data coming from note to be changed
            noteDateLabel.text = NoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
            noteTextTextView.text = changingNote.noteText
            noteTitleTextField.text = changingNote.noteTitle
            noteBlockButton.setTitle(changingNote.noteBlock, for: .normal)
            // enable done button by default
            noteDoneButton.isEnabled = true
        } else {
            // in create mode: set initial time stamp label
            noteDateLabel.text = NoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
        }
        
        // initialize text view UI - border width, radius and color
//        noteTextTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColors
        noteTextTextView.layer.borderWidth = 1.0
        noteTextTextView.layer.cornerRadius = 5
        
//        noteTextTextView.backgroundColor = Scheme.backgroundColor.color
//        noteTextTextView.textColor = Scheme.darkLightGreyText.color
//        noteDateLabel.textColor = Scheme.darkLightGreyText.color
//        noteTitleTextField.backgroundColor = Scheme.backgroundColor.color
//        noteTitleTextField.textColor = Scheme.darkLightGreyText.color

        // For back button in navigation bar, change text
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
        return self.textLimit(existingText: textView.text,
                              newText: text,
                              limit: 2048)
    }

    //Handle the text changes here
    func textViewDidChange(_ textView: UITextView) {
        if self.changingNote != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( noteTitleTextField.text?.isEmpty ?? true ) || ( textView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }

}

extension NoteCreateChangeViewController {
    func initializeHideKeyboard(){
    //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
        }
        @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
        }
}


private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}
