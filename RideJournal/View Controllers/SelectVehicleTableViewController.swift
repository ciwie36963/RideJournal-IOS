//
//  SelectVehicleTableViewController.swift
//  RideJournal
//
//  Created by Alexander Willems on 14/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire

class SelectVehicleTableViewController: UITableViewController {
    
    var bike : Bike?
    var car : Car?
    var pricesGaloline = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         guard let status = Network.reachability?.status else { return }
         switch status {
         case .unreachable:
         let alert = UIAlertController(title: "Internet Connection", message: "There is no valid internet connection", preferredStyle: .actionSheet)
         alert.addAction(UIAlertAction(title: "Quit application", style: .destructive) { _ in
         exit(0)
         })
         present(alert, animated: true)
         case .wifi:
         print("wifi ok")
         case .wwan:
         print("wwan ok")
         }
         */
        
        let URL = "https://carbu.com/belgie//index.php/officieleprijs"
        
        Alamofire.request(URL, method: .post, parameters: nil, encoding: URLEncoding.default).validate(contentType: ["application/x-www-form-urlencoded"]).response { (response) in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                do {
                    let html: String = utf8Text
                    let doc: Document = try SwiftSoup.parse(html)
                    for row in try! doc.getElementsByClass("price") {
                        self.pricesGaloline.append(try row.text())
                        print("prijzen opgehaald")
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vehicleDetailsTableViewController = segue.destination as! VehicleDetailsTableViewController
        
        if segue.identifier == "bike" {
            //bike = Bike(isBike: true)
            vehicleDetailsTableViewController.vehicleType = VehicleType.bike
        } else if segue.identifier == "car" {
            //car = Car(isCar: true)
            vehicleDetailsTableViewController.vehicleType = VehicleType.car
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            let defaultPrices = UserDefaults.standard
            if (!self.pricesGaloline.isEmpty) {
                defaultPrices.set(self.pricesGaloline, forKey: "defaultPrices")
            }
            let test = UserDefaults.standard.stringArray(forKey: "defaultPrices") ?? [String]()
            if (self.pricesGaloline.isEmpty) {
                print("prices empty maar default gebruikt")
                vehicleDetailsTableViewController.pricesGaloline = test
            } else {
                print("prices niet empty")
                vehicleDetailsTableViewController.pricesGaloline = self.pricesGaloline
            }
        }
        )
    }
}
