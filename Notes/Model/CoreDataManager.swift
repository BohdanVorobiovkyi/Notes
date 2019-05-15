//
//  CoreDataManager.swift
//  Notes
//
//  Created by Богдан Воробйовський on 5/15/19.
//  Copyright © 2019 Vorobiovskiy. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of stores failed: \(err)")
            }
        })
        return container
    }()
    
    
    // NOTE FUNCTIONS
    func createNewNote(date: Date, text: String) -> Note {
        let context = persistentContainer.viewContext
        
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        

        newNote.text = text
        newNote.date = date
        
        
        do {
            try context.save()
            return newNote
        } catch let err {
            print("Failed to save new note folder:",err)
            return newNote
        }
    }
    
    func fetchNotes() -> [Note] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        
        do {
            let notes = try context.fetch(fetchRequest)
            return notes
        } catch let err {
            print("failed to fetch nore folders:",err)
            return []
        }
    }
    
    func deleteNote(note: Note) -> Bool {
        let context = persistentContainer.viewContext
        
        context.delete(note)
        
        do {
            try context.save()
            return true
        } catch let err {
            print("error deleting note entity instance",err)
            return false
        }
    }
    
    func saveUpdatedNote(note: Note, newText: String) {
        let context = persistentContainer.viewContext
        
//        note.title = newText
        note.text = newText
        note.date = Date()
        
        do {
            try context.save()
        } catch let err {
            print("error saving/updating note",err)
        }
        
    }
}

