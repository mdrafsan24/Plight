//
//  UserProfileVC.swift
//  Plight
//
//  Created by Rafsan Chowdhury on 1/27/18.
//  Copyright © 2018 appimas24. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import AVFoundation


class UserProfileVC: UIViewController, CLLocationManagerDelegate {
    
    //---------
    @IBOutlet weak var newsLbl: UILabel!
    @IBOutlet weak var newsIcon: UIImageView!
    @IBOutlet weak var pointsLbl: RoundButton!
    
    @IBOutlet weak var hospitalLbl: UIButton!
    @IBOutlet weak var mobileMap: UIButton!
    //---------

    private var locationManager: CLLocationManager!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var warningLbl: UILabel!
    var player: AVAudioPlayer?
    
    @IBOutlet weak var virus: UILabel!
    @IBOutlet weak var immunity: UILabel!
    var ref: DatabaseReference!
    
    var coordinateUser = CLLocation()
    
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
            self.determineMUsersCurrentLocation()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.notifyIncomingAttack()

    }
    
    func determineMUsersCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 1000;
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Call locationManager.stopUpdatingLocation()
        
        let userLocation: CLLocation = locations[0]
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print("Error getting the users location")
            } else {
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark = placeArray?[0]
                print(placeMark?.location)
                
                var coordinateUser = placeMark?.location
                print("GOT HEREE")
                let userID = Auth.auth().currentUser?.uid
                let latitude = coordinateUser?.coordinate.latitude
                let longitude = coordinateUser?.coordinate.longitude
                
                self.coordinateUser = CLLocation(latitude: latitude!, longitude: longitude!)
                
                self.ref.child("UserDB").child("\(userID!)/latitude").setValue(["latitude" : latitude])
                self.ref.child("UserDB").child("\(userID!)/longitude").setValue(["longitude" : longitude])
                
            }
        }
    }
    
    func notifyIncomingAttack() {
        self.ref.child("UserDB").observe(DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dict = snap.value as? NSDictionary! {
                            if let latitudeDict = dict["latitude"] as? NSDictionary {
                                if let longitudeDict = dict["longitude"] as? NSDictionary {
                                    print(latitudeDict["latitude"]!,longitudeDict["longitude"]!)
                                
                                    let distanceInMeters = self.coordinateUser.distance(from: CLLocation(latitude: latitudeDict["latitude"]! as! CLLocationDegrees, longitude: longitudeDict["longitude"]! as! CLLocationDegrees))
                                
                                    if distanceInMeters < 2.0 {
                                        print(dict["userName"]!, "is nearby")
                                        self.playSound()
                                        self.newsLbl.isHidden = true
                                        self.newsIcon.isHidden = true
                                        self.pointsLbl.isHidden = true
                                        self.hospitalLbl.isHidden = true
                                        self.mobileMap.isHidden = true
                                    
                                        self.warningLbl.text = "\(dict["userName"]!) is nearby, press shield 12 times!"
                                        self.warningLbl.isHidden = false
                                        self.timer.isHidden = false
                                    }
                                }
                            }
                        
                    }
                    
                }
            }
        })
    
        
        
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "siren", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var shieldPressedTracker = 0
    @IBAction func shieldPressed(_ sender: Any) {
        self.shieldPressedTracker = self.shieldPressedTracker + 1
        if self.shieldPressedTracker == 12 {
            self.warningLbl.isHidden = true
            self.timer.isHidden = true
            self.newsLbl.isHidden = false
            self.newsIcon.isHidden = false
            self.pointsLbl.isHidden = false
            self.hospitalLbl.isHidden = false
            self.mobileMap.isHidden = false
        }
    }
    

}
