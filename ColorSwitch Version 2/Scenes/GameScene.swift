//
//  GameScene.swift
//  ColorSwitch Version 2
//
//  Created by Wren Liang on 2019-04-24.
//  Copyright © 2019 Wren Liang. All rights reserved.
//

import SpriteKit

enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var stateOfSwitch = SwitchState.red
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    
    var gameSpeed: CGFloat = -1.0
    var score = 0 {
        didSet {
            gameSpeed -= 0.5
            physicsWorld.gravity = CGVector(dx: 0, dy: gameSpeed)
        }
    }
    
    
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0, dy: gameSpeed)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 60/255, alpha: 1.0)
        
        //Initialize colorSwitch node
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        
        colorSwitch.size = CGSize(width: frame.size.width/(0.9*3), height: frame.size.height/(1.95*3))
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position =  CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
        
    }
    
    
    func spawnBall(){
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY - (ball.size.height + topSafeBound))
        addChild(ball)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
    }
    
    func turnSwitch(){
        //internal logic
        if let newState = SwitchState(rawValue: stateOfSwitch.rawValue + 1){
            stateOfSwitch = newState
        }
        else {
            stateOfSwitch = .red
        }
        
        //actual rotation
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
        
        
    }
    
    func gameOver(){
        UserDefaults.standard.set(score, forKey: "RecentScore")
        
        if score > UserDefaults.standard.integer(forKey: "HighScore") {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnSwitch()
    }
    
}


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        //01
        //10
        //11 if contact
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        //usually use switch statement to check multiple contacts, but only one collision so if is ok
        
        //if this is true, ball has collided with switch
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode: contact.bodyB.node as? SKSpriteNode {
                if currentColorIndex == stateOfSwitch.rawValue{
                    score += 1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25)) {
                        ball.removeFromParent()
                        self.spawnBall()
                    }
                }
                else{
                    gameOver()
                }
            }
            
            
            
        }
        
    }
    
}








