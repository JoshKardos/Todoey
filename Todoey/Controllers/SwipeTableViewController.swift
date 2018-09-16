//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Josh Kardos on 9/15/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.separatorColor = .black
		
		tableView.rowHeight = 80.0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
		
		//cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
		
		cell.delegate = self
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard orientation == .right else { return nil }
		
		let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
			self.updateModel(at: indexPath)
			print("DELETE CELL")
//			if let categoryToDelete = self.categories?[indexPath.row]{
//				do {
//					try self.realm.write {
//						self.realm.delete(categoryToDelete)
//					}
//				} catch {
//					print("ERROR DELETING DATEGORY")
//				}
//
//			}
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
	
	func updateModel(at indexPath: IndexPath){
		//update
		
		
		
	}
	
	
	
	
}
