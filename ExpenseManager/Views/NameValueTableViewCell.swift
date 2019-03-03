//
//  NameValueCellTableViewCell.swift
//  ExpenseManager
//
//  Created by Yuvraj Sahu on 01/03/19.
//  Copyright © 2019 Yuvraj Sahu Apps. All rights reserved.
//

import UIKit

class NameValueTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(name : String, value : Double){
        // give values to label
        nameLabel.text = name
        valueLabel.text = String(format: "%.2f", value)
    }

}
