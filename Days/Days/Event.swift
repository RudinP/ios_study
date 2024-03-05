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
    
    var dateString: String?{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from:date)
    }
    
    var iconImage: UIImage? {
        return UIImage(named: icon)
    }
}

var events = [
    Event(date: Date(year: 2002, month: 5, day: 31), title: "한일 월드컵", backgroundColor: .systemBlue, textColor: .white, icon: "soccer"),
    Event(date: Date(year: 2022, month: 11, day: 20), title: "카타르 월드컵", backgroundColor: .brown, textColor: .white, icon: "soccer"),
    Event(date: Date(year: 2026, month: 6, day: 11), title: "북중미 월드컵", backgroundColor: .green, textColor: .black, icon: "soccer")
]
