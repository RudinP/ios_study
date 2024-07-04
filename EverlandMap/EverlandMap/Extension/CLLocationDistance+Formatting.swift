//
//  CLLocationDistance+Formatting.swift
//  EverlandMap
//
//  Created by 루딘 on 7/4/24.
//

import Foundation
import CoreLocation

fileprivate let formatter: MeasurementFormatter = {
    let f = MeasurementFormatter()
    f.unitOptions = .naturalScale //저장한 값에 따라서 알맞은 포맷팅을 해줌
    f.locale = Locale(identifier: "ko_kr")
    f.numberFormatter.maximumFractionDigits = 0 //소수점 표시 X
    return f
}()

extension CLLocationDistance{
    var distanceString: String? {
        let distance = Measurement(value: self, unit: UnitLength.meters)
        return formatter.string(from: distance)
    }
}
