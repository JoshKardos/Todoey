//
//  ViewController.swift
//  Todoey
//
//  Created by Josh Kardos on 9/12/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var itemArray = [Item]()
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		print(dataFilePath)
		
		loadItems()

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK - Tableview Methods
	
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
	
	//MARK - Tableview delegate methods
	
	//when a cell is clicked
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//switch checks sign on/off
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
	
		//update plist
		self.saveItems()
		
		tableView.deselectRow(at: indexPath, animated: true)
		

	}
	
	//MARK - Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
	
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
		
		//on add item button clicked
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//what happens when the user clicks the add itemm button on the alert
			
			let newItem = Item()
			newItem.title = textField.text!
			
			//add to list of to do items
			self.itemArray.append(newItem)
			
			self.saveItems()
			
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		
		}
		alert.addAction(action)
		present(alert, animated: true,completion: nil)
	}
	
	
	//MARK - Model Manipulation Methods
	
	//updates the plist
	//called whenever there is a change in the table view cells
	func saveItems(){
		let encoder = PropertyListEncoder()
		do{
			let data = try encoder.encode(self.itemArray)
			try data.write(to: self.dataFilePath!)
		} catch {
			print("ERRROR**")
		}
		tableView.reloadData()
	}
	
	func loadItems(){
		
		if let data = try? Data(contentsOf: dataFilePath!){
			let decoder = PropertyListDecoder()
			do {
				itemArray = try decoder.decode([Item].self, from: data)
			} catch {
				print("ERROR DECODING ITEM ARRAY, \(error)")
			}
		}
	}
	


}

