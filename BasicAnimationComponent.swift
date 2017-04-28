//
//  BasicAnimationComponent.swift
//  Badboy Bunny Learns the ABCs
//
//  Created by Aleksander Makedonski on 4/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class BasicAnimationComponent: GKComponent{
    
    var basicAnimation: SKAction?
    var basicAnimationKey: String?
    var animationNode: SKSpriteNode?
    
    init(basicAnimation: SKAction, basicAnimationKey: String){
        self.basicAnimation = basicAnimation
        self.basicAnimationKey = basicAnimationKey
        self.animationNode = SKSpriteNode()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        animationNode = entity?.component(ofType: RenderComponent.self)?.node
        
        if let animationNode = animationNode, let basicAnimation = basicAnimation, let basicAnimationKey = basicAnimationKey{
            let repeatedAction = SKAction.repeatForever(basicAnimation)
            animationNode.run(repeatedAction, withKey: basicAnimationKey)
        }
      
    }
    
    override func willRemoveFromEntity() {
        if let animationNode = animationNode, let basicAnimationKey = basicAnimationKey, (animationNode.action(forKey: basicAnimationKey) != nil){
            animationNode.removeAction(forKey: basicAnimationKey)
        }
        
        animationNode = nil
        basicAnimation = nil
        basicAnimationKey = nil
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
}
