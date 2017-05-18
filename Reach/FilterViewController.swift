//
//  FilterViewController.swift
//  
//
//  Created by Austin McInnis on 5/17/17.
//
//

import Firebase
import UIKit

protocol ReachCategoryFilterDelegate {
    func selectedCategoryFilters(filters: [String])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var categories = [String]()
    var delegate: ReachCategoryFilterDelegate?
    var filters: [String]?
    private var isSelected = [Bool]()
    private var selectedRow: IndexPath?
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Firebase
        let categoriesRef = FIRDatabase.database().reference().child("eventCategories")
        categoriesRef.observe(.childAdded, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            let category = snapshot.value as! String
            this.categories.append(category)
            if let filters = this.filters {
                if filters.contains(category) {
                    this.isSelected.append(true)
                }
                else {
                    this.isSelected.append(false)
                }
            }
            else {
                this.isSelected.append(false)
            }
            this.tableView.insertRows(at: [IndexPath(row: this.categories.count-1, section: 0)], with: .automatic)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        if let delegate = delegate {
            var filters = [String]()
            for (index, cat) in isSelected.enumerated() {
                if cat == true {
                    filters.append(categories[index])
                }
            }
            delegate.selectedCategoryFilters(filters: filters)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        if isSelected[indexPath.row] == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        isSelected[indexPath.row] = (isSelected[indexPath.row] == true) ? false : true
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = (isSelected[indexPath.row] == true) ? .checkmark : .none
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
