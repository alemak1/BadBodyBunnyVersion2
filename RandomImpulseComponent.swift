//
//  RandomImpulseComponent.swift
//  Badboy Bunny Learns the ABCs
//
//  Created by Aleksander Makedonski on 4/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class RandomImpulseComponent: GKComponent{
    
    
    
    var maximumXImpulse: Int
    var minimumXImpulse: Int
    
    var randomXComponent: Int{
        get{
            return GKRandomDistribution(randomSource: GKMersenneTwisterRandomSource(), lowestValue: minimumXImpulse, highestValue: maximumXImpulse).nextInt()
        }
    }
    
    var maximumYImpulse: Int
    var minimumYImpulse: Int
    
    var randomYComponent: Int{
        get{
            return GKRandomDistribution(randomSource: GKMersenneTwisterRandomSource(), lowestValue: minimumYImpulse, highestValue: maximumYImpulse).nextInt()
        }
    }
    
    var physicsBody: SKPhysicsBody?
    
    var frameCount: TimeInterval = 0.00
    var impulseInterval: TimeInterval = 5.00
    
    
    init(minXImpulse: Int, maxXImpulse: Int, minYImpulse: Int, maxYImpulse: Int, impulseInterval: TimeInterval){
        
        self.maximumXImpulse = maxXImpulse
        self.minimumXImpulse = minXImpulse
        
        self.maximumYImpulse = maxYImpulse
        self.minimumYImpulse = minYImpulse
        
        self.impulseInterval = impulseInterval
        
        super.init()
    }
    
    override func didAddToEntity() {
        physicsBody = entity?.component(ofType: PhysicsComponent.self)?.physicsBody
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let physicsBody = physicsBody else {
            print("Error: a physics body must be attached to the entity in order for the random impulse component to function")
            return
        }
        
        frameCount += seconds
        
        if frameCount > impulseInterval{
            
            let appliedImpulse = CGVector(dx: randomXComponent, dy: randomYComponent)
            physicsBody.applyImpulse(appliedImpulse)
            frameCount = 0
        }
    }
    
}
