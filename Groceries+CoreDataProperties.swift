//
//  Groceries+CoreDataProperties.swift
//  My Shopping List
//
//  Created by Marina Andrés Aragón on 8/4/23.
//
//

import Foundation
import CoreData


extension Groceries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Groceries> {
        return NSFetchRequest<Groceries>(entityName: "Groceries")
    }

    @NSManaged public var element: String?

}

extension Groceries : Identifiable {

}
