//
//  ViewController.swift
//  iOS Example
//
//  Created by Miles Au on Jul 10, 2020.
//  Copyright © 2020 Miles Au. All rights reserved.
//

import UIKit
import ARKit
import ARLines

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var instructionsStackView: UIStackView!
    
    // line type picker
    @IBOutlet weak var lineTypeStackview: UIStackView!
    @IBOutlet weak var lineTypePickerView: UIPickerView!
    
    let session = ARSession()
    var screenCenter: CGPoint!
    
    var progress: userProgress = .pickingLineType {
        willSet{
            switch newValue {
            case .placingLineNodes:
                lineTypeStackview.isHidden = true
                instructionsStackView.isHidden = false
                cursor.isHidden = false
            case .pickingLineType:
                linePositions = []
                lineTypeStackview.isHidden = false
                instructionsStackView.isHidden = true
                cursor.isHidden = true
            default:
                print("progress set to: \(newValue)")
            }
        }
    }
    
    var lineNode: ARLine3D = ARLine3D(length: 0.0)
    var linePositions = [SCNVector3]()
    
    var cursor = SCNNode(geometry: SCNSphere(radius: 0.005))
    
    enum userProgress{
        case placingLineNodes
        case pickingLineType
        case pickingLineColor
    }
    
    var lineTypeOptions: [(String, ARLine3D)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        setupPickerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if ARWorldTrackingConfiguration.isSupported{
            let sessionConfiguration = ARWorldTrackingConfiguration()
            
            session.run(sessionConfiguration, options: [.removeExistingAnchors, .resetTracking])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        session.pause()
        
        super.viewWillDisappear(true)
    }
}
