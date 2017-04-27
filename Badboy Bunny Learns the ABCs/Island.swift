//
//  Island.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Island: GKEntity{
    
    
    enum IslandType: String{
        case ground_cake, ground_cake_small, ground_cake_broken, ground_cake_small_broken
        case ground_grass, ground_grass_small, ground_grass_broken, ground_grass_small_broken
        case ground_sand, ground_sand_small, ground_sand_broken, ground_sand_small_broken
        case ground_wood, ground_wood_small, ground_wood_broken, ground_wood_small_broken
        
        
        var texture: SKTexture?{
            guard let textureImage = UIImage(named: self.rawValue) else { return nil }
            return SKTexture(image: textureImage)
        }
    }
    
    override init() {
        super.init()
    }
    
    convenience init(islandType: IslandType, position: CGPoint) {
        self.init()
        
     
        /** Add RenderComponent
 
        **/
        guard let texture = islandType.texture else {
            print("Initialization of island failed: texture unavailable")
            return }
        let renderComponent = RenderComponent(position: position, autoRemoveEnabled: false)
        renderComponent.node = SKSpriteNode(texture: texture, color: .clear, size: texture.size())
        renderComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addComponent(renderComponent)
        
        /** Add Physic Component
 
         **/
        let physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.isDynamic = false
        
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, collisionConfiguration: CollisionConfiguration.Barrier)
        addComponent(physicsComponent)
        
        
        let orientationComponent = OrientationComponent(currentOrientation: .Left)
        addComponent(orientationComponent)
        
        
        let currentPosition = renderComponent.node.position
        let movePosition = CGPoint(x: RandomGenerator.getRandomXPos(adjustmentFactor: 0.95), y: Int(currentPosition.y))
        
        let action1 =  SKAction.move(to: currentPosition, duration: 3.00)
        let action2 = SKAction.move(to: movePosition, duration: 3.00)
        let action3 = SKAction.move(to: currentPosition, duration: 3.00)
    

        let oscillatingAction = SKAction.sequence([
                    action1,
                    action2,
                    action3,
                    action2
        
            ])
        
        
        let oscillatingAnimation1 = NonTextureAnimation(animationState: .moving, orientation: .Left, animationName: "oscillatingAction", nonTextureAction: oscillatingAction, repeatNonTextureActionForever: true)
        
           let oscillatingAnimation2 = NonTextureAnimation(animationState: .moving, orientation: .Right, animationName: "oscillatingAction", nonTextureAction: oscillatingAction, repeatNonTextureActionForever: true)
        
        let animationComponent = AnimationComponent(animations: [
            .moving: [ .Left: oscillatingAnimation1,
                       .Right: oscillatingAnimation2]
            ])
        
        addComponent(animationComponent)
        
        
        
        
        renderComponent.node.xScale *= 0.50
        renderComponent.node.yScale *= 0.50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}

