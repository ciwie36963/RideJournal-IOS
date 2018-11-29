//
//  Vehicle.swift
//  RideJournal
//
//  Created by Alexander Willems on 29/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

protocol Vehicle {
    var refundTravelExpensesPerKm : Double {get}
    var fuelUsagePerKm : Double {get}
    var fuelPriceCar : Double {get}
}
