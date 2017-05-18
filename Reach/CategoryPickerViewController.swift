//
//  CategoryPickerViewController.swift
//  Reach
//
//  Created by Austin McInnis on 5/17/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import Firebase
import UIKit

protocol ReachCategoryDelegate {
    func categorySelected(category: String)
}

class CategoryPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var categoryPicker: UIPickerView!
    private let categoriesRef = FIRDatabase.database().reference().child("eventCategories")
    private var categories = [String]()
    var delegate:ReachCategoryDelegate?
    @IBOutlet var newCategoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Firebase
        categoriesRef.observe(.childAdded, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
        
            if let category = snapshot.value as? String {
                this.categories.append(category)
                this.categoryPicker.reloadAllComponents()
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNewCategory(_ sender: Any) {
        if !(newCategoryTextField.text?.isEmpty)! {
            if let category = newCategoryTextField.text {
                let categoryRef = categoriesRef.childByAutoId()
                categoryRef.setValue(category)
            }
            newCategoryTextField.text = ""
        }
        newCategoryTextField.resignFirstResponder()
    }

    @IBAction func done(_ sender: Any) {
        if let delegate = delegate {
            let row = categoryPicker.selectedRow(inComponent: 0)
            delegate.categorySelected(category: categories[row])
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Picker View Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
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
