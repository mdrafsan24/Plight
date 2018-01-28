//
//  MapVC.swift
//  Plight
//
//  Created by Rafsan Chowdhury on 1/27/18.
//  Copyright © 2018 appimas24. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuth
import MapKit
import QuartzCore


class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    private var locationManager: CLLocationManager!
    private var userCoordinates = CLLocation()
    
    var num = 0
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.layer.cornerRadius = 10.0
        
        self.determineMUsersCurrentLocation()

        // Do any additional setup after loading the view.
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
            
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake((coordinateUser?.coordinate.latitude)!, (coordinateUser?.coordinate.longitude)!), 250, 250), animated: true)

         
            }
        }
        
        self.addAnnos()
    }
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) { return nil }
        
        let reuseID = "chest"
        var v = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if v != nil {
            v?.annotation = annotation
        } else {
            
            v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            v?.image = UIImage(named:"GreenV")
        }
        
        return v
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("This is it", view.annotation!.coordinate.latitude , " and " , view.annotation!.coordinate.longitude)
    }
    
    func addAnnos() {
        let anno = MKPointAnnotation() //42.955447, -78.820137
        anno.title = "Rafsan"
        anno.coordinate = CLLocationCoordinate2D(latitude: 43.08397786219459, longitude: -77.6748257125696)
        
        let anno2 = MKPointAnnotation() //42.955447, -78.820137
        anno2.title = "Alvi"
        anno2.coordinate = CLLocationCoordinate2D(latitude: 43.0842130561529, longitude: -77.67518516022771)
        
        let anno3 = MKPointAnnotation() //42.955447, -78.820137
        anno3.title = "Tony"
        anno3.coordinate = CLLocationCoordinate2D(latitude: 43.08400121413514, longitude: -77.67483509928006)
        
        let anno4 = MKPointAnnotation() //42.955447, -78.820137
        anno4.title = "Mantaqa"
        anno4.coordinate = CLLocationCoordinate2D(latitude: 43.08394543048433, longitude: -77.67479313789192)
        
        let anno5 = MKPointAnnotation() //42.955447, -78.820137
        anno5.title = "Milan"
        anno5.coordinate = CLLocationCoordinate2D(latitude: 43.08400121413514, longitude: -77.67483509928006)
        
        self.mapView.addAnnotation(anno)
        self.mapView.addAnnotation(anno2)
        self.mapView.addAnnotation(anno3)
        self.mapView.addAnnotation(anno4)
        self.mapView.addAnnotation(anno5)
    }
    
    
}
