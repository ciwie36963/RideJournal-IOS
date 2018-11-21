//
//  Bike.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

struct Bike {
    var refundTravelExpensesPerKm : Double
    let fuelUsageOfCarNotUsed : Double
    let isBike : Bool
    let fuelPriceCar : Double
    
    init(refundTravelExpensesPerKm: Double, fuelUsageOfCarNotUsed : Double , isBike : Bool, fuelPriceCar : Double) {
        self.refundTravelExpensesPerKm = refundTravelExpensesPerKm
        self.fuelUsageOfCarNotUsed = fuelUsageOfCarNotUsed
        self.isBike = isBike
        self.fuelPriceCar = fuelPriceCar
    }
}
