//
//  NoteData.swift
//  Glancer
//
//  Created by Henry Price on 4/1/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//

import Foundation

class NoteData {
    private(set) var noteId        : UUID
    private(set) var noteTitle     : String
    private(set) var noteText      : String
    private(set) var noteTimeStamp : Int64
    private(set) var noteBlock     : String
    
    init(noteTitle:String, noteText:String, noteTimeStamp:Int64, noteBlock:String?) {
        self.noteId        = UUID()
        self.noteTitle     = noteTitle
        self.noteText      = noteText
        self.noteTimeStamp = noteTimeStamp
        self.noteBlock     = noteBlock ?? "No Block Set"
    }

    init(noteId: UUID, noteTitle:String, noteText:String, noteTimeStamp:Int64, noteBlock:String?) {
        self.noteId        = noteId
        self.noteTitle     = noteTitle
        self.noteText      = noteText
        self.noteTimeStamp = noteTimeStamp
        self.noteBlock     = noteBlock ?? "No Block Set"
    }
}
