//
//  NoteDetailVC.swift
//  Notes
//
//  Created by Богдан Воробйовський on 5/16/19.
//  Copyright © 2019 Vorobiovskiy. All rights reserved.
//

import UIKit

protocol NoteDelegate {
    func saveNewNote(text: String, date: Date)
}

class NoteDetailVC: UIViewController {
    
//    var delegate: NoteDelegate?
    var editable: Bool = false
    var interaction: Bool = true
//    let viewController = NoteDetailVC()
    fileprivate let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        return dateFormatter
    }()
    
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        editTextView.isUserInteractionEnabled = interaction
    }
    
    func setupUI() {
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem()]
        let topItems:[UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMode)),
            UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        ]
        //        if editable == true {
        //            topItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil))
        //        }
        
        self.navigationItem.setRightBarButtonItems(topItems, animated: false)
        
    }
    
    @objc func editMode() {
        editTextView.isUserInteractionEnabled = true
        editTextView.becomeFirstResponder()
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editIsDone))
        self.navigationItem.setRightBarButton(doneItem, animated: true)
    }
    
    @objc func editIsDone() {
        editTextView.isUserInteractionEnabled = false
        //        let destinationVC = NotesController()
        //        navigationController?.popViewController(animated: true)
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMode))
        self.navigationItem.setRightBarButton(editItem, animated: true)
        
        
    }
}
