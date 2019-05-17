//
//  NotesController.swift
//  Notes
//
//  Created by Богдан Воробйовський on 5/15/19.
//  Copyright © 2019 Vorobiovskiy. All rights reserved.
//

import UIKit

extension NotesController: NoteDelegate {
    func saveNewNote(text: String, date: Date) {
        let newNote = CoreDataManager.shared.createNewNote(date: date, text: text)
        notes.append(newNote)
        filteredNotes.append(newNote)
        self.tableView.insertRows(at: [IndexPath(row: notes.count - 1, section: 0 )], with: .fade)
        print(text)
    }
}

class NotesController: UITableViewController {
    //MARK:- Stored properties
    
    fileprivate var notes = [Note]()
    fileprivate var filteredNotes = [Note]()
    var searchString: String = ""
    var cachedText: String = ""
    fileprivate let CELL_ID: String = "CELL_ID"
    fileprivate let headerView:UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: 15, width: 100, height: 20))
        label.text = "Local storage"
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .darkGray
        headerView.addBorder(toSide: .bottom, withColor: UIColor.lightGray.withAlphaComponent(0.5).cgColor, andThickness: 0.3)
        headerView.addSubview(label)
        return headerView
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notes"
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let navItems: [UIBarButtonItem] = [
//            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewNote)),
//            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(filterNotes))
//        ]
//        
//        navigationItem.rightBarButtonItems = navItems
        setupTranslucentViews()
        setupSearchBar()
        
        notes = CoreDataManager.shared.fetchNotes()
        filteredNotes = notes
    
        tableView.reloadData()
    }
    //MARK:- Create new note from navigation item
//    @objc func createNewNote() {
//        let destinationVC = NoteDetailVC()
//        destinationVC.delegate = self
//        destinationVC.editable = true
//        navigationController?.pushViewController(destinationVC, animated: true)
//    }
    @IBAction func createNewNote(_ sender: Any) {
//        let destinationVC = NoteDetailVC()
//        destinationVC.delegate = self
    }
    
    //MARK:- Fill the navigation bar
    fileprivate func getImage(withColor color: UIColor, andSize size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    fileprivate func setupTranslucentViews() {
        let toolBar = self.navigationController?.toolbar
        let navigationBar = self.navigationController?.navigationBar
        
        let slightWhite = getImage(withColor: UIColor.white.withAlphaComponent(0.9), andSize: CGSize(width: 30, height: 30))
        
        toolBar?.setBackgroundImage(slightWhite, forToolbarPosition: .any, barMetrics: .default)
        toolBar?.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        navigationBar?.setBackgroundImage(slightWhite, for: .default)
        navigationBar?.shadowImage = slightWhite
    }
    
     //MARK:- Search Bar
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    @objc fileprivate func filterNotes() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in })
        let fromNewFilterAction = UIAlertAction(title: "From new to old", style: .default, handler: { (action) in
            self.filteredNotes = CoreDataManager.shared.fetchFilteredRequest()
            self.tableView.reloadData()
        })
        let fromOldFilterAction = UIAlertAction(title: "From old to new", style: .default, handler: { (action) in
            self.filteredNotes = (CoreDataManager.shared.fetchFilteredRequest()).reversed()
            self.tableView.reloadData()
        })
        alert.addAction(fromOldFilterAction)
        alert.addAction(fromNewFilterAction)
        alert.addAction(cancelAction)
       
        present(alert, animated: true, completion: nil)
    }
    
}
//MARK:- SearchBarDelegate
extension NotesController: UISearchBarDelegate {
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNotes = notes.filter({ (note) -> Bool in
            return note.text?.lowercased().contains(searchText.lowercased()) ?? false
        })
        if searchBar.text!.isEmpty && filteredNotes.isEmpty {
            filteredNotes = notes
        }
        cachedText = searchText
        tableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !cachedText.isEmpty  {
            searchController.searchBar.text = cachedText
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filteredNotes = CoreDataManager.shared.fetchSearchRequest(searchText: searchBar.text!)
        cachedText = searchBar.text!
        tableView.reloadData()
    }
}

extension NotesController {
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("trying to delete item at indexPath:",indexPath)
            let targetRow = indexPath.row
            if CoreDataManager.shared.deleteNote(note: self.notes[targetRow]) {
                self.notes.remove(at: targetRow)
                self.filteredNotes.remove(at: targetRow)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        let shareAction = UITableViewRowAction(style: .normal, title: "Share") { (action, indexPath) in
            let dateFormatter: DateFormatter = {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
                return dateFormatter
            }()
            let targetRow = indexPath.row
            let textAtRow = self.filteredNotes[targetRow].text!
            let noteDateAtRow = dateFormatter.string(from: self.filteredNotes[targetRow].date ?? Date())
            let sharedPost: String = "\(textAtRow) \n published at \(noteDateAtRow)"
            let activityController = UIActivityViewController(activityItems: [sharedPost], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
           
        }
        
        actions.append(deleteAction)
        actions.append(shareAction)
        
        return actions
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! NoteCell
        let noteForRow = self.filteredNotes[indexPath.row]
        cell.noteData = noteForRow
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
            return dateFormatter
        }()
        let noteDetailController = NoteDetailVC()
        let noteData = self.filteredNotes[indexPath.row]
//        noteDetailController.noteData = noteData
        noteDetailController.dateLabel!.text = noteData.text
        noteDetailController.editTextView.text = dateFormatter.string(from: noteData.date ?? Date())
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == filteredNotes.count - 1 {
//            self.filteredNotes = CoreDataManager.shared.fetchNotes()
    //}
//        }
   
}






