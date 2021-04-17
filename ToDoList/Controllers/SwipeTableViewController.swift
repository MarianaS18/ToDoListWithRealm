//
//  SwipeTableViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 17/04/2021.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // creates a new cell from the prototype cell "Cell" and it gets created as a SwipeTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        // sets the calls delegate as this current class which is the SwipeTableViewController to enable all the delegates methods to work
        cell.delegate = self
        return cell
    }
    
    // responsible for handling what should happen when a user actually swipes on the cells
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        // checks if the orientation of the swipe is from the right
        guard orientation == .right else { return nil }

        // closure that hanles what should happen when the cell gets swiped
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
           
            self.updateModel(at: indexPath)
            

            }

        // add the image to that part of the cell that is going to show when we swipe on the cell
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update our data model
    }
    
}

