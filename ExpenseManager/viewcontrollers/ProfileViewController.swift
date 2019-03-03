//
//  ProfileViewController.swift
//  ExpenseManager
//
//  Created by Yuvraj Sahu on 03/03/19.
//  Copyright © 2019 Yuvraj Sahu Apps. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate {
    func handleSaveButtonTapped()
}

class ProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var noOfMonthsTextField: UITextField!
    @IBOutlet weak var totalTargetSavingsTextField: UITextField!
    @IBOutlet weak var monthlySalaryTextField: UITextField!
    
    var profile : EMProfile!
    var delegate : ProfileViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeData()
        noOfMonthsTextField.delegate = self
        totalTargetSavingsTextField.delegate = self
        monthlySalaryTextField.delegate = self
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        initializeData()
        updateLabels()
    }
    
    @objc func saveButtonTapped(){
        if let url = try? FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("profile.json"){
            let temp = try? JSONEncoder().encode(profile)
            try? temp?.write(to: url)
        }
        delegate?.handleSaveButtonTapped()
    }
    
    func initializeData(){
        if let url = try? FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true), let jsonData = try? Data(contentsOf : url.appendingPathComponent("profile.json")){
            profile = try? JSONDecoder().decode(EMProfile.self, from: jsonData)
        }else {
            profile = EMProfile()
        }
    }
    
    func updateLabels(){
        monthlySalaryTextField.text = String(profile.monthlySalary)
        totalTargetSavingsTextField.text = String(profile.totalTargetSavings)
        noOfMonthsTextField.text = String(profile.noOfMonths)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let temp = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if temp == "" {
            return true
        }
        switch textField {
        case noOfMonthsTextField:
            guard let num = Int(temp) else {
                if temp == "" {
                    return true
                }
                return false
            }
            profile.noOfMonths = num
        case totalTargetSavingsTextField:
            guard let num = Double(temp) else {
                if temp == "" {
                    return true
                }
                return false
            }
            profile.totalTargetSavings = num
        case monthlySalaryTextField:
            guard let num = Double(temp) else {
                if temp == "" {
                    return true
                }
                return false
            }
            profile.monthlySalary = num
        default:
            break
        }
        return true
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
