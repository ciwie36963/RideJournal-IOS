//
//  RideViewController.swift
//  RideJournal
//
//  Created by Alexander Willems on 13/11/2018.
//  Copyright © 2018 Alexander Willems. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RideViewController: UIViewController, CLLocationManagerDelegate {
        
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager = CLLocationManager();
    var distance : Double!
    var previousLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
      stackView.isLayoutMarginsRelativeArrangement = true
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: (userLocation?.coordinate)!, latitudinalMeters: 600, longitudinalMeters: 600)
        self.mapView.setRegion(viewRegion, animated: true)
        self.mapView.showsUserLocation = true
        print(locValue)
    }
    
    @IBAction func startTrackingLocation(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        print("Updating Location started")
    }
    
    @IBAction func stopTrackingLocation(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        print("Updating Location stopped")
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
