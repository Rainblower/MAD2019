//
//  Wanted.swift
//  01_wskpolice
//
//  Created by Admin on 18.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import Foundation

struct Wanted: Decodable {
    var id: String
    var status: String?
    var first_name: String?
    var last_name: String?
    var last_location: String?
    var nicknames: String?
    var description: String?
    var photo: String?
    
    var middle_name: String? = ""
    var isSelected: Bool? = false
}


