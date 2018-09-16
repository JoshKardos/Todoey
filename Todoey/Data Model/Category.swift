//
//  Category.swift
//  Todoey
//
//  Created by Josh Kardos on 9/15/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
	@objc dynamic var name : String = ""
	@objc dynamic var color : String = ""
	let items = List<Item> ()
}

