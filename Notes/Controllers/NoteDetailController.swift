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
    var interaction: Bool = false
    var hasChanges: Bool = false
    var hasBeenSaved : Bool = false
    
    fileprivate let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        return dateFormatter
    }()
    
    //MARK:- Note data from NotesViewController
    var noteData: Note! {
        didSet {
            textView.text = noteData.text
            dateLabel.text = dateFormatter.string(from: noteData.date ?? Date())
            savedItem = noteData.text!
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

    //MARK:- Setup navigationbar items
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backImage = UIImage(named: "back")
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        let spaceForItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backAction))
        let saveItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
        
        let leftItems: [UIBarButtonItem] = [ backButton]
        let topItems:[UIBarButtonItem] = [spaceForItem, shareItem, saveItem]

        self.navigationItem.setRightBarButtonItems(topItems, animated: false)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.setLeftBarButtonItems(leftItems, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
//        self.navigationController?.interactivePopGestureRecognizer!.delegate = self as? UIGestureRecognizerDelegate
        setMode()
        
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
    

    func setMode() {
        if interaction == true {
            editMode()
        } else {
            editIsDone()
        }
    }
    
    //____________________________________________
    
    var savedItem: String = ""
    fileprivate func saveNote() {
        if textView.hasText == true {
            if self.noteData == nil {
                delegate?.saveNewNote( text: textView.text, date: Date())
                hasChanges = false
                savedItem = textView.text
                hasBeenSaved = false
            } else {
                // update our note here.
                guard let newText = self.textView.text else { return }
                CoreDataManager.shared.saveUpdatedNote(note: self.noteData, newText: newText)
                hasChanges = false
                savedItem = textView.text
                hasBeenSaved = true
            }
        } else {print("TextView is Empty")}
    }
    
    func checkNewChanges() {
        let alert = UIAlertController(title: "No changes to save", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if textView.hasText == false {
            if noteData == nil {
                hasChanges = false
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            if self.noteData == nil {
                hasChanges = true
                hasBeenSaved = false
            } else {
                guard let note = noteData else {return}
                if textView.text == note.text {
                    hasChanges = false
                    //MARK:- Alert No changes to save
                    self.present(alert, animated: true, completion: nil)
                    
                    //    self.navigationController?.popViewController(animated: true)
                } else {
                    hasChanges = true
                    hasBeenSaved = false
                    
                }
            }
        }
    }
    func saveIfChanged() {
        let alert = UIAlertController(title: "No changes to save", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        let saveCompletedAlert = UIAlertController(title: "Save is completed", message: nil, preferredStyle: .alert)
        saveCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        if hasChanges == true {
            hasChanges = false
            saveNote()

            self.present(saveCompletedAlert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func saveAction() {
        checkNewChanges()
        saveIfChanged()
        
//        guard let note = noteData else {
////            navigationController?.popViewController(animated: true)
//            return}
//        if noteData != nil {
//        note.text = textView.text
//        note.date = Date()
//        }
    }
    
    func saveAlert() {
        let savingAlert = UIAlertController(title: "Changes are not saved", message: "Please save or discard changes", preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "Save" , style:.default , handler: { (action) in
            self.saveNote()
            self.navigationController?.popViewController(animated: true)
            return
        })
        let discardAction = UIAlertAction(title: "Discard changes" , style:.default , handler: { (action) in
            self.navigationController?.popViewController(animated: true)
            return
        })
        savingAlert.addAction(saveAction)
        savingAlert.addAction(discardAction)
        self.present(savingAlert, animated: true, completion: nil)
    }
    @objc func backAction() {
        
        let alert = UIAlertController(title: "No changes to save", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        let emptyAlert = UIAlertController(title: "Note can not be Empty", message: "Type any text, to save or discard changes", preferredStyle: .alert)
        let discardAction = UIAlertAction(title: "Discard changes" , style:.cancel , handler: { (action) in
            self.navigationController?.popViewController(animated: true)
            return
        })
        emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        emptyAlert.addAction(discardAction)
        
        //MARK:- Check before the Back Action
            if savedItem == textView.text! {
                navigationController?.popViewController(animated: true)
            } else {
                 if textView.hasText == true {
                saveAlert()
                 } else {
                    self.present(emptyAlert, animated: true)
                }
            }

        if textView.hasText == false {
            if noteData == nil {
                hasChanges = false
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            if self.noteData == nil {
                hasChanges = true
                saveAlert()
            } else {
                guard let note = noteData else {return}
                if textView.text == note.text {
                    hasChanges = false
                    //MARK:- Alert No changes to save
                    self.navigationController?.popViewController(animated: true)
                    
                    
                    //    self.navigationController?.popViewController(animated: true)
                } else {
                    hasChanges = true
                    saveAlert()
                    //    self.present(savingAlert, animated: true, completion: nil)
                }
            }
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

