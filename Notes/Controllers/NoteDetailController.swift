//
//  NoteDetailController.swift
//  Notes
//
//  Created by Богдан Воробйовський on 5/15/19.
//  Copyright © 2019 Vorobiovskiy. All rights reserved.
//

import UIKit

//MARK:- Note Detail controller delegate
protocol NoteDelegate {
    func saveNewNote(text: String, date: Date)
}

class NoteDetailController: UIViewController {
    
    var delegate: NoteDelegate?
    var editable: Bool = false
    var interaction: Bool = false
    fileprivate let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        return dateFormatter
    }()
    
    var noteData: Note! {
        didSet {
            textView.text = noteData.text
            dateLabel.text = dateFormatter.string(from: noteData.date ?? Date())
        }
    }
    
    
    //MARK:- Declare UI elements
    fileprivate var textView: UITextView = {
        let tf = UITextView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = ""
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.isEditable = true
        tf.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return tf
    }()
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        label.text = dateFormatter.string(from: Date())
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if textView.hasText == true {
            if self.noteData == nil {
                delegate?.saveNewNote( text: textView.text, date: Date())
            } else {
                // update our note here.
                guard let newText = self.textView.text else { return }
                CoreDataManager.shared.saveUpdatedNote(note: self.noteData, newText: newText)
            }
        } else {print("TextView is Empty")}
    }
    //MARK:- SetupUI
    fileprivate func setupUI() {
        view.addSubview(dateLabel)
        view.addSubview(textView)
        
        dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }
    
    //MARK:- Setup navigationbar items
//    func setupNavItems() {
//
//        navigationItem.rightBarButtonItems = [UIBarButtonItem()]
//        var topItems:[UIBarButtonItem] = [
//            UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMode)),
//            UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
//        ]
//                if interaction == true {
//                    topItems.append(UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil))
//                }
//
//        self.navigationItem.setRightBarButtonItems(topItems, animated: false)
//
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        let spaceForItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        let topItems:[UIBarButtonItem] = [spaceForItem, shareItem]

        self.navigationItem.setRightBarButtonItems(topItems, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        setMode()
    }
    
    
    func setMode() {
        if interaction == true {
            editMode()
        } else {
            editIsDone()
        }
    }
    @objc func shareAction() {
        let alert = UIAlertController(title: "Empty note!", message: "Please enter the text to share it!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK" , style:.cancel , handler: { (action) in
            self.editMode()
        })
        alert.addAction(alertAction)
        
        if textView.text.isEmpty {
            self.present(alert, animated: true, completion: nil)
        } else {
        let noteDateAtRow = dateFormatter.string(from: Date())
        let sharedPost: String = "\(String(describing: textView.text!)) \n published at \(noteDateAtRow)"
        let activityController = UIActivityViewController(activityItems: [sharedPost], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        }
    }
    @objc func editMode() {
        isActiveTextView()
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editIsDone))
        self.navigationItem.setRightBarButton(doneItem, animated: true)
    }
    
    @objc func editIsDone() {
        textView.isUserInteractionEnabled = false
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMode))
        self.navigationItem.setRightBarButton(editItem, animated: true)
    }
    
    func isActiveTextView() {
        textView.isUserInteractionEnabled = true
        textView.becomeFirstResponder()
    }
}


//TODO:- Pagination (batchSize = 20)

//TODO:- Editing mode for TextView




//@objc func editMode() {
//    self.editable = !self.editable
//    view.reloadInputViews()
//    print(self.editable)
//}
////    @objc func finishEditingMode() {
////        self.editable = false
////        print(self.editable)
////
////    }
//
//

//let items: [UIBarButtonItem] = [
//    UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil),
//    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//    UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil),
//    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//    UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil),
//    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//    UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil),
//    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//    UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
//]
//
//self.toolbarItems = items
