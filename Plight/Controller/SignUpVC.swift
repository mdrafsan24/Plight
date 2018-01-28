//
//  SignUpVC.swift
//  Plight
//
//  Created by Rafsan Chowdhury on 1/27/18.
//  Copyright © 2018 appimas24. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var faceView: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    var viruses = ["Syphillis", "Pneumonia", "HIV", "Small Pox", "Influenza"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        faceView.layer.cornerRadius = 75
        faceView.layer.masksToBounds = true
        
        ref = Database.database().reference()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.userName.resignFirstResponder()
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
        self.gender.resignFirstResponder()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.userName.resignFirstResponder()
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
        self.gender.resignFirstResponder()
    }

    @IBAction func signUp(_ sender: Any) {
        if let email = email.text, let password = password.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print("Can't create user")
                } else {
                    
                    let virus = self.viruses[Int(arc4random_uniform(5))]
                    self.viruses.remove(at: self.viruses.index(of: virus)!)
                    let immunity = self.viruses[Int(arc4random_uniform(4))]
                    let userName = self.userName.text
                    let gender = self.gender.text
                    self.ref.child("UserDB").child((user?.uid)!).setValue(["userName": userName, "gender": gender, "virus" : virus, "immunity" : immunity, "longitude" : 0, "latitude" : 0])
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
}
