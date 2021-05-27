//
//  NoteDataStorage.swift
//  Glancer
//
//  Created by Henry Price on 4/1/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//

import CoreData

class NoteDataStorage {
    static let storage : NoteDataStorage = NoteDataStorage()
    
    private var noteIndexToIdDict : [Int:UUID] = [:]
    private var currentIndex : Int = 0

    private(set) var managedObjectContext : NSManagedObjectContext
    private var managedContextHasBeenSet : Bool = false
    
    private init() {
        // we need to init our ManagedObjectContext
        // This will be overwritten when setManagedContext is called from the view controller.
        managedObjectContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.managedContextHasBeenSet = true
        let notes = NoteCoreDataHelper.readNotesFromCoreData(fromManagedObjectContext: self.managedObjectContext)
        currentIndex = NoteCoreDataHelper.count
        for (index, note) in notes.enumerated() {
            noteIndexToIdDict[index] = note.noteId
        }
    }
    
    func IwantToKnowStuff() {

        
        print(noteIndexToIdDict)
        
        var tempDict = noteIndexToIdDict
        var counter = 0
        
        for index in stride(from: noteIndexToIdDict.count - 1, to: -1, by: -1){
            
//            print(noteIndexToIdDict[index])
            tempDict.updateValue(noteIndexToIdDict[counter]!, forKey: index)
            counter += 1
        }
        
        print(tempDict)
        
        noteIndexToIdDict = tempDict
        
//        noteIndexToIdDict = tempDict
//        print("----------")
//        for val in noteIndexToIdDict {
//            print(val.value)
//        }
//        print("----------")
//        let fun = noteIndexToIdDict.sorted(by: {$0.key < $1.key})
//        print(fun)
    }
    
    func addNote(noteToBeAdded: NoteData) {
        if managedContextHasBeenSet {
            // add note UUID to the dictionary
            noteIndexToIdDict[currentIndex] = noteToBeAdded.noteId
            NoteCoreDataHelper.createNoteInCoreData(
                noteToBeCreated:          noteToBeAdded,
                intoManagedObjectContext: self.managedObjectContext)
            // increase index
            currentIndex += 1
        }
    }
    
    func removeNote(at: Int) {
        if managedContextHasBeenSet {
            // check input index
            if at < 0 || at > currentIndex-1 {
                // TODO error handling
                return
            }
            // get note UUID from the dictionary
            let noteUUID = noteIndexToIdDict[at]
            NoteCoreDataHelper.deleteNoteFromCoreData(
                noteIdToBeDeleted:        noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            // update noteIndexToIdDict dictionary
            // the element we removed was not the last one: update GUID's
            if (at < currentIndex - 1) {
                // currentIndex - 1 is the index of the last element
                // but we will remove the last element, so the loop goes only
                // until the index of the element before the last element
                // which is currentIndex - 2
                for i in at ... currentIndex - 2 {
                    noteIndexToIdDict[i] = noteIndexToIdDict[i+1]
                }
            }
            // remove the last element
            noteIndexToIdDict.removeValue(forKey: currentIndex)
            // decrease current index
            currentIndex -= 1
        }
    }
    
    func readNote(at: Int) -> NoteData? {
        if managedContextHasBeenSet {
            // check input index
            if at < 0 || at > currentIndex-1 {
                // TODO error handling
                return nil
            }
            let noteUUID = noteIndexToIdDict[at]
            let noteReadFromCoreData: NoteData?
            noteReadFromCoreData = NoteCoreDataHelper.readNoteFromCoreData(
                noteIdToBeRead:           noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            
            return noteReadFromCoreData
        }
        return nil
    }
    
    func changeNote(noteToBeChanged: NoteData) {
        if managedContextHasBeenSet {
            // check if UUID is in the dictionary
            var noteToBeChangedIndex : Int?
            noteIndexToIdDict.forEach { (index: Int, noteId: UUID) in
                if noteId == noteToBeChanged.noteId {
                    noteToBeChangedIndex = index
                    return
                }
            }
            if noteToBeChangedIndex != nil {
                NoteCoreDataHelper.changeNoteInCoreData(
                noteToBeChanged: noteToBeChanged,
                inManagedObjectContext: self.managedObjectContext)
            } else {
                // TODO error handling
            }
        }
    }

    
    func count() -> Int {
        return NoteCoreDataHelper.count
    }
}
