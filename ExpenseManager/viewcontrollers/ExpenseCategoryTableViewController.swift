//
//  ExpenseCategoryTableViewController.swift
//  ExpenseManager
//
//  Created by Yuvraj Sahu on 01/03/19.
//  Copyright © 2019 Yuvraj Sahu Apps. All rights reserved.
//

import UIKit

enum ExpenseCategory : String, CaseIterable {
    case food = "Food/Beverages"
    case transport = "Transportation"
    case entertainment = "Entertainment"
    case medical = "Medical & Health"
    case maintenance = "House Expenses & Maintenance"
    case miscellaneous = "Miscellaneous"
}



class ExpenseCategoryTableViewController: BaseTableViewController, AddExpenseViewControllerDelegate, UITextFieldDelegate, ProfileViewControllerDelegate, ExpenseTableViewControllerDelegate {
    
    @IBOutlet weak var targetSavingsLabel: UILabel!
    @IBOutlet weak var updateProfileButton: UIButton!
    @IBOutlet weak var monthlyTotalExpensesLabel: UILabel!
    @IBOutlet weak var monthlySavingsLabel: UILabel!
    @IBOutlet weak var monthlySalaryLabel: UILabel!
    @IBOutlet weak var getExpensesButton: UIButton!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearSearchTableView: UITableView!
    @IBOutlet weak var monthSearchTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var categoryTableView: UITableView!
    var categories : [ExpenseCategory] = {
        var categories = [ExpenseCategory]()
        for category in ExpenseCategory.allCases {
            categories.append(category)
        }
        return categories
    }()
    
    
    let months = ["January", "Febraury", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let years : [Int] = {
        var years = [Int]()
        for i in 2019..<2039{
            years.append(i)
        }
        return years
    }()
    
    
    var selectedYear : Int? = 2019
    var selectedMonth : Int? = 2
    
    var monthlySalary : Double = 0.0
    var savings : Double = 0.0
    var totalExpenses : Double = 0.0
    var targetSavings : Double = 0.0
    
    override func viewDidLoad() {
//        EMCoreDataManager.sharedInstance.deleteDummyData()
        super.viewDidLoad()
        self.title = "Expense Manager"
        configureNameAndValueLabels()
        configureTableViews()
        configureTextFields()
        getExpensesButton.addTarget(self, action: #selector(getExpensesButtonTapped), for: .touchUpInside)
        updateProfileButton.addTarget(self, action: #selector(updateProfileButtonTapped), for: .touchUpInside)
        getExpensesButtonTapped()
    }
    
    func configureNameAndValueLabels(){
        for category in categories {
            names.append(category.rawValue)
            values.append(EMCoreDataManager.sharedInstance.getExpenseAmount(for: category.rawValue, month: selectedMonth, year: selectedYear))
        }
    }
    
    func configureTableViews(){
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.rowHeight = 50
        categoryTableView.reloadData()
        monthSearchTableView.dataSource = self
        monthSearchTableView.delegate = self
        yearSearchTableView.dataSource = self
        yearSearchTableView.delegate = self
        monthSearchTableView.rowHeight = 35
        yearSearchTableView.rowHeight = 35
        monthSearchTableView.isHidden = true
        yearSearchTableView.isHidden = true
    }
    func configureTextFields(){
        monthTextField.delegate = self
        monthTextField.text = months[selectedMonth!]
        yearTextField.delegate = self
        yearTextField.text = String(selectedYear!)
    }
    
    func updateLabels(){
        monthlySalaryLabel.text = "Salary : \(String(format: "%.2f", monthlySalary))"
        monthlySavingsLabel.text = "Savings : \(String(format: "%.2f", savings))"
        monthlyTotalExpensesLabel.text = "Expenses : \(String(format: "%.2f", totalExpenses))"
        targetSavingsLabel.text = "Target Savings : \(String(format: "%.2f", targetSavings))"
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case monthTextField:
            monthSearchTableView.isHidden = false
        case yearTextField:
            yearSearchTableView.isHidden = false
        default:
            return false
        }
        categoryTableView.isUserInteractionEnabled = false
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case monthSearchTableView:
            return months.count
        case yearSearchTableView:
            return years.count
        case categoryTableView:
            return categories.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case monthSearchTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthSearchTableViewCell")!
            cell.textLabel?.text = months[indexPath.row]
            return cell
        case yearSearchTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YearSearchTableViewCell")!
            cell.textLabel?.text = String(years[indexPath.row])
            return cell
        case categoryTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameValueTableViewCell") as! NameValueTableViewCell
            let row = indexPath.row
            cell.setValues(name: names[row], value: values[row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case monthSearchTableView:
            selectedMonth = indexPath.row
            monthTextField.text = months[selectedMonth!]
            monthSearchTableView.isHidden = true
            categoryTableView.isUserInteractionEnabled = true
            return
        case yearSearchTableView:
            selectedYear = years[indexPath.row]
            yearTextField.text = String(selectedYear!)
            yearSearchTableView.isHidden = true
            categoryTableView.isUserInteractionEnabled = true
            return
        default:
            break
        }
        // navigate to controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ExpenseTableViewController") as! ExpenseTableViewController
        vc.category = categories[indexPath.row]
        vc.selectedYear = self.selectedYear
        vc.selectedMonth = self.selectedMonth
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddExpenseViewController") as! AddExpenseViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleDoneButtonTapped(date: Date, name: String, value: Double) {
        updateValues()
        categoryTableView.reloadData()
        getExpensesButtonTapped()
    }
    
    func updateValues(){
        var profile : EMProfile? = EMProfile()
        if let url = try? FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true), let jsonData = try? Data(contentsOf : url.appendingPathComponent("profile.json")){
            profile = try? JSONDecoder().decode(EMProfile.self, from: jsonData)
        }
        if let profile = profile {
            monthlySalary = profile.monthlySalary
            targetSavings = profile.getMonthlyTargetSavingsAmount()
            
        }
        
        for i in 0..<categories.count {
            values[i] = EMCoreDataManager.sharedInstance.getExpenseAmount(for: categories[i].rawValue,month : selectedMonth, year : selectedYear)
        }
        totalExpenses = values.reduce(0.0, {$0 + $1})
        savings = monthlySalary - totalExpenses
    }
    
    @objc func getExpensesButtonTapped(){
        guard selectedMonth != nil else { return }
        guard selectedYear != nil else { return }
        updateValues()
        categoryTableView.reloadData()
        updateLabels()
        
    }
    
    @objc func updateProfileButtonTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
       vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func handleSaveButtonTapped() {
        updateValues()
        updateLabels()
    }
    
    func handleExpenseTableViewControllerDismissed() {
        configureNameAndValueLabels()
        getExpensesButtonTapped()
    }
    
    
    

}
