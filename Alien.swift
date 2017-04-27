//
//  Alien.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Alien: Enemy{
    
    enum AlienColor{
        case Yellow, Blue, Pink, Beige
    }
    
    let notificationObserverQueue = OperationQueue()
    
    /**  Initializer for an agent-driven enemy that has an agent components **/
    
    convenience init(alienColor: AlienColor, position: CGPoint, nodeName: String, targetAgent: GKAgent2D, maxPredictionTime: TimeInterval, maxSpeed: Float, maxAcceleration: Float) {
        self.init()
        
        var texture: SKTexture?
        
        switch(alienColor){
        case .Pink:
            texture = SKTexture(image: #imageLiteral(resourceName: "shipPink_manned"))
            break
        case .Blue:
            texture = SKTexture(image: #imageLiteral(resourceName: "shipBlue_manned"))
            break
        case .Beige:
            texture = SKTexture(image: #imageLiteral(resourceName: "shipBeige_manned"))
            break
        case .Yellow:
            texture = SKTexture(image: #imageLiteral(resourceName: "shipYellow_manned"))
            break
        default:
            texture = SKTexture(image: #imageLiteral(resourceName: "shipPink_manned"))
            break
        }
        
        guard let alienTexture = texture else {
            fatalError("Error: the texture for the alien failed to load")
        }
        
        let node = SKSpriteNode(texture: alienTexture)
        node.position = position
        
        let renderComponent = RenderComponent(spriteNode: node)
        addComponent(renderComponent)
        
        let graphNodeComponent = GraphNodeComponent(cgPosition: node.position)
        addComponent(graphNodeComponent)
        
        
        let nodeNameComponent = NodeNameComponent(nodeName: nodeName)
        addComponent(nodeNameComponent)
        
        let physicsBody = SKPhysicsBody(texture: alienTexture, size: alienTexture.size())
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, collisionConfiguration: CollisionConfiguration.Enemy)
        
        addComponent(physicsComponent)
        
        let orientationComponent = OrientationComponent(currentOrientation: .None)
        addComponent(orientationComponent)
        
        let alienAnimationsDict = Alien.getAlienAnimationsDict(color: alienColor)
        let animationComponent = AnimationComponent(animations: alienAnimationsDict)
        addComponent(animationComponent)
        
        let agentComponent = AgentComponent(targetAgent: targetAgent, maxPredictionTime: maxPredictionTime, maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, lerpingEnabled: true)
       addComponent(agentComponent)
        
    }
    
    /** Initializer for an enemy that uses a target node component to detect player proximity; doesn't rely on pathfinding algorithms to move around obstalces, and doesn't rely on the agent/goal simulation from GameplayKit **/
    
    convenience init(alienColor: AlienColor, position: CGPoint, nodeName: String, targetNode: SKSpriteNode, minimumProximityDistance: Double) {
        self.init()
        
        var texture: SKTexture?
        
        switch(alienColor){
            case .Pink:
                texture = SKTexture(image: #imageLiteral(resourceName: "shipPink_manned"))
                break
            case .Blue:
                texture = SKTexture(image: #imageLiteral(resourceName: "shipBlue_manned"))
                break
            case .Beige:
                texture = SKTexture(image: #imageLiteral(resourceName: "shipBeige_manned"))
                break
            case .Yellow:
                texture = SKTexture(image: #imageLiteral(resourceName: "shipYellow_manned"))
                break
            default:
                texture = SKTexture(image: #imageLiteral(resourceName: "shipPink_manned"))
                break
        }
        
        guard let alienTexture = texture else {
            fatalError("Error: the texture for the alien failed to load")
        }
        
        let node = SKSpriteNode(texture: alienTexture)
        node.position = position
        
        let renderComponent = RenderComponent(spriteNode: node)
        addComponent(renderComponent)
        
        let graphNodeComponent = GraphNodeComponent(cgPosition: node.position)
        addComponent(graphNodeComponent)
        
        
        let nodeNameComponent = NodeNameComponent(nodeName: nodeName)
        addComponent(nodeNameComponent)
        
        let physicsBody = SKPhysicsBody(texture: alienTexture, size: alienTexture.size())
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, collisionConfiguration: CollisionConfiguration.Enemy)
    
        addComponent(physicsComponent)
        
        let orientationComponent = OrientationComponent(currentOrientation: .None)
        addComponent(orientationComponent)
        
        let alienAnimationsDict = Alien.getAlienAnimationsDict(color: alienColor)
        let animationComponent = AnimationComponent(animations: alienAnimationsDict)
        addComponent(animationComponent)
        
        
        let targetNodeComponent = TargetNodeComponent(targetNode: targetNode, proximityDistance: minimumProximityDistance)
        addComponent(targetNodeComponent)
        
        let intelligenceComponent = IntelligenceComponent(states: [
            AlienInactiveState(alienEntity: self),
            AlienAttackState(alienEntity: self),
            AlienActiveState(alienEntity: self)
            ])
        addComponent(intelligenceComponent)
        intelligenceComponent.stateMachine?.enter(AlienInactiveState.self)
        
    }
    
    convenience init(spriteNode: SKSpriteNode, targetAgent: GKAgent2D?) {
        self.init()
    
        let originalPosition = spriteNode.position
        let renderComponent = RenderComponent(position: originalPosition, autoRemoveEnabled: false)
        renderComponent.node = spriteNode
        addComponent(renderComponent)
    
        let orientationComponent = OrientationComponent(currentOrientation: .None)
        addComponent(orientationComponent)
    
   
        /**
        if let targetAgent = targetAgent{
            let agentComponent = AgentComponent(targetAgent: targetAgent, maxPredictionTime: 10.00,     maxSpeed: 1.00, maxAcceleration: 1.00, lerpingEnabled: true)
            addComponent(agentComponent)
        }
        **/
    }

override init() {
    super.init()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

 

  

}


