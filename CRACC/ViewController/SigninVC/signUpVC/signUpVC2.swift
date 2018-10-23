//
//  signUpVC2.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/22/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class signUpVC2: UIViewController {

    @IBOutlet weak var maleBtn: RoundedBtn!
    @IBOutlet weak var femaleBtn: RoundedBtn!
    
    
    @IBOutlet weak var birthdayTxtField: UITextField!
    
    var gender: String?
    var birthday: String?
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        birthdayTxtField.becomeFirstResponder()
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.maximumDate = Date()
        birthdayTxtField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(signUpVC2.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)

    }
   
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        birthdayTxtField.text = dateFormatter.string(from: sender.date)
        
        
    }
    
    
    
    @IBAction func maleBtnPressed(_ sender: Any) {
        
        
        
        maleBtn.setTitleColor(UIColor.white, for: [.normal])
        maleBtn.backgroundColor = ChosenColor
        
        
        femaleBtn.setTitleColor(ChosenColor, for: [.normal])
        femaleBtn.backgroundColor = UIColor.white
        
        self.gender = "male"
        
        
        
        
        
    }
    
    @IBAction func femaleBtnPressed(_ sender: Any) {
        
        femaleBtn.setTitleColor(UIColor.white, for: [.normal])
        femaleBtn.backgroundColor = ChosenColor
        
        
        maleBtn.setTitleColor(ChosenColor, for: [.normal])
        maleBtn.backgroundColor = UIColor.white
        
        self.gender = "female"
        
    }
    
    
    @IBAction func NextBtnPressed(_ sender: Any) {
        
        
        if let gender = self.gender, gender != "", let birthday = birthdayTxtField.text, birthday != "" {
            
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            var isBirthday = false
            var FinalBirthday = [String]()
            let testBirthdaylArr = Array(birthday)
            
            
            for i in testBirthdaylArr  {
                
                if isBirthday == false {
                    
                    if i == "," {
                        
                        isBirthday = true
                        
                    }
                    
                } else {
                    
                    let num = String(i)
                    
                    
                    FinalBirthday.append(num)
                    
                }
                
            }
            
            let result = FinalBirthday.dropFirst()
            if let bornYear = Int(result.joined()) {
                
                
                
                let currentAge = year - bornYear
                if currentAge > 13 {
                    
                    self.gender = gender
                    self.birthday = birthday
                    self.performSegue(withIdentifier: "moveToSignUpVC3", sender: nil)
                    
                    
                } else {
                    
                    
                    showErrorAlert("Oops !!!", msg: "CRACC: You need to be above 13 years old to sign up for CRACC")
                    
                }
                
            }
        
 
        } else {
        
            self.showErrorAlert("Oops !!!", msg: "CRACC: Please choose your gender and birthday to continue.")
        
        
        }

        
    }
    
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveToSignUpVC3"{
            if let destination = segue.destination as? signUpVC3{
                destination.name = name
                destination.gender = gender
                destination.birthday = birthday
                
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
   
    
}
