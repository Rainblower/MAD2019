//
//  User+CoreDataProperties.swift
//  
//
//  Created by Rainblower on 04/06/2019.
//
//

import Foundation
import CoreData

class User: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var rememberme: Bool
    @NSManaged public var token: String?

}
