//
//  VehicleDetailsTableViewController.swift
//  RideJournal
//
//  Created by Alexander Willems on 14/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import UIKit
import Foundation

//SOURCE: https://stackoverflow.com/questions/24044851/how-do-you-use-string-substringwithrange-or-how-do-ranges-work-in-swift
//deze methode werd gebruikt omdat dit de makkelijkste manier was om VAN een bepaalde plek TOT een bepaalde plek een substring te verkrijgen
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
////////////////////////////////////////////////////////////////END OF SOURCE/////////////////////////////////////////////////////////////
extension UIViewController {
    func hideKeyboard() {
        let push:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(push)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class VehicleDetailsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var workSwitch: UISwitch!
    @IBOutlet weak var carConsumeCell: UITableViewCell!
    @IBOutlet weak var travelAllowanceCell: UITableViewCell!
    @IBOutlet weak var carConsumeTextField: UITextField!
    @IBOutlet weak var travelAllowanceTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    var vehicle : Vehicle!
    var ride : Ride?
    var vehicleType : VehicleType!
    var pricesGaloline = [String]()
    var pickerViewItems = ["Electric","Diesel", "Super95", "Super98"]
    var super95 : Double = 0.0
    var super98 : Double = 0.0
    var diesel : Double = 0.0
    var fuelForSpecificCar : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //op andere thread want ophalen duurt een secondje + alert indien site ECHT traag is
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            if (self.pricesGaloline.isEmpty == true) {
                if (self.pricesGaloline.isEmpty) {
                    let alert = UIAlertController(title: "Problem retrieving gasoline prices", message: "", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Go back to home menu and wait a couple of seconds", style: .destructive) { _ in
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    })
                    self.present(alert, animated: true)
                }
            } else {
                self.fixGasolinePrices()
            }
        })
    }
    
    func fixGasolinePrices() {
        var super95 : String = ""
        var super98 : String = ""
        var diesel : String = ""
        
        for _ in 0..<pricesGaloline.count {
            super95 = pricesGaloline[0]
            super98 = pricesGaloline[1]
            diesel = pricesGaloline[3]
        }
        
        super95 = super95.substring(from: 0, to: 5)
        super98 = super98.substring(from: 0, to: 5)
        diesel = diesel.substring(from: 0, to: 5)
        
        print(super95)
        
        self.super95 = Double(super95.replacingOccurrences(of: ",", with: "."))!
        self.super98 = Double(super98.replacingOccurrences(of: ",", with: "."))!
        self.diesel = Double(diesel.replacingOccurrences(of: ",", with: "."))!
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
    
    @IBAction func editingChangedFuelUsagePerKmYTextField(_ sender: Any) {
        
        let carConsumeTextCheck = NSRange(location: 0, length: carConsumeTextField.text!.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^[0-9]\\d*(\\.\\d+)?$")
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
                } else {
                    saveButton.isEnabled = false
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
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    // MARK: - PICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerViewItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        let valueSelected = pickerViewItems[row] as String
        print(valueSelected)
        
        if valueSelected == "Diesel" {
            fuelForSpecificCar = diesel
        } else if (valueSelected == "Super95") {
            fuelForSpecificCar = super95
        } else if (valueSelected == "Super98"){
            fuelForSpecificCar = super98
        } else {
            fuelForSpecificCar = 0.0 //moet in principe niet door reeds standaardwaarde 0.0 maar maakt duidelijk
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RideViewController
        
        if segue.identifier == "save" {
            
            let fuelUsagePerKm = Double(carConsumeTextField.text!)
            var refundTravelExpensesPerKm = 0.0
            if (travelAllowanceTextField.text != "") {
                refundTravelExpensesPerKm = Double(travelAllowanceTextField.text!)!
            }
            
            if (vehicleType == VehicleType.car) {
                vehicle = Car(refundTravelExpensesPerKm: refundTravelExpensesPerKm, fuelUsagePerKm: fuelUsagePerKm!, fuelPriceCar: fuelForSpecificCar)
                ride = Ride(vehicle: vehicleType, rideToWork: workSwitch.isOn)
                
            } else if (vehicleType == VehicleType.bike) {
                vehicle = Bike(refundTravelExpensesPerKm: refundTravelExpensesPerKm, fuelUsagePerKm: fuelUsagePerKm!, fuelPriceCar : fuelForSpecificCar)
                ride = Ride(vehicle: vehicleType, rideToWork: workSwitch.isOn)
                
            }
            destination.vehicle = vehicle
            destination.ride = ride
        }
    }
}
