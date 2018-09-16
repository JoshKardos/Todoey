//
//  TableViewController.swift
//  Todoey
//
//  Created by Josh Kardos on 9/13/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController{
	
	let realm = try! Realm()
	
	var categories: Results<Category>?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.separatorColor = .black
		
		tableView.rowHeight = 80.0
		
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
			self.save(category: newCategory)
			
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
	func loadCategories(){
		
		categories = realm.objects(Category.self)
	
		tableView.reloadData()
		
	}
	func save(category: Category){
		do{
			try realm.write{
				realm.add(category)
			}
		} catch {
			print("Error saving context \(error)")
		}
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
	
	//text to put in category cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
		
		cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
		
		cell.delegate = self
		
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

//MARK: - Swipe Cell views delegate methods

extension CategoryViewController : SwipeTableViewCellDelegate{
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard orientation == .right else { return nil }
		
		let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
			if let categoryToDelete = self.categories?[indexPath.row]{
				do {
					try self.realm.write {
						self.realm.delete(categoryToDelete)
					}
				} catch {
					print("ERROR DELETING DATEGORY")
				}
				
			}
		}
		// customize the action appearance
		deleteAction.image = UIImage(named: "TrashIcon")
		
		return [deleteAction]
	}
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeOptions()
		options.expansionStyle = .destructive
		return options
	}
	
	
}
