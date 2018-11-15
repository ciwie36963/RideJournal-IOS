//
//  SelectVehicleTableViewController.swift
//  RideJournal
//
//  Created by Alexander Willems on 14/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import UIKit

class SelectVehicleTableViewController: UITableViewController {
    
    var bike : Bike?
    var car : Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.backgroundColor = #20243e
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "bike" {
            print("bike segue pressed")
            let vehicleDetailsTableViewController = segue.destination as! vehicleDetailsTableViewController
            bike = Bike(refundTravelExpensesPerKm: 0, fuelUsageOfCarNotUsed: 0, isBike: true)
            vehicleDetailsTableViewController.bike = bike;
        } else if segue.identifier == "car" {
            let vehicleDetailsTableViewController = segue.destination as! vehicleDetailsTableViewController
            car = Car(refundTravelExpensesPerKm: 0, fuelUsagePerKm: 0, isCar: true)
            vehicleDetailsTableViewController.car = car;
        }
    }
}
