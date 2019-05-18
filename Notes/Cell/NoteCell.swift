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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    
    var noteData: Note!{
        didSet{
            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            timeFormatter.dateFormat = "HH:mm"
            dateLabel.text = dateFormatter.string(from: noteData.date!)
            timeLabel.text = timeFormatter.string(from: noteData.date!)
            previewLabel.text = noteData.text
        }
    }
}
