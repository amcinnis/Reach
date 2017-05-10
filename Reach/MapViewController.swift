//
//  MapViewController.swift
//  Reach
//
//  Created by Austin McInnis on 5/4/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
        else {
            let initialLocation = CLLocation(latitude: 35.3050, longitude: -120.6625)
            updateMap(location: initialLocation)
        }
    }
    
    private func updateMap(location: CLLocation) {
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Core Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] 
        updateMap(location: userLocation)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }

}
