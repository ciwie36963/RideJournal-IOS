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

class RideViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    //attr and outlets
    @IBOutlet weak var timeTravelled: UILabel!
    @IBOutlet weak var distanceTravelled: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stopTrackingButton: UIButton!
    
    var locationManager = CLLocationManager()
    var locationList: [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var timer: Timer?
    var seconds = 0
    var bike : Bike?
    var car : Car?
    var ride : Ride?
    var rides = [Ride]()
    
    //standardFunctions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    //Own Functions
    func updateCounterAndScreen() {
        seconds += 1
        updateTextOnScreen()
    }
    
    private func updateTextOnScreen() {
        let screenDistance = ScreenFormatter.distance(distance)
        let screenTime = ScreenFormatter.time(seconds)
        
        distanceTravelled.text = "Distance:  \(screenDistance)"
        timeTravelled.text = "Time:  \(screenTime)"
    }
    
    @IBAction func startTrackingLocation(_ sender: UIButton) {
        mapView.removeOverlays(mapView.overlays)
        locationList.removeAll()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateCounterAndScreen()
        }
        
        stopTrackingButton.isEnabled = true
        locationManager.startUpdatingLocation()
        print("Updating Location started")
    }
    
    @IBAction func stopTrackingLocation(_ sender: UIButton) {
        timer?.invalidate()
        
        let alert = UIAlertController(title: "End ride?", message: "Are you sure you want to end the ride?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.saveTheRide()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
        
        locationManager.stopUpdatingLocation()
        print("Updating Location stopped")
    }
    
    func saveTheRide() {
        var moneySaved = 0.0//init
        
        if (car?.refundTravelExpensesPerKm == nil) {
            //als die travelExpenses bij auto niet bestaan is het een fiets
            moneySaved = (ride?.calculateMoneySaved(distance: distance.value, refundTravelExpensesPerKm: (bike?.refundTravelExpensesPerKm)!, fuelUsagePerKm: (bike?.fuelUsageOfCarNotUsed)!, fuelPriceSpecificCar: (bike?.fuelPriceCar)!))!
        } else if (bike?.refundTravelExpensesPerKm == nil) {
            //als die travelExpenses bij fiets niet bestaan is het een auto
            moneySaved = (ride?.calculateMoneySaved(distance: distance.value, refundTravelExpensesPerKm: (car?.refundTravelExpensesPerKm)!, fuelUsagePerKm: (car?.fuelUsagePerKm)!, fuelPriceSpecificCar: (car?.fuelPriceCar)!))!
        }
        
        //je kan enkel zo iets meegeven als je gebruikt maakt van een prepareForUnwind
        ride = Ride(distanceRide: distance.value, vehicle: (ride?.vehicle)!, moneySaved: moneySaved, rideToWork: (ride?.rideToWork)!, time: seconds, date: (ride?.date)!)
        
        if ((Ride.loadRides()) == nil) {
            rides.append(ride!)
        } else {
            rides = Ride.loadRides()!
            rides.append(ride!)
        }
        
        Ride.saveRides(rides)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: (userLocation?.coordinate)!, latitudinalMeters: 600, longitudinalMeters: 600)
        self.mapView.setRegion(viewRegion, animated: true)
        self.mapView.showsUserLocation = true
        
        for newLocation in locations {
            let interval = newLocation.timestamp.timeIntervalSinceNow
            guard interval < 5 && newLocation.horizontalAccuracy < 10 else { continue }
            if let lastLocation = locationList.last {
                let difference2Locations = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: difference2Locations, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
            }
            
            locationList.append(newLocation)
            print(distance)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer(overlay: overlay)}
        let drawImage = MKPolylineRenderer(polyline: polyline)
        drawImage.strokeColor = .black
        drawImage.lineWidth = 5
        return drawImage
    }
}
