//
//  Car.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

struct Car {
    var refundTravelExpensesPerKm : Double
    let fuelUsagePerKm : Double
    let isCar : Bool
    let fuelPriceCar : Double
    
    init(refundTravelExpensesPerKm: Double, fuelUsagePerKm : Double, isCar : Bool, fuelPriceCar : Double) {
        self.refundTravelExpensesPerKm = refundTravelExpensesPerKm
        self.fuelUsagePerKm = fuelUsagePerKm
        self.isCar = isCar
        self.fuelPriceCar = fuelPriceCar
    }
}
