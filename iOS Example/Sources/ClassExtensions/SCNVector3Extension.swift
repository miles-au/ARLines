//
//  File.swift
//  
//
//  Created by Miles Au on 2020-07-11.
//

import Foundation
import ARKit

// MARK: - Overloaded Operators
extension SCNVector3{
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
      return SCNVector3(
        left.x + right.x,
        left.y + right.y,
        left.z + right.z
      )
    }
    
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
      return SCNVector3(
        left.x - right.x,
        left.y - right.y,
        left.z - right.z
      )
    }
    
    static func * (left: SCNVector3, right: Float) -> SCNVector3 {
      return SCNVector3(
        left.x * right,
        left.y * right,
        left.z * right
      )
    }
    
    static func / (left: SCNVector3, right: Float) -> SCNVector3 {
      return SCNVector3(
        left.x / right,
        left.y / right,
        left.z / right
      )
    }
}

// MARK: - Custom Functions
extension SCNVector3{
    static var zero: SCNVector3 = {
        return SCNVector3(0,0,0)
    }()
    
    func normalized() -> SCNVector3{
        let magnitude = SCNVector3.zero.distance(to: self)
        return self / magnitude
    }
    
    func vectorTo(point: SCNVector3) -> SCNVector3{
        return point - self
    }
    
    func midPoint(to target: SCNVector3) -> SCNVector3{
        return (target - self) / 2 + self
    }
    
    func distance(to targetVector: SCNVector3) -> Float{
        let x1 = self.x
        let x2 = targetVector.x
        let y1 = self.y
        let y2 = targetVector.y
        let z1 = self.z
        let z2 = targetVector.z
        
        return sqrtf( pow((x2 - x1), 2) + pow((y2 - y1), 2) + pow((z2 - z1), 2) )
    }
}
