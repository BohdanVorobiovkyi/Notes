//
//  NoteDetailController.swift
//  Notes
//
//  Created by Богдан Воробйовський on 5/15/19.
//  Copyright © 2019 Vorobiovskiy. All rights reserved.
//

import UIKit



class NoteDetailController: UIViewController {

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        return dateFormatter
    }()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    var noteData:Note! {
        didSet {
            textView.text = noteData.text
            dateLabel.text = dateFormatter.string(from: noteData.date ?? Date())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let topItems:[UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        ]
        
        self.navigationItem.setRightBarButtonItems(topItems, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
//        if self.noteData == nil {
//            delegate?.saveNewNote(date: Date(), text: textView.text)
//        } else {
//            // update our note here.
//            guard let newText = self.textView.text else { return }
//            CoreDataManager.shared.saveUpdatedNote(note: self.noteData, newText: newText)
//        }
    }

}

