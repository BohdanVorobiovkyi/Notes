//
//  NotesController.swift
//  Notes
//
//  Created by Богдан Воробйовський on 5/15/19.
//  Copyright © 2019 Vorobiovskiy. All rights reserved.
//

import UIKit

var notesArray = [
    NoteModel(text: "table views use protocols to recieve data.", date: Date()),
    NoteModel(text: "collection views can be customized with flow layouts to create layouts like you see in the Pinterest app.", date: Date()),
    NoteModel(text: "custom layouts can be made with UICollectionViewFlowLayout", date: Date())
]

class NotesController: UITableViewController {
    
    fileprivate var notes = [Note]()
    
    
    fileprivate let CELL_ID: String = "CELL_ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Notes"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTranslucentViews()
    }
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailController = NoteDetailController()
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
}






