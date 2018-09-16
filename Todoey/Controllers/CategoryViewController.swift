//
//  TableViewController.swift
//  Todoey
//
//  Created by Josh Kardos on 9/13/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
	
	let realm = try! Realm()
	
	var categories: Results<Category>?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	}

	//MARK: - Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
	
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
		
		//on add item button clicked
		let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
			
			//Create new item
			let newCategory = Category()
			newCategory.name = textField.text!
			
			//save
			self.saveCategories(category: newCategory)
			
		}
		
		//Create alert
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new Category"
			textField = alertTextField
			
		}
		
		//add alert
		alert.addAction(action)
		present(alert, animated: true,completion: nil)
	
	}
	
	//Create
	//updates the plist
	//called whenever there is a change in the table view cells
	func saveCategories(category: Category){
		do{
			try realm.write{
				realm.add(category)
			}
		} catch {
			print("Error saving context \(error)")
		}
		tableView.reloadData()
	}
	
	func loadCategories(){
		
		categories = realm.objects(Category.self)
		
		tableView.reloadData()
		
	}
	
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1
		//if categories is nil, return 1
    }
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		
		cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
		
		//is cell accessory done, if so set to checkmark if not set to none
		//cell.accessoryType = item.done ? .checkmark :.none
		
		return cell
	}
	
	//MARK: - Tableview delegate methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "GoToItems", sender: self)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController
		
		if let indexPath = tableView.indexPathForSelectedRow{
			destinationVC.selectedCategory = categories?[indexPath.row]
		}
		
	}

}
