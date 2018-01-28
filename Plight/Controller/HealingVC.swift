//
//  HealingVC.swift
//  Plight
//
//  Created by Rafsan Chowdhury on 1/28/18.
//  Copyright © 2018 appimas24. All rights reserved.
//

import UIKit
import ARKit

class HealingVC: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    func addNewHospital() {
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33) // orientation is reversed so add negative
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPostionOfCamera = orientation + location
        
        let scene = SCNScene(named: "Hospital.scn")
        let hospital = (scene?.rootNode.childNode(withName: "hospital", recursively: false))!
        
        hospital.position = currentPostionOfCamera
        
        let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: hospital, options: [SCNPhysicsShape.Option.keepAsCompound: true])) //
        hospital.physicsBody = body
        
        self.sceneView.scene.rootNode.addChildNode(hospital)
    }
    
    @IBAction func addHospital(_ sender: Any) {
        self.addNewHospital()
    }
    
    
    
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
