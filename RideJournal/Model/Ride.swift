//
//  Ride.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

enum VehicleType {
    case bike
    case car
}

struct Ride {
    let name : String
    let distance : Double
    let vehicle : VehicleType
    let moneySaved : Double
    let rideToWork : Bool
    
    init(name: String, distance: Double, vehicle : VehicleType, moneySaved : Double, rideToWork : Bool) {
        self.name = name
        self.distance = distance
        self.vehicle = vehicle
        self.moneySaved = moneySaved
        self.rideToWork = rideToWork
    }
}
