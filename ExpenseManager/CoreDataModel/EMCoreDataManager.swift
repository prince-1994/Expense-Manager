//
//  EMCoreDataManager.swift
//  ExpenseManager
//
//  Created by Yuvraj Sahu on 01/03/19.
//  Copyright © 2019 Yuvraj Sahu Apps. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EMCoreDataManager {
    
    static var sharedInstance = EMCoreDataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    private init() { }
    
    func saveExpense(name : String, value: Double, date: Date, categoryString: String) {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName : "Expense", in : context)
        let newExpense = NSManagedObject(entity : entity!, insertInto: context)
        newExpense.setValue(name, forKey : "name")
        newExpense.setValue(value, forKey : "value")
        newExpense.setValue(date, forKey : "date")
        newExpense.setValue(categoryString, forKey : "category")
        newExpense.setValue(UUID(), forKey: "id")
        do {
            try context.save()
        }catch {
            print("failed saving")
        }
    }
    
    func getExpenses(for categoryString: String? = nil, startDate : Date? = nil, endDate : Date? = nil) -> [NSManagedObject]{
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        var result = [NSManagedObject]()
        do {
            let data = try context.fetch(request)
            guard let categoryString = categoryString else { return (data as! [NSManagedObject])}
            for expense in data as! [NSManagedObject] {
                if (expense.value(forKey: "category") as! String == categoryString){
                    let tempDate = expense.value(forKey: "date") as! Date
                    var case1 = true, case2 = true
                    if let startDate = startDate {
                        case1 = tempDate.compare(startDate) == .orderedDescending
                    }
                    if let endDate = endDate {
                        case2 = tempDate.compare(endDate) == .orderedAscending
                    }
                    if case1 && case2 {
                        result.append(expense)
                    }
                    
                }
                
            }
        }catch{
                print ("searching failed")
        }
        
        return result
    }
    
    func getExpenses(for categoryString: String? = nil, month : Int? = nil , year : Int? = nil) -> [NSManagedObject] {
        let comp = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: year, month: month != nil ? month! + 1 : nil  , day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let date1 = Calendar.current.date(from: comp)
        var comp1 = DateComponents()
        comp1.month = 1
        comp1.day = -1
        let date2 = Calendar.current.date(byAdding: comp1, to: date1!)
        return getExpenses(for: categoryString, startDate: date1, endDate: date2)
    }
    
    func getExpenseAmount(for categoryString: String? = nil, startDate : Date? = nil, endDate : Date? = nil) -> Double{
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        var result = 0.0
        do {
            let data = try context.fetch(request)
            guard let categoryString = categoryString else { 
                for expense in data as! [NSManagedObject] {
                    let tempDate = expense.value(forKey: "date") as! Date
                    var case1 = true, case2 = true
                    if let startDate = startDate {
                        case1 = tempDate.compare(startDate) == .orderedDescending
                    }
                    if let endDate = endDate {
                        case2 = tempDate.compare(endDate) == .orderedAscending
                    }
                    if case1 && case2 {
                        result += expense.value(forKey: "value") as! Double
                    }
                    
                }
                return result
            }
            for expense in data as! [NSManagedObject] {
                if (expense.value(forKey: "category") as! String == categoryString){
                    let tempDate = expense.value(forKey: "date") as! Date
                    var case1 = true, case2 = true
                    if let startDate = startDate {
                        case1 = tempDate.compare(startDate) == .orderedDescending
                    }
                    if let endDate = endDate {
                        case2 = tempDate.compare(endDate) == .orderedAscending
                    }
                    if case1 && case2 {
                        result += expense.value(forKey: "value") as! Double
                    }
                    
                }
            }
        }catch{
            print ("searching failed")
        }
        
        return result
    }
    
    func getExpenseAmount(for categoryString: String? = nil, month : Int? = nil , year : Int? = nil) -> Double {
        let comp = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: year, month: month != nil ? month! + 1 : nil, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let date1 = Calendar.current.date(from: comp)
        var comp1 = DateComponents()
        comp1.month = 1
        comp1.day = -1
        let date2 = Calendar.current.date(byAdding: comp1, to: date1!)
        return getExpenseAmount(for: categoryString, startDate: date1, endDate: date2)
    }
    
    func deleteExpense(for id : UUID) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        
        do {
            let data = try context.fetch(request)
            for expense in data as! [NSManagedObject] {
                if (expense.value(forKey: "id") as! UUID == id){
                    context.delete(expense)
                    break
                }
            }
            try? context.save()
        }catch{
            print ("searching failed")
        }
    }
    
    func initializeDummyData(){
        saveExpense(name: "car", value: 20.0, date: Date(), categoryString: ExpenseCategory.maintenance.rawValue)
        saveExpense(name: "house", value: 100.0, date: Date.init(timeIntervalSinceNow: -10000), categoryString: ExpenseCategory.transport.rawValue)
    }
    
    func deleteDummyData(){
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        do {
            let data = try context.fetch(request)
            for expense in data as! [NSManagedObject] {
                context.delete(expense)
            }
            try context.save()
        }catch{
            print ("deletion failed")
        }
    }
    
    
}
