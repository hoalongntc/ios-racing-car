//
//  CommandType.swift
//  RacingCar
//
//  Created by Tung Nguyen on 3/19/16.
//  Copyright © 2016 Tung Nguyen. All rights reserved.
//

enum CommandType {
    case DIRECTION
    case MOTOR
    
    var key: String {
        switch self {
        case DIRECTION:
            return "servo"
        case MOTOR:
            return "motor"
        }
    }
}