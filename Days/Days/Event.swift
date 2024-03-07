//
//  Event.swift
//  Days
//
//  Created by 루딘 on 2/29/24.
//

import UIKit

struct Event{
    enum Category: String, CaseIterable{
        case birthday
        case business
        case diet
        case wedding
        case travel
        case exam
        case love
        case soccer
        case baseball
        case basketball
        
        var title: String {
            switch self {
            case .birthday:
                return "생일"
            case .business:
                return "업무"
            case .diet:
                return "다이어트"
            case .wedding:
                return "결혼"
            case .travel:
                return "여행"
            case .exam:
                return "시험"
            case .love:
                return "연애"
            case .soccer:
                return "축구"
            case .baseball:
                return "야구"
            case .basketball:
                return "농구"
            }
        }
    }
    
    let date: Date
    let title: String
    
    let backgroundColor: UIColor
    let textColor: UIColor
    let icon: String
    //지금으로부터 이벤트까지의 dday
    let daysString: String?
    
    let dateString: String?
    
    let iconImage: UIImage?

    init(date: Date, title: String, backgroundColor: UIColor, textColor: UIColor, icon: String) {
        self.date = date
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.icon = icon
        
        if let day = date.days(from: Date.today) {
            daysString = if day >= 0 { "D-\(abs(day))" } else { "D+\(abs(day))"}
        } else {
            daysString = nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        dateString = formatter.string(from:date)
        
        iconImage = UIImage(named: icon)
    }
    
    init(data: ComposeData){
        self.init(date: data.date!, title: data.title!, backgroundColor: data.backgroundColor!, textColor: data.textColor!, icon: data.category!.rawValue)
    }
}

var events = [
    Event(date: Date(year: 2002, month: 5, day: 31), title: "한일 월드컵", backgroundColor: .systemBlue, textColor: .white, icon: "soccer"),
    Event(date: Date(year: 2022, month: 11, day: 20), title: "카타르 월드컵", backgroundColor: .brown, textColor: .white, icon: "soccer"),
    Event(date: Date(year: 2026, month: 6, day: 11), title: "북중미 월드컵", backgroundColor: .green, textColor: .black, icon: "soccer")
]
