//
//  Date+Util.swift
//  Days
//
//  Created by 루딘 on 2/29/24.
//

import Foundation

extension Date{
    init(year: Int, month: Int, day: Int, hour: Int? = nil, minute: Int? = nil, second: Int? = nil){
        let calendar = Calendar.current
        
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        
        self = calendar.date(from: components) ?? Date(timeIntervalSinceReferenceDate: 0)
    }
    
    //d-day 계산
    func days(from date: Date) -> Int? {
        let calendar = Calendar.current
        
        let from = calendar.startOfDay(for: date)
        let to = calendar.startOfDay(for: self)
        
        return calendar.dateComponents([.day], from: from, to: to).day
    }
    
    //오늘 날짜
    static var today: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: .now)
    }
}
