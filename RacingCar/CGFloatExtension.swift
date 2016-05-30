//
//  CGFloatExtension.swift
//  RacingCar
//
//  Created by Tung Nguyen on 4/26/16.
//  Copyright © 2016 Tung Nguyen. All rights reserved.
//

extension Int {
    var f: CGFloat { return CGFloat(self) }
}

extension Float {
    var f: CGFloat { return CGFloat(self) }
}

extension Double {
    var f: CGFloat { return CGFloat(self) }
}

extension CGFloat {
    var swf: Float { return Float(self) }
}