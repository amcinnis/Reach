//
//  FeedViewController.swift
//  Reach
//
//  Created by Austin McInnis on 5/9/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pull(_ sender: Any) {
        if let url = URL(string: "http://localhost:3000/json") {
            let session = URLSession.shared
            let download = session.dataTask(with: url) {
                (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                if let data = data {
                    let json = JSON(data: data)
                    print(json)
                }
            }
            
            download.resume()
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
