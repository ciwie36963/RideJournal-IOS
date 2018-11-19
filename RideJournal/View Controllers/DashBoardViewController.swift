//
//  DashBoardViewController.swift
//  RideJournal
//
//  Created by Alexander Willems on 17/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import UIKit
import Charts
//SOURCE: https://stackoverflow.com/questions/24044851/how-do-you-use-string-substringwithrange-or-how-do-ranges-work-in-swift
extension String {
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.characters.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.characters.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
}
////////////////////////////////////////////////////////////////END OF SOURCE/////////////////////////////////////////////////////////
class DashBoardViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var rides = [Ride]()
    var distances = [Double]()
    var dates = [String]()
    var lineChartEntries = [ChartDataEntry]()
    var counter : Int = 0
    var sumDistance : Double! = 0.0
    var currentDate : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if ((Ride.loadRides()) == nil) {
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
         setChart(dataPoints: dates, values: distances)
         }
    }
    
    //Own functions
    func setChart(dataPoints: [String], values: [Double]) {
        var emptyDictionary = [String: [Double]]()
        var dataEntry = ChartDataEntry(x: Double(counter), y: sumDistance)
        
        /*
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
         */
        /*
        for i in 0..<rides.count {
            var currentKey = emptyDictionary[rides[i].date]
            guard let currentKeyUn = currentKey else {
                var dates = [Double]()
                dates = rides[i].distanceRide
                emptyDictionary[rides[i].date] = dates
            }
        }
        */
        let lineChartDataSet = LineChartDataSet(values: lineChartEntries, label: "Distance travelled")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        lineChartView.xAxis.granularity = 1
        
        lineChartView.data = lineChartData
    }
    
    func calculateVehicleMostUsed() -> VehicleType {
        var vehicleMostUsed : VehicleType?
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
        return vehicleMostUsed!
    }
    
    func calculateMoneySavedTotal() -> Double {
        var moneySaved : Double = 0
        for i in 0..<rides.count {
            moneySaved+=rides[i].moneySaved
        }
        return moneySaved
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
