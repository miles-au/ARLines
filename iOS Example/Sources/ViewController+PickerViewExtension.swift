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
        lineTypeOptions.append(("Continuous" , ContinuousLine(length: Float.zero)))
        
        // Red Line
        let redLine = ContinuousLine(length: Float.zero)
        redLine.color = UIColor.red
        lineTypeOptions.append(("Red Line" , redLine))
        
        // Dash Line
        let dashLine = DashLine(length: Float.zero)
        dashLine.composition = [
            ContinuousLine(length: Float(0.15)),
            Gap(length: 0.01),
            ContinuousLine(length: Float(0.15)),
            Gap(length: 0.015)
        ]
        lineTypeOptions.append(("Dash Line" , dashLine))
        
        // MultiLine
        let multiline = MultiLine(length: 0.0)
        multiline.composition = [
            dashLine,
            Gap(length: Float.zero, width: 0.05),
            ContinuousLine(length: Float.zero)
        ]
        lineTypeOptions.append(("Multi Line" , multiline))
        
        // Mixed Line
        let mixedLine = MultiLine(length: 0.0)
        mixedLine.composition = [
            dashLine,
            Gap(length: Float.zero, width: 0.01),
            redLine,
            Gap(length: Float.zero, width: 0.01),
            ContinuousLine(length: Float.zero)
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
