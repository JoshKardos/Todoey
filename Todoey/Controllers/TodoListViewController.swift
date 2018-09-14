//
//  ViewController.swift
//  Todoey
//
//  Created by Josh Kardos on 9/12/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

	var selectedCategory : Category?{
		didSet{
			loadItems()
		}
	}
	
	var itemArray = [Item]()
	//let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()


	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: - Tableview Methods
	
	//rows in table
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		let item = itemArray[indexPath.row]
		
		cell.textLabel?.text = item.title
		
		//is cell accessory done, if so set to checkmark if not set to none
		cell.accessoryType = item.done ? .checkmark :.none
		
		return cell
	}
	
	//MARK: - Tableview delegate methods
	
	//when a cell is clicked
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//switch checks sign on/off
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		//delete from array when the cell is clicked
		//context.delete(itemArray[indexPath.row])
		//itemArray.remove(at: indexPath.row)
		
	
		//Update plist
		self.saveItems()
		
		tableView.deselectRow(at: indexPath, animated: true)		
	}
	
	//MARK: - Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
	
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
		
		//on add item button clicked
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

			//Create new item
			let newItem = Item(context: self.context)
			newItem.title = textField.text!
			newItem.done = false
			newItem.parentCategory = self.selectedCategory
			
			
			//add to list of to do items
			self.itemArray.append(newItem)
			
			//save
			self.saveItems()
			
		}
		
		//Create alert
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		
		}
		
		//add alert
		alert.addAction(action)
		present(alert, animated: true,completion: nil)
	}
	
	
	//MARK: - Model Manipulation Methods
	
	//Create
	//updates the plist
	//called whenever there is a change in the table view cells
	func saveItems(){
		do{
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		tableView.reloadData()
	}
	
	//Read
	//called when application starts
	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
		
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
		} else {
			request.predicate = categoryPredicate
		}
		
		do {
			itemArray = try context.fetch(request)
		} catch {
			print("ERROR \(error)")
		}
		tableView.reloadData()
	}
	
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
	
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		
		//query item that contains the text in search bar
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		loadItems(with: request, predicate: predicate)
		
	}
	
	//search bar text changed
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadItems()
			
			//Disaptch Queue object assigns projects to different thread
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
			
			
			
		}
	}
	
}
