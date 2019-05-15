//
//  NotesController.swift
//  Notes
//
//  Created by Богдан Воробйовський on 5/15/19.
//  Copyright © 2019 Vorobiovskiy. All rights reserved.
//

import UIKit

//extension NotesController: NoteDelegate {
//    func saveNewNote(date: Date, text: String) {
//        let newNote = NoteModel(text: text, date: date)
////        let newNote = CoreDataManager.shared.createNewNote(date: date, text: text)
//        notesArray.append(newNote)
////        filteredNotes.append(newNote)
//        self.tableView.insertRows(at: [IndexPath(row: notes.count - 1, section: 0)], with: .fade)
//        print(date, text)
//    }
//    
//    
//}

var notesArray = [
    NoteModel(text: "table views use protocols to recieve data.", date: Date()),
    NoteModel(text: "collection views can be customized with flow layouts to create layouts like you see in the Pinterest app.", date: Date()),
    NoteModel(text: "custom layouts can be made with UICollectionViewFlowLayout", date: Date())
]

class NotesController: UITableViewController {
    
    fileprivate var notes = [Note]()
    fileprivate var filteredNotes = [NoteModel]()
    
    fileprivate let CELL_ID: String = "CELL_ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Notes"
        
        
    }
    
    @IBAction func createNewNote(_ sender: Any) {
        
    }
    
    
    
}

extension NotesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! NoteCell
        let noteForRow = notesArray[indexPath.row]
        cell.noteData = noteForRow
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}






