# ARLines

[![CI Status](http://img.shields.io/travis/miles-au/ARLines.svg?style=flat)](https://travis-ci.org/miles-au/ARLines)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/miles-au/ARLines)
[![License](https://img.shields.io/github/license/miles-au/ARLines)](LICENSE)

<img src="https://github.com/miles-au/ARLines/blob/master/gifs/demo.gif?raw=true" width="300" title="ARLines Demo">

## Showcase

To run the example project, clone this repo, and open ARLinesShowcase.xcworkspace from the iOS Example directory.


## Installation

 Add this package through Swift Package manager. In Xcode go to select File > Swift Packages > Add Package Dependency. Paste in https://github.com/miles-au/ARLines.git to choose this repository

## Usage

All lines are made up of continuous lines and gaps. Here's the code for the lines that are shown in the example app:

    // Solid Line
    let continuousLine = ContinuousLine()
    
    // Red Line
    let redLine = ContinuousLine()
    redLine.color = UIColor.red
    
    // Wide Line
    let wideLine = ContinuousLine(width: Float(0.05))
    
    // Dash Line
    let dashLine = DashLine()
    dashLine.composition = [
        ContinuousLine(length: Float(0.15)),
        Gap(length: 0.01),
        ContinuousLine(length: Float(0.15)),
        Gap(length: 0.015)
    ]
    
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
    
    // MultiLine
    let multiline = MultiLine()
    multiline.composition = [
        dashLine,
        Gap(width: 0.05),
        ContinuousLine()
    ]
    
    // Mixed Line
    let mixedLine = MultiLine()
    mixedLine.composition = [
        dashLine,
        Gap(width: 0.01),
        redLine,
        Gap(width: 0.01),
        ContinuousLine()
    ]

