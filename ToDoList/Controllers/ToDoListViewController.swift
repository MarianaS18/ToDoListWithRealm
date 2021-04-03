//
//  ViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 02/04/2021.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        // did set runs when selected category gets set with a value
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - TableView Datasource methods
    
    // number of cells in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // create a cell and return it to the table view
    // method calls for every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        
        // add or remove a checkmark to celected cell
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK: - TableView Delegate methods
    
    // works with selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // remove an item from database
        // context.delete(itemArray[indexPath.row])
        // removes an item from array whitch is used to load up the tableview data source
        // itemArray.remove(at: indexPath.row)
        
        // checks done property
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // saves context to persistent container
        saveItems()
        
        // selection dissapears slowly 
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    // runs when user presses add(+) button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // create alert
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        // create action to alert
        // runs when user clicks "Add Item" on alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
        }
        
        // create textfield in the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // adds action to alert
        alert.addAction(action)
        
        // shows alert on the screen
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model Manipulation Methods
    func saveItems() {
      
    }
    
    // Item.fetchRequest() - fetches all items
    func loadItems() {
       
    }
}


// MARK: - UISearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {
    
    // this tells the delegate that the search button was tapped
    // and here we want to reload table view with the text, that user has tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // DispatchQueue is a manager who assign projekts to different threads
            DispatchQueue.main.async {
                // notifies that search bar is no longer selected and keybord should go away
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

