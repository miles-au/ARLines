//
//  ViewController+SceneViewExtension.swift
//  ARLinesShowcase
//
//  Created by Miles Au on 2020-07-19.
//  Copyright © 2020 Miles Au. All rights reserved.
//

import Foundation
import ARKit
import ARLines

extension ViewController: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if progress == .placingLineNodes, let centerNode = screenCenterFeaturePoint(){
            if linePositions.count == 0{
                cursor.worldPosition = centerNode
            } else if let firstPosition = linePositions.first{
                lineNode.beginning = firstPosition
                lineNode.destination = centerNode
                lineNode.draw()
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
    
    func setupSceneView(){
        screenCenter = view.center
        
        sceneView.delegate = self
        sceneView.session = session
        sceneView.automaticallyUpdatesLighting = true
        
        // setup cursor
        sceneView.scene.rootNode.addChildNode(cursor)
        cursor.isHidden = true
    }
    
    @IBAction func placeNodeButtonPressed(_ sender: UIButton) {
        if progress == .placingLineNodes, let centerNode = screenCenterFeaturePoint(){
            linePositions.append(centerNode)
            if linePositions.count == 2{
                progress = .pickingLineType
            }else{
                cursor.isHidden = false
            }
        } else {
            cursor.isHidden = true
        }
    }
}
