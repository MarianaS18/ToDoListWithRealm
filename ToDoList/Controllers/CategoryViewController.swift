//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Mariana Steblii on 03/04/2021.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
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
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
}
