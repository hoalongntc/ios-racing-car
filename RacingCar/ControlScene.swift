//
//  ControlScene.swift
//  RacingCar
//
//  Created by Tung Nguyen on 4/23/16.
//  Copyright © 2016 Tung Nguyen. All rights reserved.
//

import SpriteKit

protocol ControlSceneDelegate {
    func control(didChange speed: Float, directionX: Float, directionY: Float)
}

class ControlScene : SKScene {
    private var joyStickSpeed: JCJoystick?;
    private var joyStickDirection: JCJoystick?;
    private var connectionLed: Led?;
    private let joyStickSize:CGFloat = 75;
    private let ledSize:CGFloat = 20;
    var controlDelegate: ControlSceneDelegate?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.joyStickSpeed = JCJoystick.init(controlRadiusAndPosition: Float(joyStickSize) * 0.8,
            baseRadius: Float(joyStickSize),
            baseColor: UIColor.redColor(),
            joystickRadius: Float(joyStickSize) * 0.6,
            joystickColor: UIColor(red: 60, green: 61, blue: 64, alpha: 1),
            defaultPosition: "middle")
        
        self.joyStickSpeed!.position = CGPoint(x: joyStickSize + 50, y: joyStickSize + 50);
        self.addChild(self.joyStickSpeed!)
        self.joyStickSpeed!.updateDefaultPosition()
        
        
        self.joyStickDirection = JCJoystick.init(controlRadiusAndPosition: Float(joyStickSize) * 0.8,
            baseRadius: Float(joyStickSize),
            baseColor: UIColor.blueColor(),
            joystickRadius: Float(joyStickSize) * 0.6,
            joystickColor: UIColor(red: 60, green: 61, blue: 64, alpha: 1),
            defaultPosition: "middle")
        
        self.joyStickDirection!.position = CGPoint(x: size.width - (50 + joyStickSize), y: joyStickSize + 50);
        self.addChild(self.joyStickDirection!)
        self.joyStickDirection!.updateDefaultPosition()

        
        self.connectionLed = Led.init(radius: self.ledSize, onColor: SKColor.greenColor(), offColor: SKColor.lightGrayColor())
        self.connectionLed!.position = CGPoint(x: size.height - self.ledSize - 20, y: (size.width - self.ledSize) / 2);
        
        self.addChild(self.connectionLed!)
        
        setLedStatus(true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLedStatus(on: Bool) {
        if on {
            self.connectionLed!.turnOn()
        } else {
            self.connectionLed!.turnOff()
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        if self.controlDelegate != nil {
            self.controlDelegate!.control(didChange: self.joyStickSpeed!.y,
                                          directionX: self.joyStickDirection!.x, directionY: self.joyStickDirection!.y)
        }
    }
}
