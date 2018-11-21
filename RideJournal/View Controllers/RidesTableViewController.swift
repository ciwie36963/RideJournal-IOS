//
//  RidesTableViewController.swift
//  RideJournal
//
//  Created by Alexander Willems on 16/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import UIKit

class RidesTableViewController: UITableViewController {
    
    @IBOutlet var tb: UITableView!
    var rides = [Ride]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tb.rowHeight = 135
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ((Ride.loadRides()) == nil || Ride.loadRides()?.isEmpty == true) {
            let alert = UIAlertController(title: "No Rides", message: "There are no rides to display", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
        } else {
            rides = Ride.loadRides()!
            tb.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell") as? RideCell else {
            fatalError("Could not dequeue a cell")
        }
        
        let ride = rides[indexPath.row]
        cell.distanceLabel.text = ScreenFormatter.distance(ride.distanceRide)
        cell.vehicleTypeLabel.text = String(Substring(ride.vehicle.rawValue))
        cell.moneySavedLabel.text = String(ride.moneySaved)
        if (ride.rideToWork) {
            cell.rideToWorkLabel.text = "Yes"
        } else {
            cell.rideToWorkLabel.text = "No"
        }
        cell.timeLabel.text = ride.time
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rides.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //alles tot hier standaard buiten disst
            Ride.saveRides(rides)
        }
    }
}
