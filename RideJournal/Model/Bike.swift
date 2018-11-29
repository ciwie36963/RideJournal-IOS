//
//  Bike.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

struct Bike : Vehicle {
    var refundTravelExpensesPerKm : Double
    let fuelUsagePerKm : Double
    let fuelPriceCar : Double
    
    init(refundTravelExpensesPerKm: Double = 0, fuelUsagePerKm : Double = 0, fuelPriceCar : Double = 0) {
        self.refundTravelExpensesPerKm = refundTravelExpensesPerKm
        self.fuelUsagePerKm = fuelUsagePerKm
        self.fuelPriceCar = fuelPriceCar
    }
}
