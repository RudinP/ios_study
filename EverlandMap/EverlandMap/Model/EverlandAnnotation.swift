//
//  EverlandAnnotation.swift
//  EverlandMap
//
//  Created by 루딘 on 6/27/24.
//

import Foundation
import MapKit
import CoreLocation

class EverlandAnnotation: NSObject, MKAnnotation{
    @objc dynamic var coordinate: CLLocationCoordinate2D
    let properties: Property
    
    init(coordinate: CLLocationCoordinate2D, properties: Property) {
        self.coordinate = coordinate
        self.properties = properties
    }
    
    var title: String?{
        return properties.name
    }
    
    var subtitle: String? {
        return properties.desc
    }
    
    var category: Category?{
        return Category(rawValue:  properties.category)
    }
    
    var image: UIImage? {
        guard let category else {return nil}
        
        return UIImage(named: category.rawValue)
    }
}
