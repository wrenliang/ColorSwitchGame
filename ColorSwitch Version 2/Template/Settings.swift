//
//  Settings.swift
//  ColorSwitch Version 2
//
//  Created by Wren Liang on 2019-04-24.
//  Copyright © 2019 Wren Liang. All rights reserved.
//

import SpriteKit

enum PhysicsCategories{
    static let none: UInt32 = 0
    static let ballCategory: UInt32 = 0x1           //01
    static let switchCategory: UInt32 = 0x1 << 1    //10
}


enum ZPositions {
    static let label: CGFloat = 0
    static let ball: CGFloat = 1
    static let colorSwitch: CGFloat = 2
}
