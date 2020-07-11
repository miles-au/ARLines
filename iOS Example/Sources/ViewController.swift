//
//  ViewController.swift
//  iOS Example
//
//  Created by Miles Au on Jul 10, 2020.
//  Copyright © 2020 Miles Au. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var instructionsStackView: UIStackView!
    
    let session = ARSession()
    var screenCenter: CGPoint!
    
    var progress: userProgress = .placingLineNodes
    
    var lineNode = SCNNode()
    var linePositions = [SCNVector3]()
    
    var cursor = SCNNode(geometry: SCNSphere(radius: 0.005))
    
    enum userProgress{
        case placingLineNodes
        case pickingLineType
        case pickingLineColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenCenter = view.center
        
        sceneView.delegate = self
        sceneView.session = session
        
        sceneView.automaticallyUpdatesLighting = true
        
        sceneView.addSubview(ARCoachingOverlayView())
        
        sceneView.scene.rootNode.addChildNode(cursor)
        sceneView.scene.rootNode.addChildNode(lineNode)
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
    
    @IBAction func placeNodeButtonPressed(_ sender: UIButton) {
        if progress == .placingLineNodes, let centerNode = screenCenterFeaturePoint(){
            linePositions.append(centerNode)
            if linePositions.count == 2{
                progress = .pickingLineType
                cursor.isHidden = true
            }else{
                cursor.isHidden = false
            }
        } else {
            cursor.isHidden = true
        }
    }
    
}

extension ViewController: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if progress == .placingLineNodes, let centerNode = screenCenterFeaturePoint(){
            if linePositions.count == 0{
                cursor.worldPosition = centerNode
            } else if let firstPosition = linePositions.first{
                drawLine(from: firstPosition, to: centerNode)
            }
        } else if progress == .pickingLineType{
            
        }
    }
    
    func screenCenterFeaturePoint() -> SCNVector3? {
        // Get feature point from the center of the screen
        if let featurepoint = sceneView.hitTest(screenCenter, types: .featurePoint).first{
            // push feature point position to line nodes array
            let transformColumn3 = featurepoint.worldTransform.columns.3
            let worldPosition = SCNVector3(
                transformColumn3.x,
                transformColumn3.y,
                transformColumn3.z
            )
            return worldPosition
        }
        return nil
    }
    
    func drawLine(from beginning: SCNVector3, to destination: SCNVector3){
        let midpoint = beginning.midPoint(to: destination)
        lineNode.worldPosition = midpoint
        let distance = beginning.distance(to: destination)
        lineNode.geometry = SCNBox(width: CGFloat(0.005), height: CGFloat(0.005), length: CGFloat(distance), chamferRadius: CGFloat.zero)
        lineNode.look(at: destination, up: SCNVector3(0,1,0), localFront: SCNVector3(0,0,1))
    }
}
