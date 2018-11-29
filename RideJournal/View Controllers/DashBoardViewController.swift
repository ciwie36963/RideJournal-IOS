//
//  DashBoardViewController.swift
//  RideJournal
//
//  Created by Alexander Willems on 17/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import UIKit
import Charts

class DashBoardViewController: UIViewController {
    
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var rides = [Ride]()
    var distances = [Double]()
    var dates = [String]()
    var counter : Int = 0
    var currentDate : String!
    var sumDistance : Double = 0.0
    var totaltimeTravalled: Int = 0
    var moneySaved : Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if ((Ride.loadRides()) == nil || Ride.loadRides()?.isEmpty == true) {
            let alert = UIAlertController(title: "No Rides", message: "There is not enough information to display", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
        } else {
            rides = Ride.loadRides()!
            distances.removeAll()
            for i in 0..<rides.count{
                distances.append(rides[i].distanceRide)
                dates.append(ScreenFormatter.date(rides[i].date))
            }
            //UI
            setChart(dataPoints: dates, values: distances)
            vehicleLabel.text = calculateVehicleMostUsed().rawValue
            moneyLabel.text = String(round(1000*calculateMoneySavedTotal())/1000)
            distanceLabel.text = ScreenFormatter.distance(calculateTotalDistance())
            timeLabel.text = ScreenFormatter.time(calculateTotalTimeTravelled())
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var lineChartEntries = [ChartDataEntry]()
        var emptyDictionary : [String : Double] = [:]
        emptyDictionary.removeAll()
        var dataEntry = ChartDataEntry()
        var keys = [String]()
        rides.sort(by: {$0.date < $1.date})
        for i in 0..<rides.count {
            let date = ScreenFormatter.date(rides[i].date)
            let currentKey = emptyDictionary[date]
            if var currentKeyUn = currentKey {
                
                currentKeyUn += (rides[i].distanceRide / 1000)
                emptyDictionary[date] = currentKeyUn
            } else {
                print(keys)
                print(rides[i].date)
                emptyDictionary[date] = (rides[i].distanceRide / 1000)
            }
            
        }
        
        var co = 0
        for (key, value) in emptyDictionary {
            co+=1
            print(key)
            keys.append(key)
            dataEntry = ChartDataEntry(x: Double(co), y: value)
            lineChartEntries.append(dataEntry)
            
        }
        keys.reverse()
        let lineChartDataSet = LineChartDataSet(values: lineChartEntries, label: "Distance travelled")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartDataSet.circleColors = [NSUIColor.red]
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:keys)
        lineChartView.xAxis.granularity = 1
        lineChartView.data = lineChartData
        print(lineChartView.data!)
    }
    
    func calculateVehicleMostUsed() -> VehicleType {
        var vehicleMostUsed : VehicleType!
        var bikeCounter : Int = 0
        var carCounter : Int = 0
        for i in 0..<rides.count {
            if (rides[i].vehicle == VehicleType.bike) {
                bikeCounter+=1
            } else if (rides[i].vehicle == VehicleType.car) {
                carCounter+=1
            }
        }
        if (bikeCounter > carCounter) {
            vehicleMostUsed = VehicleType.bike
        } else if (carCounter > bikeCounter) {
            vehicleMostUsed = VehicleType.car
        } else {
            vehicleMostUsed = VehicleType.both
        }
        return vehicleMostUsed
    }
    
    func calculateMoneySavedTotal() -> Double {
        moneySaved = 0.0
        for i in 0..<rides.count {
            moneySaved+=rides[i].moneySaved
        }
        return moneySaved
    }
    
    func calculateTotalDistance() -> Double {
        sumDistance = 0.0
        for i in 0..<rides.count {
            sumDistance += (rides[i].distanceRide)
        }
        return sumDistance
    }
    
    func calculateTotalTimeTravelled() -> Int {
        totaltimeTravalled = 0
        for i in 0..<rides.count {
            totaltimeTravalled+=rides[i].time
        }
        return totaltimeTravalled
    }
}
