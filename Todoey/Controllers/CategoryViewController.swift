//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Simon Gadd on 10/05/2019.
//  Copyright © 2019 Stratus Systems Ltd. All rights reserved.
//

import UIKit
import CoreData
class  CategoryViewController: UITableViewController {

    var categories = [Category]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadCategories()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].title
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //categoryArray[indexPath.row].done = !categoryArray[indexPath.row].done
        
        saveCategories()
        
    }
    
    @IBAction func addCategoryPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        //Popup to show with Text field in UI Alert and append to array
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What will happen once the user clicks the add item button on our UI Alert
            
            // Append the text to the array
            
            let newCategory = Category(context: self.context)
            
            newCategory.title = textField.text!
            
            self.categories.append(newCategory)
            
            //Save the updated item array to the user defaults
            
            self.saveCategories()
            
        }
        
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Add a new category"
            textField = alerttextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }

}

