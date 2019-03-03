//
//  AddExpenseViewController.swift
//  ExpenseManager
//
//  Created by Yuvraj Sahu on 02/03/19.
//  Copyright © 2019 Yuvraj Sahu Apps. All rights reserved.
//

import UIKit

protocol AddExpenseViewControllerDelegate{
    func handleDoneButtonTapped(date : Date, name: String, value: Double)
}

class AddExpenseViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var categorySearchTableView: UITableView!
    
    var name : String?
    var value : Double?
    var date : Date?
    var category : String?
    
    var categories : [ExpenseCategory] = {
        var categories = [ExpenseCategory]()
        for category in ExpenseCategory.allCases {
            categories.append(category)
        }
        return categories
    }()
    
    var delegate : AddExpenseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        nameTextField.delegate = self
        valueTextField.delegate = self
        categoryTextField.delegate = self
        categorySearchTableView.dataSource = self
        categorySearchTableView.delegate = self
        categorySearchTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategorySearchTableViewCell")!
        
        cell.textLabel?.text = categories[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category = categories[indexPath.row].rawValue
        categoryTextField.text = category
        categorySearchTableView.isHidden = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case categoryTextField:
            categorySearchTableView.isHidden = false
            return false
        default:
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        switch textField {
        case nameTextField:
            name = text
            if name == nil {
                return false
            }
        case valueTextField:
            value = Double(text)
            if value == nil {
                return false
            }
        default:
            break
        }
        return true
    }
    
    @objc func doneButtonTapped(){
        print(" done tapped")
        date = datePicker.date
        guard date != nil else {return}
        guard name != nil , !(name!.isEmpty) else {return}
        guard value != nil else {return}
        guard category != nil , !(category!.isEmpty) else {return}
        EMCoreDataManager.sharedInstance.saveExpense(name: name!, value: value!, date: date!, categoryString: category!)
        self.delegate?.handleDoneButtonTapped(date: self.date!, name: self.name!, value: self.value!)
        self.navigationController?.popViewController(animated: true)
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
