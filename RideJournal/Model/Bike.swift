//
//  Bike.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

struct Bike {
    let name : String
    let refundTravelExpensesPerKm : Double
    var imageData: Data?
    
    init(name: String, refundTravelExpensesPerKm: Double, imageData: Data? = nil) {
        self.name = name
        self.refundTravelExpensesPerKm = refundTravelExpensesPerKm
        self.imageData = imageData
    }
}
