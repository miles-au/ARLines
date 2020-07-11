//
//  ARLine.swift
//  ARLinesShowcase
//
//  Created by Miles Au on 2020-07-11.
//  Copyright © 2020 Miles Au. All rights reserved.
//

import Foundation
import ARKit

class ARLine3D: SCNNode{
    var beginning: SCNVector3 // first position of the line
    var destination: SCNVector3 // second position of the line
    var color: UIColor = UIColor.white {
        willSet{
            updateColor(of: self, with: newValue)
        }
    }
    var chamferRadius = CGFloat.zero
    var height = CGFloat(0.005)
    var width = CGFloat(0.005)
    
    init(from beginning: SCNVector3, to destination: SCNVector3) {
        self.beginning = beginning
        self.destination = destination
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(){}
    
    // Recursively update the color of all child nodes
    private func updateColor(of node: SCNNode, with color: UIColor){
        // update the color of this node
        let material = SCNMaterial()
        material.diffuse.contents = color
        geometry?.materials = [material]
        
        // if has child nodes, call update color on all child nodes
        if !node.childNodes.isEmpty{
            node.childNodes.forEach { child in
                updateColor(of: child, with: color)
            }
        }
    }
}

class ContinuousLine: ARLine3D{
    override func draw(){
        // set position
        let midpoint = beginning.midPoint(to: destination)
        worldPosition = midpoint
        
        // configure box node
        let distance = beginning.distance(to: destination)
        geometry = SCNBox(width: width, height: height, length: CGFloat(distance), chamferRadius: chamferRadius)
        
        // rotate to proper position
        look(at: destination, up: SCNVector3(0,1,0), localFront: SCNVector3(0,0,1))
    }
}

class DashLine: ARLine3D{
    var dashLength = CGFloat(0.05)
    var gap = CGFloat(0.01)
    
    override func draw(){
        // remove existing nodes
        enumerateChildNodes { node, pointer in
            node.removeFromParentNode()
        }
        
        let distance = beginning.distance(to: destination)
        let dashVector = beginning.vectorTo(point: destination).normalized() * Float(dashLength)
        let gapVector = beginning.vectorTo(point: destination).normalized() * Float(gap)
        
        var dashBeginning = beginning // store position of the particular dash being drawn
        var distanceLeft = distance // distance that hasn't been covered
        
        // draw dashes while the full distance hasn't been covered
        while distanceLeft > 0 {
            var dashDestination = dashBeginning + dashVector
            
            // if this is the last dash, cut it short
            if dashLength > CGFloat(distanceLeft) {
                dashDestination = destination
            }
            
            // a dashed line is made up of multiple continuous lines
            let dash = ContinuousLine(from: dashBeginning, to: dashDestination)
            dash.convertTransform(dash.transform, from: self)
            
            // add the dash and draw it
            addChildNode(dash)
            dash.draw()

            // setup the next dash
            dashBeginning = dashDestination + gapVector
            distanceLeft -= (dashVector.magnitude() + gapVector.magnitude())
        }
    }
}

class DotLine: DashLine{
    override init(from beginning: SCNVector3, to destination: SCNVector3) {
        super.init(from: beginning, to: destination)
        dashLength = width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LongDashshortDashLine: ARLine3D{
    
}

class LongDashDoubleShortDashLine: ARLine3D{
    
}

class DashDotLine: ARLine3D{
    
}

class DashDoubleDotLine: ARLine3D{
    
}

class DashTripleDotLine: ARLine3D{
    
}


