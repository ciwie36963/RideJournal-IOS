//
//  Bike.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

struct Bike {
    let refundTravelExpensesPerKm : Double
    let fuelUsageOfCarNotUsed : Double
    let isBike : Bool
    
    init(refundTravelExpensesPerKm: Double, fuelUsageOfCarNotUsed : Double , isBike : Bool) {
        self.refundTravelExpensesPerKm = refundTravelExpensesPerKm
        self.fuelUsageOfCarNotUsed = fuelUsageOfCarNotUsed
        self.isBike = isBike
    }
}
