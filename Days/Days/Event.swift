//
//  Event.swift
//  Days
//
//  Created by 루딘 on 2/29/24.
//

import UIKit

struct Event{
    let date: Date
    let title: String
    
    let backgroundColor: UIColor
    let textColor: UIColor
    let icon: String
    
    //지금으로부터 이벤트까지의 dday
    var daysString: String? {
        guard let day = date.days(from: Date.today) else { return nil }
        
        if day >= 0 {
            return "D-\(abs(day))"
        } else {
            return "D+\(abs(day))"
        }
    }
}
