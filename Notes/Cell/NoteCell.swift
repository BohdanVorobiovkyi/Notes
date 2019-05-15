//
//  NoteCell.swift
//  Notes
//
//  Created by Богдан Воробйовський on 5/15/19.
//  Copyright © 2019 Vorobiovskiy. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    
    var noteData: NoteModel!{
        didSet{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateLabel.text = dateFormatter.string(from: noteData.date )
            previewLabel.text = noteData.text
            print(noteData.text)
        }
    }
    
    
    
    
    
    
    //CoreData
//    var noteData: Note! {
//        didSet {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MM/dd/yy"
//            dateLabel.text = dateFormatter.string(from: noteData.date ?? Date())
//            previewLabel.text = noteData.text
//        }
//    }
    
}
