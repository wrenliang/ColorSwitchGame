//
//  GameViewController.swift
//  ColorSwitch Version 2
//
//  Created by Wren Liang on 2019-04-24.
//  Copyright © 2019 Wren Liang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

let topSafeBound = CGFloat(44.0)

class GameViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            let scene = MenuScene(size: view.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
}
