//
//  ARLine.swift
//  ARLinesShowcase
//
//  Created by Miles Au on 2020-07-11.
//  Copyright © 2020 Miles Au. All rights reserved.
//

import Foundation
import ARKit

public class ARLine3D: SCNNode{
    public var beginning: SCNVector3 // first position of the line
    public var destination: SCNVector3 // second position of the line
    public var distance: CGFloat{
        return CGFloat(beginning.distance(to: destination))
    }
    public var color: UIColor = UIColor.white {
        willSet{
            updateColor(of: self, with: newValue)
        }
    }
    public var chamferRadius = CGFloat.zero {
        willSet{
            updateChamfer(of: self, with: newValue)
        }
    }
    public var height = CGFloat(0.005)
    public var width = CGFloat(0.005)
    
    // creates line between two points
    public init(from beginning: SCNVector3, to destination: SCNVector3) {
        self.beginning = beginning
        self.destination = destination
        super.init()
    }
    
    // creates line of specified length along x axis from origin
    convenience public init(length: Float, width: Float = 0.005, height: Float = 0.005) {
        self.init(from: SCNVector3.zero, to: SCNVector3(length, 0, 0))
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func draw(){}
    
    // Recursively update the color of all child nodes
    func updateColor(of node: SCNNode, with color: UIColor){
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
    
    // Recursively update the chamfer of all child nodes
    func updateChamfer(of node: SCNNode, with radius: CGFloat){
        // update the chamfer of this node
        if let boxGeometry = geometry as? SCNBox{
            boxGeometry.chamferRadius = radius
        }
        
        // if has child nodes, call update chamfer on all child nodes
        if !node.childNodes.isEmpty{
            node.childNodes.forEach { child in
                updateChamfer(of: child, with: radius)
            }
        }
    }
    
    public func copyFrom(line: ARLine3D){
        beginning = line.beginning
        destination = line.destination
        height = line.height
        width = line.width
        color = line.color
        chamferRadius = line.chamferRadius
    }
    
    public func createCopy() -> ARLine3D{
        let copy = ARLine3D(from: beginning, to: destination)
        copy.copyFrom(line: self)
        return copy
    }
}

public class ContinuousLine: ARLine3D{
    public override func draw(){
        // set position
        let midpoint = beginning.midPoint(to: destination)
        worldPosition = midpoint
        
        // configure box node
        let distance = beginning.distance(to: destination)
        geometry = SCNBox(width: width, height: height, length: CGFloat(distance), chamferRadius: chamferRadius)
        
        // update geometry ( must be done because of new geometry )
        updateColor(of: self, with: color)
        updateChamfer(of: self, with: chamferRadius)
        
        // rotate to proper position
        look(at: destination, up: SCNVector3(0,1,0), localFront: SCNVector3(0,0,1))
    }
    
    public override func createCopy() -> ARLine3D{
        let copy = ContinuousLine(from: beginning, to: destination)
        copy.copyFrom(line: self)
        return copy
    }
}

// used as a dashline component between continuous lines
public class Gap: ARLine3D{
    public override init(from beginning: SCNVector3, to destination: SCNVector3) {
        super.init(from: beginning, to: destination)
        height = CGFloat.zero
        width = CGFloat.zero
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createCopy() -> ARLine3D{
        let copy = Gap(from: beginning, to: destination)
        copy.copyFrom(line: self)
        return copy
    }
}

public class DashLine: ARLine3D{
    public var composition = [ARLine3D]()
    override public var height: CGFloat{
        get{
            var maxHeight = CGFloat.zero
            for component in composition{
                if component.height > maxHeight{
                    maxHeight = component.height
                }
            }
            return maxHeight
        }
        set{
            enumerateChildNodes { node, pointer in
                if let line = node as? ARLine3D{
                    line.height = newValue
                }
            }
        }
    }
    override public var width: CGFloat{
        get{
            var maxWidth = CGFloat.zero
            for component in composition{
                if component.width > maxWidth{
                    maxWidth = component.width
                }
            }
            return maxWidth
        }
        set{
            enumerateChildNodes { node, pointer in
                if let line = node as? ARLine3D{
                    line.width = newValue
                }
            }
        }
    }
    
    public override func draw(){
        // remove existing nodes
        enumerateChildNodes { node, pointer in
            node.removeFromParentNode()
        }
        
        var componentBeginning = beginning // store position where next component will be drawn from
        var distanceLeft = distance // distance that hasn't been covered
        var componentIndex = 0 // stores which component should be drawn
        
        // draw components while the full distance hasn't been covered
        while distanceLeft > 0 {
            let patternComponent = composition[componentIndex]
            let patternComponentDistance = patternComponent.distance
            
            let componentVector = beginning.vectorTo(point: destination).normalized() * Float(patternComponentDistance)
            var componentDestination = componentBeginning + componentVector
            
            // if this is the last component, cut it short
            if patternComponentDistance > CGFloat(distanceLeft) {
                componentDestination = destination
            }
            
            // create component
            var component: ARLine3D?
            if patternComponent is ContinuousLine{
                component = ContinuousLine(length: Float.zero)
            } else if patternComponent is Gap{
                component = Gap(length: Float.zero)
            }
            
            guard let componentNode = component else { continue }
            componentNode.copyFrom(line: patternComponent)
            componentNode.beginning = componentBeginning
            componentNode.destination = componentDestination
            componentNode.convertTransform(componentNode.transform, from: self)
            
            // add the dash and draw it
            addChildNode(componentNode)
            componentNode.draw()
            
            // setup the next dash
            componentBeginning = componentDestination
            
            // subtract original pattern component distance instead of calculated distance
            distanceLeft -= patternComponentDistance
            
            // next component
            componentIndex += 1
            if componentIndex >= composition.count{
                componentIndex = 0
            }
        }
    }
    
    public override func createCopy() -> ARLine3D{
        let copy = DashLine(from: beginning, to: destination)
        copy.copyFrom(line: self)
        copy.composition = composition
        return copy
    }
}

public class MultiLine: ARLine3D{
    public var composition = [ARLine3D]()
    override public var height: CGFloat{
        get{
            var maxHeight = CGFloat.zero
            for component in composition{
                if component.height > maxHeight{
                    maxHeight = component.height
                }
            }
            return maxHeight
        }
        set{
            enumerateChildNodes { node, pointer in
                if let line = node as? ARLine3D{
                    line.height = newValue
                }
            }
        }
    }
    
    public override func draw(){
        // remove existing nodes
        enumerateChildNodes { node, pointer in
            node.removeFromParentNode()
        }
        
        // get perpendicular vector
        let up = SCNVector3(0,1,0)
        let directionVector = beginning.vectorTo(point: destination)
        let crossVector = up.cross(vector: directionVector).normalized()
        
        // get total width of multi line
        var totalWidth = CGFloat.zero
        for component in composition{
            totalWidth += component.width
        }
        
        // align middle
        let alignmentVector = crossVector * -Float(totalWidth / 2)
        
        // draw lines
        var drawPosition = Float.zero
        for component in composition{
            let componentNode = component.createCopy()
            let displacementVector = (crossVector * drawPosition) + alignmentVector
            
            componentNode.beginning = beginning + displacementVector
            componentNode.destination = destination + displacementVector
            
            addChildNode(componentNode)
            componentNode.draw()
            
            drawPosition += Float(component.width)
        }
    }
    
    public override func createCopy() -> ARLine3D{
        let copy = MultiLine(from: beginning, to: destination)
        copy.copyFrom(line: self)
        copy.composition = composition
        return copy
    }
}

