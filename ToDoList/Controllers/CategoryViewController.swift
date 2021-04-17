//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 03/04/2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // creates a new "database" localy
    let realm = try! Realm()
    
    // Result: when you try to query you realm database, the results you get back is in form of a Results object
    // Results is an auto-updating container type
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // shows where data is located
        // print(Realm.Configuration.defaultConfiguration.fileURL)
  
        loadCategories()
    }


    // MARK: - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // create alert
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // create action to alert
        // runs when user click "Add Category"
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        }
        
        // create textfield in the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        // adds action to alert
        alert.addAction(action)
        
        // shows alert on the screeen
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - TableView Data Source Methods
    
    // number of cells in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    // create a cell and return it to the table view
    // method calls for every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // goes into the super class and triggers the code inside the cellForRowAt indexPath
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            // modifies the cell by changing the text label
            cell.textLabel?.text = category.name
            
            // change the color of the cell
            cell.backgroundColor = UIColor(hexString: category.color)
        }
        
        return cell
    }
    
    
    // MARK: - TbaleView Delegate Methods
    
    // runs when we celect a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // change from CategoryViewController to ToDoLostViewController
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // runs just before performSegue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // we set the destination viewController to ToDoListViewController
        let destinationVC = segue.destination as! ToDoListViewController
        // we take the category that coresponds to the celected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    // MARK: - Data manipulation methods
    
    func loadCategories() {
        // get all the items inside our realm that are of Category objects
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            // commit the changes
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch{
                print("Error deleting the category")
            }
        }
    }
    
}

