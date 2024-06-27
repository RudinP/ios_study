//
//  Property.swift
//  EverlandMap
//
//  Created by 루딘 on 6/27/24.
//

import Foundation

struct Property: Codable{
    let name: String?
    let desc: String?
    let category: String
    let accessibleToDisabled: Bool?
}

