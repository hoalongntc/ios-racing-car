//
//  Joystick.swift
//  RacingCar
//
//  Created by Tung Nguyen on 4/23/16.
//  Copyright © 2016 Tung Nguyen. All rights reserved.
//

import SpriteKit

enum JoystickPosition : String {
    case TOP = "top", BOTTOM = "bottom", LEFT = "left", RIGHT = "right", MIDDLE = "middle"
}

class Joystick : SKShapeNode {
    var controlRadius: Float
    var baseRadius: Float
    var baseColor: SKColor
    var joystickRadius: Float
    var joystickColor: SKColor
    var radiusSR2: Float
    
    private var interior: SKShapeNode
    private var onlyTouch: UITouch?
    private var angle: Float = 0
    var x: Float = 0
    var y: Float = 0
    
    init(controlRadius controlRadious: Float, baseRadius: Float, baseColor: SKColor, joystickRadius: Float, joystickColor: SKColor, defaultPosition: JoystickPosition = .MIDDLE) {
        self.controlRadius = controlRadious
        self.baseRadius = baseRadius
        self.joystickRadius = joystickRadius
        self.baseColor = baseColor
        self.joystickColor = joystickColor
        self.onlyTouch = nil
        self.radiusSR2 = pow(controlRadious, 2)
        self.interior = SKShapeNode()
        super.init()
        
        self.userInteractionEnabled = true
        var circlePath: CGMutablePathRef = CGPathCreateMutable()
        self.path = circlePath
        self.fillColor = self.baseColor
        self.strokeColor = self.baseColor
        self.lineWidth = 1
        
        circlePath = CGPathCreateMutable()
        CGPathAddEllipseInRect(circlePath, nil, CGRectMake(self.position.x - CGFloat(self.joystickRadius), self.position.y - CGFloat(self.joystickRadius), CGFloat(self.joystickRadius) * 2, CGFloat(self.joystickRadius) * 2))
        self.interior.path = circlePath
        self.interior.fillColor = self.joystickColor
        self.interior.strokeColor = self.joystickColor
        self.interior.lineWidth = 1
            
        self.interior.position = self.position
        self.interior.zPosition = 1
        
        self.addChild(self.interior)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if self.onlyTouch == nil {
            self.onlyTouch = touches.first!
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if self.onlyTouch == nil {
            return
        }
        let location: CGPoint = self.onlyTouch!.locationInNode(self.parent!)
        var newx: CGFloat = location.x
        var newy: CGFloat = location.y
        
        if (pow(newx - self.position.x, 2) + pow(newy - self.position.y, 2)) > self.radiusSR2.f {
            self.angle = atan2f(Float(newy - self.position.y), Float(newx - self.position.x))
            newx = self.position.x + self.controlRadius.f * cos(self.angle).f
            newy = self.position.y + self.controlRadius.f * sin(self.angle).f
        }
        self.interior.position = self.convertPoint(CGPointMake(newx, newy), fromNode: self.parent!)
        self.x = ((newx - self.position.x) / self.controlRadius.f).swf
        self.y = ((newy - self.position.y) / self.controlRadius.f).swf
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if touches.contains(self.onlyTouch!) {
            self.onlyTouch = nil
            self.interior.position = CGPointMake(0, 0)
            self.x = 0
            self.y = 0
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        if touches != nil && touches!.contains(self.onlyTouch!) {
            self.onlyTouch = nil
            self.interior.position = CGPointMake(0, 0)
            self.x = 0
            self.y = 0
        }
    }
}