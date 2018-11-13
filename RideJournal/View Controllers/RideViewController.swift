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
    
    var locationManager = CLLocationManager()
    var locationList: [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var timer: Timer?
    var seconds = 0
    
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
        
        locationManager.startUpdatingLocation()
        print("Updating Location started")
    }
    
    @IBAction func stopTrackingLocation(_ sender: UIButton) {
        timer?.invalidate()
        
        locationManager.stopUpdatingLocation()
        print("Updating Location stopped")
    }
    
    //StandardFunctionDueToExtending
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: (userLocation?.coordinate)!, latitudinalMeters: 600, longitudinalMeters: 600)
        self.mapView.setRegion(viewRegion, animated: true)
        self.mapView.showsUserLocation = true
        
        for newLocation in locations {
            let interval = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && interval < 10 else { continue }
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
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let drawImage = MKPolylineRenderer(polyline: polyline)
        drawImage.strokeColor = .black
        drawImage.lineWidth = 5
        return drawImage
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
