//
//  Category.swift
//  ToDoList
//
//  Created by Mariana Steblii on 03/04/2021.
//

import Foundation
import RealmSwift

// Object is a class used to define Realm model objects
class Category: Object {
    // @objc dynamic need to be used always whan declaring properties in realm
    // @objc dynamic  helps realm to se changes
    @objc dynamic var name: String = ""
    
    // relationships - each catecory can have a number of items
    let items = List<Item>()
}
