//
//  DateTimeViewController.swift
//  Reach
//
//  Created by Austin McInnis on 5/9/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit

protocol DateTimeDelegate {
    func datesChosen(start: Date, end: Date)
}

class DateTimeViewController: UIViewController {

    @IBOutlet var startPicker: UIDatePicker!
    @IBOutlet var endPicker: UIDatePicker!
    @IBOutlet var durationLabel: UILabel!
    var delegate: DateTimeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let now = Date()
        startPicker.minimumDate = now
        endPicker.minimumDate = now
    }

    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            [weak self] in
            guard let this = self else { return }
            if let delegate = this.delegate {
                delegate.datesChosen(start: this.startPicker.date, end: this.endPicker.date)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateEndPickerDate(_ sender: UIDatePicker) {
        endPicker.minimumDate = sender.date
    }
    
    @IBAction func updateDuration(_ sender: UIDatePicker) {

        let duration = endPicker.date.timeIntervalSince(startPicker.date)
        let hours = Int(duration / 3600)
        let minutes = Int((duration / 60).truncatingRemainder(dividingBy: 60))
        
        durationLabel.text = "Duration: \(hours)h \(minutes)m"
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
