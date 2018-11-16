//
//  Ride.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import Foundation

enum VehicleType: String {
    case bike
    case car
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

class Ride : NSObject, NSCoding {
    var distanceRide : String
    var vehicle : VehicleType
    var moneySaved : Double
    var rideToWork : Bool
    var time: String
    
    init(distanceRide: String, vehicle : VehicleType, moneySaved : Double, rideToWork : Bool, time : String) {
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
    
    func calculateMoneySaved(distance: String, refundTravelExpensesPerKm : Double, fuelUsagePerKm : Double) -> Double {
        let cutDistanceRide = distance.index(of: " ")!
        let createStringDistance = String(distance[...cutDistanceRide])
        let correctDistance = createStringDistance.toDouble() //ging enkel met deze meth, Double(..) wou hij niet pakken
        var moneySavedNoCar = 1.0 //init
        
        if (correctDistance == 0) {
            return 0
        } else {
            moneySavedNoCar = (fuelUsagePerKm / correctDistance!) * 1.15 //met hardcoded benzinePrijs
        }
        
        if (rideToWork) {
            //naar werk met auto
            if (vehicle == VehicleType.car) {
                return correctDistance! * refundTravelExpensesPerKm
            } else if (vehicle == VehicleType.bike){
                //naar werk met fiets
                return correctDistance! * refundTravelExpensesPerKm + moneySavedNoCar
            }
            //niet naar werk, met auto
        }  else {
            if (vehicle == VehicleType.car) {
                return 0
            } else if (vehicle == VehicleType.bike){
                //naar werk met fiets
                return moneySavedNoCar
            }
            
        }
        //doet niets
        return 1000
    }
    
    func enumToString(vehicle : VehicleType) -> String {
        return String(Substring(vehicle.rawValue))
    }
    func StringToEnum(vehicle : String) -> VehicleType {
        return VehicleType(rawValue: vehicle)!
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
        
        let distanceRide = aDecoder.decodeObject(forKey: PropertyKey.distanceRide) as? String
        let vehicle = VehicleType(rawValue: aDecoder.decodeObject(forKey: "vehicle") as! String)
        let moneySaved = aDecoder.decodeDouble(forKey: PropertyKey.moneySaved) as Double
        let rideToWork = aDecoder.decodeBool(forKey: PropertyKey.rideToWork) as Bool
        let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? String
        
        self.init(distanceRide : distanceRide!, vehicle : vehicle!, moneySaved : moneySaved, rideToWork : rideToWork, time : time!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(distanceRide, forKey: PropertyKey.distanceRide)
        aCoder.encode(enumToString(vehicle: vehicle), forKey: PropertyKey.vehicle)
        aCoder.encode(moneySaved, forKey: PropertyKey.moneySaved)
        aCoder.encode(rideToWork, forKey: PropertyKey.rideToWork)
        aCoder.encode(time, forKey: PropertyKey.time)
    }
    
    
}
