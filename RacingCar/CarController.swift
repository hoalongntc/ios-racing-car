//
//  CarController.swift
//  RacingCar
//
//  Created by Tung Nguyen on 3/25/16.
//  Copyright © 2016 Tung Nguyen. All rights reserved.
//

class CarController {
    
    static let SPEED_MAX = 1023
    static let SPEED_MIN = -1023
    static let DIRECTION_MAX = 30
    static let DIRECTION_MIN = -30
    
    internal var carIp = ""
    internal var carPort: UInt16 = 0
    
    internal var speed = 0
    internal var direction = 0
    
    init() {}
    
    init(carIp: String!, carPort: UInt16!) {
        config(carIp, carPort: carPort)
    }
    
    func config(carIp: String!, carPort: UInt16!) {
        self.carIp = carIp
        self.carPort = carPort
        
        SocketClient.sharedInstance.config(self.carIp, port: self.carPort)
    }
    
    func setSpeed(speed: Int) {
        var speed = speed
        if speed > CarController.SPEED_MAX {
            speed = CarController.SPEED_MAX
        }
        if speed < CarController.SPEED_MIN {
            speed = CarController.SPEED_MIN
        }
        
        if(abs(speed - self.speed) >= 1) {
            self.speed = speed
            print("speed", self.speed)
            sendCommand(CommandType.MOTOR)
        }
    }
    
    func setDirection(direction: Int) {
        var direction = direction
        if direction > CarController.DIRECTION_MAX {
            direction = CarController.DIRECTION_MAX
        }
        if direction < CarController.DIRECTION_MIN {
            direction = CarController.DIRECTION_MIN
        }
        
        if(abs(direction - self.direction) >= 1) {
            self.direction = direction
            print("direction", self.direction)
            sendCommand(CommandType.DIRECTION)
        }
    }
    
    internal func sendCommand(commandType: CommandType) {
        switch commandType {
        case .MOTOR:
            SocketClient.sharedInstance.sendCommand(commandType.key + " " + String(self.speed))
        case .DIRECTION:
            SocketClient.sharedInstance.sendCommand(commandType.key + " " + String(self.direction))
        }
    }
 }