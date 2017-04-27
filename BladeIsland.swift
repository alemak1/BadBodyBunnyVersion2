//
//  BladeIsland.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class BladeIsland: GKEntity{
    
    var cakeNode: SKSpriteNode!
    var spinnerNode: SKSpriteNode!
    
    convenience init(position: CGPoint, bladeScalingFactor: CGFloat) {
        self.init()
        
        
        let parentNode = SKSpriteNode()
        parentNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        parentNode.position = position
        
        let spinnerTexture = SKTexture(image: #imageLiteral(resourceName: "spinnerHalf"))
        spinnerNode = SKSpriteNode(texture: spinnerTexture)
        
        let cakeIslandTexture = SKTexture(image: #imageLiteral(resourceName: "ground_cake_small"))
        cakeNode = SKSpriteNode(texture: cakeIslandTexture)
        
        spinnerNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spinnerNode.position = CGPoint(x: parentNode.position.x, y: parentNode.position.y + cakeIslandTexture.size().height*0.50)
        
       
        parentNode.addChild(spinnerNode)
        
        
        
        cakeNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        cakeNode.position = CGPoint(x: parentNode.position.x, y: parentNode.position.y - spinnerTexture.size().height)

        
       
       
        
        parentNode.addChild(cakeNode)
        
        let renderComponent = RenderComponent(spriteNode: parentNode)
        addComponent(renderComponent)
        
        
        
        
        let orientationComponent = OrientationComponent(currentOrientation: .None)
        addComponent(orientationComponent)
        
        
        let spinAction = SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "spinnerHalf")),
            SKTexture(image: #imageLiteral(resourceName: "spinnerHalf_spin"))
            ], timePerFrame: 0.10)
        spinnerNode.run(SKAction.repeatForever(spinAction))
        
        
        spinnerNode.xScale *= bladeScalingFactor
        spinnerNode.yScale *= bladeScalingFactor
        
      
        
        spinnerNode.physicsBody = SKPhysicsBody(texture: spinnerTexture, size: spinnerTexture.size())
        spinnerNode.physicsBody?.affectedByGravity = false
        spinnerNode.physicsBody?.isDynamic = false
        spinnerNode.physicsBody?.allowsRotation = false
        spinnerNode.physicsBody?.categoryBitMask = CollisionConfiguration.Enemy.categoryMask
        spinnerNode.physicsBody?.collisionBitMask = CollisionConfiguration.Enemy.collisionMask
        spinnerNode.physicsBody?.contactTestBitMask = CollisionConfiguration.Enemy.contactMask
        
        cakeNode.physicsBody = SKPhysicsBody(texture: cakeIslandTexture, size: cakeIslandTexture.size())
        cakeNode.physicsBody?.categoryBitMask = CollisionConfiguration.Barrier.categoryMask
        cakeNode.physicsBody?.collisionBitMask = CollisionConfiguration.Barrier.collisionMask
        cakeNode.physicsBody?.contactTestBitMask = CollisionConfiguration.Barrier.contactMask
        cakeNode.physicsBody?.affectedByGravity = false
        cakeNode.physicsBody?.isDynamic = false
        cakeNode.physicsBody?.allowsRotation = false
        
        
    }
    
    
    func moveSubnodesToWorld(){
        
        guard let renderNode = component(ofType: RenderComponent.self)?.node else {
            print("Error: blade island must have a render component")
            return
        }
        
        guard let world = renderNode.parent else {
            print("Error: Parent Node must have already been added to the world in order for the subnodes to be moved")
            return
        }
        
        
        
        let cakeNodePositionInWorld = world.convert(cakeNode.position, from: renderNode)
        
        let spinnerNodePositionInWorld = world.convert(spinnerNode.position, from: renderNode)
        
        cakeNode.move(toParent: world)
        cakeNode.position = cakeNodePositionInWorld
        
        spinnerNode.move(toParent: world)
        spinnerNode.position = spinnerNodePositionInWorld
        
        renderNode.removeFromParent()
        
       
        
        
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
