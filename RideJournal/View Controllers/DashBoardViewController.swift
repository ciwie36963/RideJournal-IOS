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
    
    
    var rides = [Ride]()
    var distances = [Double]()
    var dates = [String]()
    var dates2 = [Date]()
    var lineChartEntries = [ChartDataEntry]()
    var counter : Int = 0
    var sumDistance : Double! = 0.0
    var currentDate : String!
    
    
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
                dates2.append(rides[i].date)
            }
            setChart(dataPoints: dates, values: distances)
            vehicleLabel.text = calculateVehicleMostUsed().rawValue
            moneyLabel.text = String(calculateMoneySavedTotal())
            //distanceLabel.text =
            //timeLabel.text =
        }
    }
    
    //Own functions
    func setChart(dataPoints: [String], values: [Double]) {
        var emptyDictionary = [Date : Double]()
        var dataEntry = ChartDataEntry(x: Double(counter), y: sumDistance)
        
        
        for i in 0..<distances.count {
            print(sumDistance)
            sumDistance+=values[i]
            currentDate = dataPoints.last!
            
            if (dataPoints[counter] == currentDate) {
                if lineChartEntries.isEmpty{
                    lineChartEntries.append(dataEntry)
                } else {
                    print(lineChartEntries)
                    //hij verwijdert de vorige volledige sumDistance en maakt een punt met de nieuwe
                    lineChartEntries.removeLast()
                    lineChartEntries.append(dataEntry)
                }
            } else {
                counter+=1
                dataEntry = ChartDataEntry(x: Double(counter), y: sumDistance)
                lineChartEntries.append(dataEntry)
            }
        }
        
        
        for i in 0..<rides.count {
            var currentKey = emptyDictionary[rides[i].date]
            guard var currentKeyUn = currentKey else {
                //var dates = [Double]()
                //dates.append(rides[i].distanceRide)
                emptyDictionary[rides[i].date] = rides[i].distanceRide
                return
            }
            currentKeyUn += rides[i].distanceRide
            emptyDictionary[rides[i].date] = currentKeyUn
        }
        
        
        
        
        
        let lineChartDataSet = LineChartDataSet(values: lineChartEntries, label: "Distance travelled")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartDataSet.circleColors = [NSUIColor.red]
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        lineChartView.xAxis.granularity = 1
        
        lineChartView.data = lineChartData
        print(lineChartView.data)
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
        }
        return vehicleMostUsed
    }
    
    func calculateMoneySavedTotal() -> Double {
        var moneySaved : Double = 0
        for i in 0..<rides.count {
            moneySaved+=rides[i].moneySaved
        }
        return moneySaved
    }
}
