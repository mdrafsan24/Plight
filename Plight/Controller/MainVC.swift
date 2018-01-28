//
//  ViewController.swift
//  Plight
//
//  Created by Rafsan Chowdhury on 1/27/18.
//  Copyright © 2018 appimas24. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signInPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
            if (error != nil) {
                // Give em warning
            } else {
                self.performSegue(withIdentifier: "goToUserProfile", sender: nil)
            }
        }
    }
    
    /*
     Resigns Keyboard after entering login information after clicking DONE
     */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    /*
     Resigns Keyboard after entering login information after clicking one the view
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
    }
    
    
}

