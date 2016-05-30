//
//  LED.swift
//  RacingCar
//
//  Created by Tung Nguyen on 4/23/16.
//  Copyright © 2016 Tung Nguyen. All rights reserved.
//

import SpriteKit

class Led : SKShapeNode {
    var radius: CGFloat
    var onColor: SKColor
    var offColor: SKColor
    var led: SKShapeNode
    var state = false
    
    init(radius: CGFloat, onColor: SKColor, offColor: SKColor) {
        self.radius = radius
        self.onColor = onColor
        self.offColor = offColor
        self.led = SKShapeNode()
        super.init()
        
        var circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath, nil,
            CGRectMake(self.position.x - self.radius, self.position.y - self.radius, self.radius * 2, self.radius * 2))
        
        self.path = circlePath
        self.fillColor = SKColor.lightGrayColor()
        self.strokeColor = SKColor.lightGrayColor()
        self.lineWidth = 1
        
        let ledRadius = CGFloat(Float(radius) * 0.8)
        
        circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath, nil,
            CGRectMake(self.position.x - ledRadius, self.position.y - ledRadius, ledRadius * 2, ledRadius * 2))
        
        self.led.path = circlePath
        self.led.fillColor = self.offColor
        self.led.strokeColor = self.offColor
        self.led.lineWidth = 1
        
        self.led.position = self.position
        self.led.zPosition = 1;
        self.addChild(self.led)
    }

    func turnOn() {
        self.state = true
        updateShape()
    }
    
    func turnOff() {
        self.state = false
        updateShape()
    }
    
    private func updateShape() {
        if self.state == true {
            self.led.fillColor = self.onColor
            self.led.strokeColor = self.onColor
        } else {
            self.led.fillColor = self.offColor
            self.led.strokeColor = self.offColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
