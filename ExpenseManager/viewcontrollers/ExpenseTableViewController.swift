//
//  ExpenseTableViewController.swift
//  ExpenseManager
//
//  Created by Yuvraj Sahu on 01/03/19.
//  Copyright © 2019 Yuvraj Sahu Apps. All rights reserved.
//

import UIKit
import CoreData
protocol ExpenseTableViewControllerDelegate {
    func handleExpenseTableViewControllerDismissed()
}

class ExpenseTableViewController: BaseTableViewController {
    var category : ExpenseCategory?
    var selectedMonth : Int?
    var selectedYear : Int?
    var data = [NSManagedObject]()
    @IBOutlet weak var expenseTableViewController: UITableView!
    
    var delegate : ExpenseTableViewControllerDelegate?
    override func viewDidLoad(){
        super.viewDidLoad()
        self.title = category?.rawValue
        configureNamesAndValuesLabel()
        configureTableView()
        self.navigationItem.rightBarButtonItem = nil 
    }
    
    func configureTableView(){
        expenseTableViewController.delegate = self
        expenseTableViewController.dataSource = self
        expenseTableViewController.rowHeight = 50
        expenseTableViewController.reloadData()
    }
    
    func configureNamesAndValuesLabel(){
        data = EMCoreDataManager.sharedInstance.getExpenses(for: category?.rawValue, month: selectedMonth, year: selectedYear)
        for expense in data {
            names.append(expense.value(forKey: "name") as! String)
            values.append(expense.value(forKey: "value") as! Double)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        EMCoreDataManager.sharedInstance.deleteExpense(for: data[indexPath.row].value(forKey: "id") as! UUID)
        names.remove(at: indexPath.row)
        values.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}
