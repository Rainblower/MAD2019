//
//  User.swift
//  01_wskpolice
//
//  Created by Admin on 16.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: String?
    let login: String?
    let name: String?
    let token: String?
}
