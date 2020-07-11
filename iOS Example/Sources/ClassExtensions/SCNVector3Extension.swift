//
//  File.swift
//  
//
//  Created by Miles Au on 2020-07-11.
//

import Foundation
import ARKit

extension SCNVector3{
    func midPoint(to target: SCNVector3) -> SCNVector3{
        return SCNVector3(
            (target.x - x) / 2 + x,
            (target.y - y) / 2 + y,
            (target.z - z) / 2 + z)
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
