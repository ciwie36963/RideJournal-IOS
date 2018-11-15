//
//  Car.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

struct Car {
    let refundTravelExpensesPerKm : Double
    let fuelUsagePerKm : Double
    let isCar : Bool
    
    init(refundTravelExpensesPerKm: Double, fuelUsagePerKm : Double, isCar : Bool) {
        self.refundTravelExpensesPerKm = refundTravelExpensesPerKm
        self.fuelUsagePerKm = fuelUsagePerKm
        self.isCar = isCar
    }
    
}
