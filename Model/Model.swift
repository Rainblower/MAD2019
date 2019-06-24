//
//  Model.swift
//  01_wskpolice
//
//  Created by Rainblower on 04/06/2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//


import Foundation
import CoreData
import UIKit

let appDelegete = UIApplication.shared.delegate as? AppDelegate

class Model{
    
    static let manageContext = appDelegete!.persistentContainer.viewContext
 
    static func getObject(entity : String) -> NSManagedObject{
        
        let ent = NSEntityDescription.entity(forEntityName: entity, in: manageContext)
        return  NSManagedObject(entity: ent!, insertInto: manageContext)
    }
    
    static func save(){
        do{
            try manageContext.save()
        }
        catch{
            print("Failed saving")
        }
    }
    
    static func getData(entityName: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        var data : [NSManagedObject] = []
        
        do {
            data = try manageContext.fetch(request) as! [NSManagedObject]
            
            
        } catch {
            
            print("Failed")

        }
        return data
    }
}

