//
//  RabbitEntity.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Player: GKEntity{
    
    
    //MARK: Properties 
    let mainMotionManager = MainMotionManager.sharedMotionManager
    
    ///ThvarRenderComponent' associated with the player
    
    var renderComponent: RenderComponent{
        guard let renderComponent = component(ofType: RenderComponent.self) else {
            fatalError("A player must have a render component")
        }
        
        return renderComponent

    }
    
    //MARK: Initializers
    
    override init() {
        super.init()
        
        /** Add the render component with the appropriate SKTexture derived from the Bunny base image
        **/
        let texture = SKTexture(image: #imageLiteral(resourceName: "bunny2_walk1"))
        let renderComponent = RenderComponent(position: .zero, autoRemoveEnabled: false)
        renderComponent.node = SKSpriteNode(texture: texture, color: .clear, size: texture.size())
        addComponent(renderComponent)
        
        
        let nodeNameComponent = NodeNameComponent(nodeName: "PlayerNode")
        addComponent(nodeNameComponent)
        
        /**  Add a physics body component whose physics body dimensions are based on that of the node texture
 
        **/
        let physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = false
        physicsBody.mass = 1.00
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, collisionConfiguration: CollisionConfiguration.Player)
        addComponent(physicsComponent)
        
        
        let motionResponderComponent = LandscapeMotionResponderComponentX(motionManager: mainMotionManager)
        addComponent(motionResponderComponent)
        
        let orientationComponent = OrientationComponent(currentOrientation: .Right)
        addComponent(orientationComponent)
        
        let animationComponent = AnimationComponent(animations: Player.animationsDict)
        addComponent(animationComponent)
        animationComponent.requestedAnimation = .moving
        
        
        let jumpComponent = JumpComponent()
        addComponent(jumpComponent)
        
        
        //The player's agent component is passive i.e. it updates its position and velocity to accommodate the movement of the player
        
        
        let passiveAgent = GKAgent2D()
        let agentComponent = AgentComponent(passiveAgent: passiveAgent, lerpingEnabled: false)
        addComponent(agentComponent)
    
        
        //The player is scaled down after the physics body is added so that the physics body scaled down along with the node texture
        
        renderComponent.node.xScale *= 0.50
        renderComponent.node.yScale *= 0.50
        
       
        let healthComponent = HealthComponent(startingHealth: 3)
        addComponent(healthComponent)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Player.swapMotionResponderComponen(notification:)), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addMotionResponderComponent(){
        //TODO: Refactor this method to take into account the starting device orientation
        
        var motionResponderComponent: MotionResponderComponent = MotionResponderComponent(motionManager: mainMotionManager)
        
        
        if UIDevice.current.orientation.isLandscape{
            motionResponderComponent = LandscapeMotionResponderComponentX(motionManager: mainMotionManager)
        } else {
            motionResponderComponent = PortraitMotionResponderComponentX(motionManager: mainMotionManager)
        }
        
        addComponent(motionResponderComponent)
    }
    
    func swapMotionResponderComponen(notification: Notification){
        
        let isPortrait = UIDevice.current.orientation.isPortrait
        
        let swapMotionResponderComponent: (Void)->(Void) = isPortrait ? {
            self.removeComponent(ofType: LandscapeMotionResponderComponentX.self)
            
            let motionResponderComponent = PortraitMotionResponderComponentX(motionManager: self.mainMotionManager)
            self.addComponent(motionResponderComponent)
        } : {
            
            self.removeComponent(ofType: PortraitMotionResponderComponentX.self)
            let motionResponderComponent = LandscapeMotionResponderComponentX(motionManager: self.mainMotionManager)
            self.addComponent(motionResponderComponent)
        }
        
        swapMotionResponderComponent()
    }
}


//TODO: Refactor so that the animations become static properties of the AnimationClass, where texture are obtained from a singleton (i.e. global texture manager); the animations dict can remain as is for the player

extension Player{
    
   
    static let moveLeftAnimation = TextureAnimation(animationState: .moving, orientation: .Left, animationName: "walkLeft", textures: [
        SKTexture(image: #imageLiteral(resourceName: "bunny2_walk1_left")), SKTexture(image: #imageLiteral(resourceName: "bunny2_walk2_left"))
        ], timePerFrame: 0.10, repeatTexturesForever: true)
    static let moveRightAnimation = TextureAnimation(animationState: .moving, orientation: .Right, animationName: "walkRight", textures: [
        SKTexture(image: #imageLiteral(resourceName: "bunny2_walk2")),SKTexture(image: #imageLiteral(resourceName: "bunny2_walk1"))
        ], timePerFrame: 0.10, repeatTexturesForever: true)
    
    static let animationsDict: [AnimationState: [Orientation:Animation]] = [
        .moving: [.Left: Player.moveLeftAnimation,
                  .Right: Player.moveRightAnimation]
    ]
}


/**  TODO: To add a contact handler component to the player, include the following code snippet:
 
 let contactHandlerComponent = ContactHandlerComponent(categoryContactHandler: {
 otherBodyCategoryMask in
 switch(otherBodyCategoryMask){
 case CollisionConfiguration.Barrier.categoryMask:
 print("Player is touching barrier")
 jumpComponent.canJump = true
 break
 case CollisionConfiguration.Letter.categoryMask:
 break
 default:
 print("No contact logic implemented")
 }
 }, nodeContactHandler: nil, categoryEndContactHandler: {
 
 otherBodyCategoryMask in
 
 switch(otherBodyCategoryMask){
 case CollisionConfiguration.Barrier.categoryMask:
 print("Player is no longer touching the barrier")
 jumpComponent.canJump = false
 break
 default:
 print("No contact logic implemented")
 }
 
 }, nodeEndContactHandler: nil)
 **/

