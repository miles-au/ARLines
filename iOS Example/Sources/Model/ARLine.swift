//
//  ARLine.swift
//  ARLinesShowcase
//
//  Created by Miles Au on 2020-07-11.
//  Copyright © 2020 Miles Au. All rights reserved.
//

import Foundation
import ARKit

class ARLine: SCNNode{
    var beginning: SCNVector3 // first position of the line
    var destination: SCNVector3 // second position of the line
    var color: UIColor = UIColor.white {
        willSet{
            updateColor(of: self, with: newValue)
        }
    }
    
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

class ContinuousLine: ARLine{
    override func draw(){
        let midpoint = beginning.midPoint(to: destination)
        worldPosition = midpoint
        let distance = beginning.distance(to: destination)
        geometry = SCNBox(width: CGFloat(0.005), height: CGFloat(0.005), length: CGFloat(distance), chamferRadius: CGFloat(0.005))
        look(at: destination, up: SCNVector3(0,1,0), localFront: SCNVector3(0,0,1))
    }
}

class DashLine: ARLine{
    
}

class DashDotLine: ARLine{
    
}

class DashDoubleDotLine: ARLine{
    
}

class DashTripleDotLine: ARLine{
    
}

class DotLine: ARLine{
    
}

class LongDashshortDashLine: ARLine{
    
}

class LongDashDoubleShortDashLine: ARLine{
    
}

