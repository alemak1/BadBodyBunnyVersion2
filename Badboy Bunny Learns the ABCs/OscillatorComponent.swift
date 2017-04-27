//
//  OscillatorComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class OscillatorComponent: GKComponent{
    
    var oscillationFrameCount: TimeInterval = 0.00
    var oscillationInterval: TimeInterval = 0.00
    
    var leftWardForce: CGFloat = 0.00
    var rightWardForce: CGFloat = 0.00
    var currentlyAppliedForce: CGFloat = 0.00
    
    var physicsBody: SKPhysicsBody?
    
    convenience init(oscillationInterval: TimeInterval, leftWardForce: CGFloat, rightWardForce: CGFloat) {
        self.init()
        self.oscillationInterval = oscillationInterval
        self.leftWardForce = leftWardForce
        self.rightWardForce = rightWardForce
        self.currentlyAppliedForce = leftWardForce
    }
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didAddToEntity() {
        guard let physicsBody = entity?.component(ofType: PhysicsComponent.self)?.physicsBody else {
            fatalError("An oscillator component must belong to an entity with a physics component")
            return }
        
        self.physicsBody = physicsBody
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        print("About to apply oscillation force..")
        
        let appliedForceVector = CGVector(dx: currentlyAppliedForce, dy: 0.00)
        physicsBody?.applyForce(appliedForceVector)
        
        oscillationFrameCount += seconds
        
        if oscillationFrameCount > oscillationInterval{
            
            currentlyAppliedForce = (physicsBody?.velocity.dx)! > CGFloat(0.00) ? leftWardForce : rightWardForce
            
            oscillationFrameCount = 0.00
        }
    }
}
