//
//  TimeInterval+Formatting.swift
//  EverlandMap
//
//  Created by 루딘 on 7/4/24.
//

import Foundation

fileprivate let formatter: DateComponentsFormatter = {
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "ko_kr")
    
    let f = DateComponentsFormatter()
    f.calendar = calendar
    f.allowedUnits = [.hour, .minute]
    f.unitsStyle = .full
    return f
}()

extension TimeInterval{
    var timeString: String?{
        let comp = DateComponents(second: Int(self))
        return formatter.string(from: comp)
    }
}
