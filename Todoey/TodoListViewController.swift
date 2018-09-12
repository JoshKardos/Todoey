//
//  ViewController.swift
//  Todoey
//
//  Created by Josh Kardos on 9/12/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
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
		cell.textLabel?.text = itemArray[indexPath.row]
		
		return cell
	}
	
	//MARK - Tableview delegate methods
	
	//when a cell is clicked
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//flash grey when cell is clicked
		tableView.deselectRow(at: indexPath, animated: true)

		//add a check mark to cell if it is selected, remove if there is already a checkmark
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
	}
	
	//MARK - Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
		
		//on add item button clicked
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//what happens when the user clicks the add itemm button on the alert
			print(textField.text)
			
			//add to list of to do items
			self.itemArray.append(textField.text!)
			
			//add new item to table
			self.tableView.reloadData()
			
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		
		}
		alert.addAction(action)
		present(alert, animated: true,completion: nil)
	}
	
	


}

