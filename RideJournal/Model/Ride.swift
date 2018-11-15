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

class Ride : NSObject, NSCoding {
    let distanceRide : Double
    let vehicle : VehicleType
    let moneySaved : Double
    let rideToWork : Bool
    let time: String
    
    init(distanceRide: Double, vehicle : VehicleType, moneySaved : Double, rideToWork : Bool, time : String) {
        self.distanceRide = distanceRide
        self.vehicle = vehicle
        self.moneySaved = moneySaved
        self.rideToWork = rideToWork
        self.time = time
    }
    
    struct PropertyKey {
        static let distanceRide = "distanceRide"
        static let vehicle = "vehicle"
        static let moneySaved = "moneySaved"
        static let rideToWork = "rideToWork"
        static let time = "time"
    }
    
    func calculateMoneySaved() -> Double {
        return 1
    }
    
    //nodig voor te saven
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("rides")
    
    //loading van de saved rides
    static func loadRides() -> [Ride]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Ride.ArchiveURL.path) as? [Ride]
    }
    
    //main save method om local op te slaan
    static func saveRides(_ rides: [Ride]) {
        NSKeyedArchiver.archiveRootObject(rides, toFile: Ride.ArchiveURL.path)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let distanceRide = aDecoder.decodeObject(forKey: PropertyKey.distanceRide) as? Double
        let vehicle = aDecoder.decodeObject(forKey: PropertyKey.vehicle) as? VehicleType
        let moneySaved = aDecoder.decodeObject(forKey: PropertyKey.moneySaved) as? Double
        let rideToWork = aDecoder.decodeObject(forKey: PropertyKey.rideToWork) as? Bool
        let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? String
        
        self.init(distanceRide : distanceRide!, vehicle : vehicle!, moneySaved : moneySaved!, rideToWork : rideToWork!, time : time!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(distanceRide, forKey: PropertyKey.distanceRide)
        aCoder.encode(vehicle, forKey: PropertyKey.vehicle)
        aCoder.encode(moneySaved, forKey: PropertyKey.moneySaved)
        aCoder.encode(rideToWork, forKey: PropertyKey.rideToWork)
        aCoder.encode(time, forKey: PropertyKey.time)
    }
    
    
}
