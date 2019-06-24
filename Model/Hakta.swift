//
//  Hakta.swift
//  01_wskpolice
//
//  Created by Admin on 16.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import Foundation

struct Hakta<T: Decodable>: Decodable {
    let data: T?
    let success: Bool
    let error: String?
}
