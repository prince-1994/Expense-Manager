//
//  EMProfile.swift
//  ExpenseManager
//
//  Created by Yuvraj Sahu on 03/03/19.
//  Copyright © 2019 Yuvraj Sahu Apps. All rights reserved.
//

import Foundation


class EMProfile : Codable{
    var monthlySalary : Double = 0.0
    var interestRate = 0.075/12.0
    var totalTargetSavings : Double = 0.0
    var noOfMonths : Int = 0
    
    
    var json : Data? {
        return try? JSONEncoder().encode(self)
    }
        
    
    func getMonthlyTargetSavingsAmount() -> Double {
        let const = (pow((1 + interestRate),Double(noOfMonths)) - 1)/interestRate
        
        return totalTargetSavings/const
    }
}
