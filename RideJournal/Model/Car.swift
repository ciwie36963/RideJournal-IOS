//
//  Car.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

struct Car {
    let name : String
    let refundTravelExpensesPerKm : Double
    let fuelUsagePerKm : Int
    var imageData: Data?
    
    init(name: String, refundTravelExpensesPerKm: Double, fuelUsagePerKm : Int, imageData: Data? = nil) {
        self.name = name
        self.refundTravelExpensesPerKm = refundTravelExpensesPerKm
        self.fuelUsagePerKm = fuelUsagePerKm
        self.imageData = imageData
    }
    
}
