//
//  TableViewController.swift
//  Todoey
//
//  Created by Josh Kardos on 9/13/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

	var categories = [Category]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
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
			let newCategory = Category(context: self.context)
			newCategory.name = textField.text!
			
			//add to list of to do items
			self.categories.append(newCategory)
			
			//save
			self.saveCategories()
			
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
	func saveCategories(){
		do{
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		tableView.reloadData()
	}
	
	func loadCategories(){
		let request : NSFetchRequest<Category> = Category.fetchRequest()
		do {
			categories = try context.fetch(request)
		} catch {
			print("ERROR LOADING CTEGORIES \(error)")
		}
		tableView.reloadData()
		
	}
	
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
    }
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		
		let category = categories[indexPath.row]
		
		cell.textLabel?.text = category.name
		
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
			destinationVC.selectedCategory = categories[indexPath.row]
		}
		
	}

}
