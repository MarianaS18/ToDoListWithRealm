//
//  Item.swift
//  ToDoList
//
//  Created by Mariana Steblii on 03/04/2021.
//

import Foundation
import RealmSwift

// Object is a class used to define Realm model objects
class Item: Object {
    // @objc dynamic need to be used always whan declaring properties in realm
    // @objc dynamic  helps realm to se changes
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    // relationships
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
