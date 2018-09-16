//
//  ViewController.swift
//  Todoey
//
//  Created by Josh Kardos on 9/12/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
	
	var todoItems: Results<Item>?
	let realm = try! Realm()
	
	var selectedCategory : Category?{
		didSet{
			loadItems()
		}
	}
	

	//let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

	override func viewDidLoad() {
		super.viewDidLoad()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: - Delete Data From Swipe
	override func updateModel(at indexPath: IndexPath) {
		if let itemToDelete = self.todoItems?[indexPath.row]{
			do {
				try self.realm.write {
					self.realm.delete(itemToDelete)
				}
			} catch {
				print("ERROR DELETING Item")
			}
			
		}
	}
	
	
	//MARK: - Tableview Methods
	
	//rows in table
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems?.count ?? 1
	}
	
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		if let item = todoItems?[indexPath.row] {

			cell.textLabel?.text = item.title
			
			if let color = UIColor(hexString: selectedCategory?.color).darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
				cell.backgroundColor = color
				cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)///ContrastColorOf(color, returnFlat: true)
			}
			
			//is cell accessory done, if so set to checkmark if not set to none
			cell.accessoryType = item.done ? .checkmark :.none
			
			print("******** ITEMS")
		
		} else {
		
			print("******** NO ITEMS")
			
			cell.textLabel?.text = "No Items Added"
		
		}

		return cell
	}
	
	//MARK: - Tableview delegate methods
	
	//when a cell is clicked
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = todoItems?[indexPath.row] {
			do {
				try realm.write {
					item.done = !item.done
			}
			} catch {
				print("ERROR SAVING DONE STATUS \(error)")
			}
		}
		tableView.reloadData()
		tableView.deselectRow(at: indexPath, animated: true)		
	}
	
	//MARK: - Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
	
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
		
		//on add item button clicked
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

			//Create new item
			if let currentCategory = self.selectedCategory {
				do{
					try self.realm.write {
						let newItem = Item()
						newItem.title = textField.text!
						newItem.dateCreated = Date()
						currentCategory.items.append(newItem)
					}
				
				} catch {
					print("eRRRO SAVING NEW ITEM< \(error)")
				}
				

			}
			
			self.tableView.reloadData()
			
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
	func saveItems(item: Item){
		do{
			try realm.write{
				realm.add(item)
			}
		} catch {
			print("Error saving context \(error)")
		}
		tableView.reloadData()
	}
	
	//Read
	//called when application starts
	func loadItems(){
		todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		tableView.reloadData()
	}
	
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		tableView.reloadData()
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
