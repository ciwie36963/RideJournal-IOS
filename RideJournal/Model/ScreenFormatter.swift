//
//  ScreenFormatter.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

struct ScreenFormatter {
    
    static func distance(_ distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        return formatter.string(from: distance)
    }
    
    static func distance(_ distance: Double) -> String {
        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
        return ScreenFormatter.distance(distanceMeasurement)
    }
    
    static func time(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    static func date(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        let date = Date.init()
        dateFormatter.dateFormat = "dd-MM"
        return dateFormatter.string(from: date)
    }
}
