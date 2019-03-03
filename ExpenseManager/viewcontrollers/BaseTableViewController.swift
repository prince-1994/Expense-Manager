//
//  ViewController.swift
//  ExpenseManager
//
//  Created by Yuvraj Sahu on 01/03/19.
//  Copyright © 2019 Yuvraj Sahu Apps. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var names : [String]! = []
    var values : [Double]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard names.count == values.count else {return 0}
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameValueTableViewCell") as! NameValueTableViewCell
        let row = indexPath.row
        cell.setValues(name: names[row], value: values[row])
        return cell
    }
    
    
}

