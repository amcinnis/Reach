//
//  EnterLocationViewController.swift
//  Reach
//
//  Created by Austin McInnis on 5/11/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import MapKit
import UIKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

protocol ReachLocationDelegate {
    func locationSelected(placemark: MKPlacemark)
}

class EnterLocationViewController: UIViewController, CLLocationManagerDelegate {

    var delegate: ReachLocationDelegate?
    @IBOutlet var doneButton: UIBarButtonItem!
    var locationManager: CLLocationManager?
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    var selectedPinView: MKPinAnnotationView?
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let locationManager = locationManager, CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 10.0
            mapView.showsUserLocation = true
        }
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        if let resultSearchController = resultSearchController {
            resultSearchController.searchResultsUpdater = locationSearchTable
            searchView.addSubview(resultSearchController.searchBar)
            resultSearchController.searchBar.sizeToFit()
        }
        else {
            print("Error")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            [weak self] in
            guard let this = self else { return }
            if let delegate = this.delegate {
                if let pin = this.selectedPin {
                    delegate.locationSelected(placemark: pin)
                }
            }
        })
    }
    
    // MARK: - Map Kit
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.015, 0.015)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: false)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EnterLocationViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.canShowCallout = true
        let button = UIButton(type: .contactAdd)
        pinView?.rightCalloutAccessoryView = button
        selectedPinView = pinView
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let pinView = selectedPinView {
            pinView.pinTintColor = UIColor.green
            doneButton.isEnabled = true
        }
    }
}

extension EnterLocationViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.015, 0.015)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}
