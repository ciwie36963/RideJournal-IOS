//
//  VehicleDetailsTableViewController.swift
//  RideJournal
//
//  Created by Alexander Willems on 14/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import UIKit
import Foundation

class VehicleDetailsTableViewController: UITableViewController {
    //test
    @IBOutlet weak var workSwitch: UISwitch!
    @IBOutlet weak var carConsumeCell: UITableViewCell!
    @IBOutlet weak var travelAllowanceCell: UITableViewCell!
    @IBOutlet weak var carConsumeTextField: UITextField!
    @IBOutlet weak var travelAllowanceTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var car: Car?
    var bike: Bike?
    var ride : Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func valueChangedWorkSwitch(_ sender: Any) {
        if workSwitch.isOn == false {
            travelAllowanceTextField.text = ""
            travelAllowanceTextField.isEnabled = false
        } else {
            travelAllowanceTextField.isEnabled = true
            travelAllowanceTextField.backgroundColor = .white
        }
    }
    //fdfdfdfd
    @IBAction func editingChangedFuelUsagePerKmYTextField(_ sender: Any) {
        
        let carConsumeTextCheck = NSRange(location: 0, length: carConsumeTextField.text!.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^[1-9]\\d*(\\.\\d+)?$")
        let regexCarConsume = regex.firstMatch(in: carConsumeTextField.text!, options: [], range: carConsumeTextCheck)
        
        if (regexCarConsume != nil) {
            if (workSwitch.isOn == true) {
                saveButton.isEnabled = false
                if (carConsumeTextField.text != "" && travelAllowanceTextField.text != "") {
                    saveButton.isEnabled = true
                }
            } else if (workSwitch.isOn == false){
                saveButton.isEnabled = false
                if (carConsumeTextField.text != "") {
                    saveButton.isEnabled = true
                }
            }
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func editingChangedTravelAllowanceTextField(_ sender: Any) {
        
        let travelAllowanceTextCheck = NSRange(location: 0, length: travelAllowanceTextField.text!.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^[0-9]\\d*(\\.\\d+)?$")
        let regexTravelAllowance = regex.firstMatch(in: travelAllowanceTextField.text!, options: [], range: travelAllowanceTextCheck)
        
        if (regexTravelAllowance != nil)  {
            if (workSwitch.isOn == true) {
                saveButton.isEnabled = false
                if (carConsumeTextField.text != "" && travelAllowanceTextField.text != "") {
                    saveButton.isEnabled = true
                }
            } else if (workSwitch.isOn == false){
                saveButton.isEnabled = false
                if (carConsumeTextField.text != "") {
                    saveButton.isEnabled = true
                }
            }
        } else {
            saveButton.isEnabled = false
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "save" {
            print("save pressed + segue done")
            if (car?.isCar == true) {
                let fuelUsagePerKm = Double(carConsumeTextField.text!)
                var refundTravelExpensesPerKm = 0.0
                if (travelAllowanceTextField.text != "") {
                    refundTravelExpensesPerKm = Double(travelAllowanceTextField.text!)!
                }
                car = Car(refundTravelExpensesPerKm: refundTravelExpensesPerKm, fuelUsagePerKm: fuelUsagePerKm!, isCar: true)
                let destination = segue.destination as! RideViewController
                destination.car = car
                if (workSwitch.isOn == true) {
                    ride = Ride(distanceRide: 0, vehicle: VehicleType.car, moneySaved: 0, rideToWork: true, time: "", date: Date.init())
                    destination.ride = ride
                } else {
                    ride = Ride(distanceRide: 0, vehicle: VehicleType.car, moneySaved: 0, rideToWork: false, time: "", date : Date.init())
                    destination.ride = ride
                }
                
            } else if (bike?.isBike == true) {
                let fuelUsageOfCarNotUsed = Double(carConsumeTextField.text!)
                var refundTravelExpensesPerKm = 0.0
                if (travelAllowanceTextField.text != "") {
                    refundTravelExpensesPerKm = Double(travelAllowanceTextField.text!)!
                }
                bike = Bike(refundTravelExpensesPerKm: refundTravelExpensesPerKm, fuelUsageOfCarNotUsed: fuelUsageOfCarNotUsed!, isBike: true)
                let destination = segue.destination as! RideViewController
                destination.bike = bike
                if (workSwitch.isOn == true) {
                    ride = Ride(distanceRide: 0, vehicle: VehicleType.bike, moneySaved: 0, rideToWork: true, time: "", date : Date.init())
                    destination.ride = ride
                } else {
                    ride = Ride(distanceRide: 0, vehicle: VehicleType.bike, moneySaved: 0, rideToWork: false, time: "", date : Date.init())
                    destination.ride = ride
                }
            }
            
        }
    }
}
