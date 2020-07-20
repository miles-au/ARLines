//
//  ViewController+PickerViewExtension.swift
//  ARLinesShowcase
//
//  Created by Miles Au on 2020-07-19.
//  Copyright © 2020 Miles Au. All rights reserved.
//

import Foundation
import ARLines
import UIKit

extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lineTypeOptions.count
    }
}

extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let (line, _) = lineTypeOptions[row]
        return line
    }
}

extension ViewController{
    func setupPickerView(){
        lineTypePickerView.delegate = self
        lineTypePickerView.dataSource = self
        
        // Solid Line
        lineTypeOptions.append(("Continuous" , ContinuousLine()))
        
        // Red Line
        let redLine = ContinuousLine()
        redLine.color = UIColor.red
        lineTypeOptions.append(("Red Line" , redLine))
        
        // Wide Line
        let wideLine = ContinuousLine(width: Float(0.05))
        lineTypeOptions.append(("Wide Line" , wideLine))
        
        // Dash Line
        let dashLine = DashLine()
        dashLine.composition = [
            ContinuousLine(length: Float(0.15)),
            Gap(length: 0.01),
            ContinuousLine(length: Float(0.15)),
            Gap(length: 0.015)
        ]
        lineTypeOptions.append(("Dash Line" , dashLine))
        
        // Rounded Dash Line
        let roundedDashLine = DashLine()
        let roundedDash = ContinuousLine(length: Float(0.05))
        roundedDash.chamferRadius = CGFloat(0.0025)
        roundedDashLine.composition = [
            roundedDash,
            Gap(length: 0.01),
            roundedDash,
            Gap(length: 0.01)
        ]
        lineTypeOptions.append(("Rounded Dash Line" , roundedDashLine))
        
        // MultiLine
        let multiline = MultiLine()
        multiline.composition = [
            dashLine,
            Gap(width: 0.05),
            ContinuousLine()
        ]
        lineTypeOptions.append(("Multi Line" , multiline))
        
        // Mixed Line
        let mixedLine = MultiLine()
        mixedLine.composition = [
            dashLine,
            Gap(width: 0.01),
            redLine,
            Gap(width: 0.01),
            ContinuousLine()
        ]
        lineTypeOptions.append(("Mixed Line" , mixedLine))
        
        lineTypePickerView.reloadAllComponents()
    }
    
    @IBAction func selectLineTypePressed(_ sender: UIButton) {
        progress = .placingLineNodes
        
        // update line type
        let lineIndex = lineTypePickerView.selectedRow(inComponent: 0)
        let (_, line) = lineTypeOptions[lineIndex]
        lineNode = line.createCopy()
        sceneView.scene.rootNode.addChildNode(lineNode)
    }
}
