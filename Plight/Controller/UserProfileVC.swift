//
//  UserProfileVC.swift
//  Plight
//
//  Created by Rafsan Chowdhury on 1/27/18.
//  Copyright © 2018 appimas24. All rights reserved.
//

import UIKit
import Firebase

class UserProfileVC: UIViewController {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var virus: UILabel!
    @IBOutlet weak var immunity: UILabel!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("UserDB").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let gender = value?["gender"] as! String!
            let userName = value?["userName"] as! String!
            let virus = value?["virus"] as! String!
            let immunity = value?["immunity"] as! String!
            
            if (gender == "Male") {
                self.userImage.image = UIImage(named: "Male")
            } else {
                self.userImage.image = UIImage(named: "Female")
            }
            self.virus.text = virus
            self.immunity.text = immunity
            self.userNameLbl.text = userName!
            
        }) { (error) in
            print(error.localizedDescription)
        }

        // Do any additional setup after loading the view.
    }
    
    

}
