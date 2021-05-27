//
//  NoteTableViewController.swift
//  Glancer
//
//  Created by Henry Price on 4/6/21.
//  Copyright © 2021 Dylan Hanson. All rights reserved.
//

import UIKit

class NoteTableViewController: UITableViewController {
    
    var detailViewController: NoteTestViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dragInteractionEnabled = true // Enable intra-app drags for iPhone.
        
        // Core data initialization
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            // create alert
            let alert = UIAlertController(
                title: "Could note get app delegate",
                message: "Could note get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            // show alert
            self.present(alert, animated: true)

            return
        }
        
        // As we know that container is set up in the AppDelegates so we need to refer that container.
        // We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // set context in the storage
        NoteDataStorage.storage.setManagedContext(managedObjectContext: managedContext)
        NoteDataStorage.storage.IwantToKnowStuff()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? NoteTestViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            // When you click on a note,takes you to the proper view
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row]
                let object = NoteDataStorage.storage.readNote(at: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! NoteTestViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return NoteDataStorage.storage.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UINoteTableViewCell
        // Changes the table view to be the right note
        if let object = NoteDataStorage.storage.readNote(at: indexPath.row) {
        cell.noteTitleLabel!.text = object.noteTitle
        cell.noteTextLabel!.text = object.noteText
            cell.noteDateLabel!.text = NoteDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
            cell.noteBlockLabel!.text = object.noteBlock
        }
        return cell
    }
    
    
    func updateTableContentInset() {
        print("this ran")
        let numRows = self.tableView.numberOfRows(inSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tableView.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects.remove(at: indexPath.row)
            NoteDataStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}
