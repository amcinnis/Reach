//
//  CreateEventTableViewController.swift
//  Reach
//
//  Created by Austin McInnis on 5/9/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import Firebase
import FirebaseDatabase
import MapKit
import UIKit

class DateCell: UITableViewCell {
    
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var endLabel: UILabel!
}

class CreateEventTableViewController: UITableViewController, UITextFieldDelegate, DateTimeDelegate, ReachLocationDelegate {

    var locationManager: CLLocationManager?
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descriptionView: UITextView!
    private var event = Event(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createEvent(_ sender: Any) {
        let alert = UIAlertController(title: "Create Event?", message: "Are you ready to create this event?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: {
            [weak self] (action) in
            guard let this = self else { return }
            if this.titleField.isFirstResponder {
                this.titleField.resignFirstResponder()
            }
            else if this.descriptionView.isFirstResponder {
                this.descriptionView.resignFirstResponder()
            }
            
            if let title = this.titleField.text {
                this.event.name = title
            }
            
            if let description = this.descriptionView.text {
                this.event.desc = description
            }
            
            guard this.event.name != nil else { return }
            
            
            //Firebase
            let eventsRef = FIRDatabase.database().reference().child("events")
            let eventRef = eventsRef.childByAutoId()
            if let name = this.event.name, let start = this.event.start, let end = this.event.end, let description = this.event.desc, let location = this.event.location {
                eventRef.setValue(["name": name, "start": start.timeIntervalSince1970, "end": end.timeIntervalSince1970, "description": description, "locationName": location.name, "latitude": location.latitude, "longitude": location.longitude, "place": location.place])
            }
            
            this.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Reach Location Delegate
    
    func locationSelected(placemark: MKPlacemark) {
        let locationCell = tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        if let name = placemark.name {
            locationCell.textLabel?.text = "Location: \(name)"
            var place = ""
            if let locality = placemark.locality {
                place += locality
            }
            if let adminArea = placemark.administrativeArea {
                if place.characters.count > 0 {
                    place += ", \(adminArea)"
                }
                else {
                    place += "\(adminArea)"
                }
            }
            event.location = Location(name: name, place: place, latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
            event.coordinate = placemark.coordinate
        }
    }

    // MARK: - Date Time Delegate
    
    func datesChosen(start: Date, end: Date) {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        
        let cell = tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as? DateCell
        if let cell = cell {
            cell.startLabel.text = "Start: \(dateFormat.string(from: start))"
            cell.endLabel.text = "End: \(dateFormat.string(from: end))"
        }
        
        event.start = start
        event.end = end
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 1
        }
        else if section == 2 {
            return 1
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Event"
        case 1:
            return "Date & Time"
        case 2:
            return "Description"
        default:
            return ""
        }
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: = Scroll View Delegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if scrollView != self.descriptionView && self.descriptionView.isFirstResponder {
            self.descriptionView.resignFirstResponder()
        }
        
        if self.titleField.isFirstResponder {
            self.titleField.resignFirstResponder()
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
     
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "chooseDateTime" {
            if let dest = segue.destination as? DateTimeViewController {
                dest.delegate = self
            }
        }
        
        if segue.identifier == "chooseLocation" {
            if let dest = segue.destination as? EnterLocationViewController {
                if let locationManager = locationManager {
                    dest.locationManager = locationManager
                    dest.delegate = self
                }
            }
        }
    }
 

}
