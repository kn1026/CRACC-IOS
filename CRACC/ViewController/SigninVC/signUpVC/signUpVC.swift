//
//  signUpVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/15/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import Firebase

class signUpVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var profileImgView: ImageRound!
    
    @IBOutlet weak var profilePhoto: RoundBtn!
    @IBOutlet weak var lastNameLbl: UITextField!
    @IBOutlet weak var firstNameLbl: UITextField!
    
    var name: String?
    
    var imageProfile: UIImage?
    
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        firstNameLbl.becomeFirstResponder()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
        firstNameLbl.becomeFirstResponder()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
        
        view.endEditing(true)
        
        
        
    }
    

    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        
        temporaryImage = nil
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        
        if let firstName = firstNameLbl.text, firstName != "", let lastName = lastNameLbl.text, lastName != "" {
            
            name = firstName + " " +  lastName
            
            self.performSegue(withIdentifier: "moveToSignUpVC2", sender: nil)
            
            
            
        } else {
            
            self.showErrorAlert("Oops !!!", msg: "CRACC: Please fill out all the field for sign up.")
            
            
            
        }
        
        
        
    }
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func SetProfileImgBtnPressed(_ sender: Any) {
        
        self.getMediaFrom(kUTTypeImage as String)
        
    }
    
    func getImage(image: UIImage) {
        profileImgView.image = image
        imageProfile = image
        temporaryImage = imageProfile
    }
    
    
    // get media
    
    func getMediaFrom(_ type: String) {
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "moveToSignUpVC2"{
            if let destination = segue.destination as? signUpVC2{
                destination.name = name
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
}


extension signUpVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

    
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            getImage(image: editedImage)
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            getImage(image: originalImage)
        }
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
