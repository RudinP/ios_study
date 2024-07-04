//
//  Routes.swift
//  EverlandMap
//
//  Created by 루딘 on 7/4/24.
//

import Foundation
import CoreLocation
import MapKit

struct Routes{
    let start: CLPlacemark?
    let dest: CLPlacemark?
    let routes: [MKRoute]
}
