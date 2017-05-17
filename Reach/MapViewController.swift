//
//  MapViewController.swift
//  Reach
//
//  Created by Austin McInnis on 5/4/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import Firebase
import MapKit
import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var events = [Event]()
    var selectedEvent: Event?
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 10.0
            mapView.showsUserLocation = true
        }
        else {
            let initialLocation = CLLocation(latitude: 35.3050, longitude: -120.6625)
            updateMap(location: initialLocation)
        }
        
        let eventsRef = FIRDatabase.database().reference().child("events")
        eventsRef.observe(.childAdded, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            if let firEvent = snapshot.value as? [String:Any] {
                let locationName = firEvent["locationName"] as! String
                let place = firEvent["place"] as! String
                let lat = firEvent["latitude"] as! Double
                let long = firEvent["longitude"] as! Double
                let location = Location(name: locationName, place: place, latitude: lat, longitude: long)
                let event = Event(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                event.location = location
                event.id = snapshot.key

                event.name = firEvent["name"] as? String
                event.desc = firEvent["description"] as? String
                
                let start = firEvent["start"] as! Double
                let end = firEvent["end"] as! Double
                let startDate = Date(timeIntervalSince1970: start)
                let endDate = Date(timeIntervalSince1970: end)
                event.start = startDate
                event.end = endDate
                
                this.events.append(event)
                this.mapView.addAnnotation(event)
            }
        })
        
        eventsRef.observe(.childRemoved, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            let id = snapshot.key
            let event = this.events.first(where: { $0.id == id })
            let index = this.events.index(where: { $0.id == id })
            if let event = event, let index = index {
                this.mapView.removeAnnotation(event)
                this.events.remove(at: index)
            }
        })
    }
    
    private func updateMap(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.015, 0.015)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Core Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            updateMap(location: userLocation)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createEvent" {
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? CreateEventTableViewController {
                    dest.locationManager = locationManager
                }
            }
        }
        
        if segue.identifier == "showEvent" {
            if let dest = segue.destination as? ViewEventTableViewController {
                if let selectedEvent = selectedEvent {
                    dest.event = selectedEvent
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Event {
            let identifier = "ReachEventPin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selectedEvent = view.annotation as? Event
        self.performSegue(withIdentifier: "showEvent", sender: nil)
    }
}
