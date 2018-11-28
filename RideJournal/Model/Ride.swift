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
    case both
}

class Ride : NSObject, NSCoding {
    var distanceRide : Double
    var vehicle : VehicleType
    var moneySaved : Double
    var rideToWork : Bool
    var time: Int
    var date: Date
    
    init(distanceRide: Double, vehicle : VehicleType, moneySaved : Double, rideToWork : Bool, time : Int, date: Date) {
        self.distanceRide = distanceRide
        self.vehicle = vehicle
        self.moneySaved = moneySaved
        self.rideToWork = rideToWork
        self.time = time
        self.date = date
    }
    
    struct PropertyKey {
        static let distanceRide = "distanceRide"
        static let vehicle = "vehicle"
        static let moneySaved = "moneySaved"
        static let rideToWork = "rideToWork"
        static let time = "time"
        static let date = "date"
    }
    
    func calculateMoneySaved(distance: Double, refundTravelExpensesPerKm : Double, fuelUsagePerKm : Double, fuelPriceSpecificCar : Double) -> Double {
        var moneySavedNoCar = 1.0 //init //naamgeving: hij houdt enkel rekening met naft bij gebruik fiets
        
        if (distance == 0) {
            return 0
        } else {
            moneySavedNoCar = ((fuelUsagePerKm/100) / (distance/1000)) * fuelPriceSpecificCar //u distance is in meter, daarom /1000 en fuelUsagePerKm is eigenlijk per 100km, daarom /100
        }
        
        if (rideToWork) {
            //naar werk met auto
            if (vehicle == VehicleType.car) {
                return (distance/1000) * refundTravelExpensesPerKm
            } else if (vehicle == VehicleType.bike){
                //naar werk met fiets
                return (distance/1000) * refundTravelExpensesPerKm + moneySavedNoCar
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
        return moneySavedNoCar
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
        
        let distanceRide = aDecoder.decodeDouble(forKey: PropertyKey.distanceRide) as Double
        let vehicle = VehicleType(rawValue: aDecoder.decodeObject(forKey: "vehicle") as! String)
        let moneySaved = aDecoder.decodeDouble(forKey: PropertyKey.moneySaved) as Double
        let rideToWork = aDecoder.decodeBool(forKey: PropertyKey.rideToWork) as Bool
        let time = aDecoder.decodeInteger(forKey: PropertyKey.time) as Int
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as! Date
        
        self.init(distanceRide : distanceRide, vehicle : vehicle!, moneySaved : moneySaved, rideToWork : rideToWork, time : time, date : date)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(distanceRide, forKey: PropertyKey.distanceRide)
        aCoder.encode(enumToString(vehicle: vehicle), forKey: PropertyKey.vehicle)
        aCoder.encode(moneySaved, forKey: PropertyKey.moneySaved)
        aCoder.encode(rideToWork, forKey: PropertyKey.rideToWork)
        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(date, forKey: PropertyKey.date)
    }
}
