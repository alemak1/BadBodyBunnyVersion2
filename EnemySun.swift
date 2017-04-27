//
//  EnemySun.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EnemySun: GKEntity{
    
    
    convenience init(spriteNode: SKSpriteNode, targetAgent: GKAgent2D?) {
        self.init()
        
        let originalPosition = spriteNode.position
        let renderComponent = RenderComponent(position: originalPosition, autoRemoveEnabled: false)
        renderComponent.node = spriteNode
        addComponent(renderComponent)
        
        let orientationComponent = OrientationComponent(currentOrientation: .Right)
        addComponent(orientationComponent)
        
        let animationComponent = AnimationComponent(animations: EnemySun.AnimationsDict)
        addComponent(animationComponent)
        animationComponent.requestedAnimation = .moving
        
        
        if let targetAgent = targetAgent{
            let agentComponent = AgentComponent(targetAgent: targetAgent, maxPredictionTime: 10.00, maxSpeed: 1.00, maxAcceleration: 1.00, lerpingEnabled: true)
            addComponent(agentComponent)
        }
        
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension EnemySun{
    
    
    static let spinAnimationLeft = TextureAnimation(animationState: .moving, orientation: .Left, animationName: "spin", textures: [
        SKTexture(image: #imageLiteral(resourceName: "sun1")), SKTexture(image: #imageLiteral(resourceName: "sun2"))
        ], timePerFrame: 0.10, repeatTexturesForever: true)
    static let spinAnimationRight = TextureAnimation(animationState: .moving, orientation: .Right, animationName: "spin", textures: [
        SKTexture(image: #imageLiteral(resourceName: "sun1")),SKTexture(image: #imageLiteral(resourceName: "sun2"))
        ], timePerFrame: 0.10, repeatTexturesForever: true)
    
    static let AnimationsDict: [AnimationState: [Orientation:Animation]] = [
        .moving: [.Left: EnemySun.spinAnimationLeft,
                  .Right: EnemySun.spinAnimationRight]
    ]
}
