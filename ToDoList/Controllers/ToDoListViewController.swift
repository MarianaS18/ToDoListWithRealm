//
//  ViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 02/04/2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var toDoItems: Results<Item>?
    
    // creates a new "database" localy
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        // did set runs when selected category gets set with a value
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let colorHex = selectedCategory?.color {
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist")
            }
            
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.backgroundColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                searchBar.barTintColor = navBarColor
            }
           
        }
    }
    
    // MARK: - TableView Datasource methods
    
    // number of cells in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    // create a cell and return it to the table view
    // method calls for every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // goes into the super class and triggers the code inside the cellForRowAt indexPath
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // change the color of cell
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = color
                // contrasting text
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            // add or remove a checkmark to celected cell
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        return cell
    }
    
    
    // MARK: - TableView Delegate methods
    
    // works with selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update and save data
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
            
            // create and save a new item
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new itesm, \(error)")
                }
            }
            self.tableView.reloadData()
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
    
    // Item.fetchRequest() - fetches all items
    func loadItems() {
        // get all the items from selected category and sort them aphabetecly
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Delete Item From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            }
            catch {
                print("Error deleting the item")
            }
        }
    }
}


// MARK: - UISearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {
    
    // this tells the delegate that the search button was tapped
    // and here we want to reload table view with the text, that user has tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // we take a list of items and filter them based on a text that user tapped and then we sort them by data of creating the item
        toDoItems = toDoItems?
            .filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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

