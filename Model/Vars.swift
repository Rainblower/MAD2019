//
//  Vars.swift
//  01_wskpolice
//
//  Created by Rainblower on 04/06/2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Model{
    
    func getEntity(entity : String) -> NSManagedObject?{
        
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let manageContext = appDelegete.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: entity, in: manageContext)
        return  NSManagedObject(entity: entity!, insertInto: manageContext)
    }
}
