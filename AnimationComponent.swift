//
//  AnimationComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


enum AnimationState: String{
    

    case moving = "moving"
    case jump = "jump"
    case attack = "attack"
    case hit = "hit"
    case dead = "dead"
    case inactive = "inactive"
    case followingPathFromLeft = "followingPathFromLeft"
    case followingPathFromRight = "followingPathFromRight"
    
}


//Animations are implemented as classes (i.e. reference types ) so that the animations can be preloaded as static properties of the animation class, with the Animations Dictionary being preloaded as static properties of each character's class, and therefore easily referenced for quick adjustments of animation in response to changes in animation state and orientation


class Animation{
    //The animation state represented in this animation
    
    let animationState: AnimationState
    
    //The direction the character is facing during this animatino
    
    let orientation: Orientation
    
    //The general SKAction associated with this animation (can be texture-based or non-textured based, or a combination of both) 
    
    let mainAction: SKAction?
    
    //The optional name or key for this animation
    let animationName: String?
    
    init(animationState: AnimationState, orientation: Orientation, animationName: String?, mainAction: SKAction?){
        self.animationState = animationState
        self.orientation = orientation
        self.animationName = animationName
        self.mainAction = mainAction
    }
    
    
}


class TextureAnimation: Animation{
    
    //One or more SKTexture's to animation as a cycle for this animation
    
    let textures: [SKTexture]
    
    
    //The timePerFrame for texture animations in which multiple textures from an array are animated to create an action
    
    let timePerFrame: Double
    
    //Whether this action's texture's array should be repeated forever
    
    let repeatTexturesForever: Bool
    
    

    init(animationState: AnimationState, orientation: Orientation, animationName: String?, textures: [SKTexture], timePerFrame: Double, repeatTexturesForever: Bool){
        
        self.textures = textures
        self.timePerFrame = timePerFrame
        self.repeatTexturesForever = repeatTexturesForever
        
        super.init(animationState: animationState, orientation: orientation, animationName: animationName, mainAction: nil)
        
       
    }
}


class NonTextureAnimation: Animation{
    
    
    //The optional nonTexture action for this entity's body
    
    let nonTextureAction: SKAction
    
    //Whether the nonTextureActino should be repeated forever
    
    let repeatNonTextureActionForever: Bool
    
    init(animationState: AnimationState, orientation: Orientation, animationName: String?, nonTextureAction: SKAction, repeatNonTextureActionForever: Bool){
        
        self.nonTextureAction = nonTextureAction
        self.repeatNonTextureActionForever = repeatNonTextureActionForever
        
        super.init(animationState: animationState, orientation: orientation, animationName: animationName, mainAction: nil)
        
       
    }

}

class AnimationComponent: GKComponent{
    
    
    //The key to use when adding a non-texture animation to this entity
    static let textureActionKey = "textureAction"
    
    //The key to use when adding a non-texture action to this entity
    static let nonTextureActionKey = "nonTextureAction"
    
    
    //The node on which animations should be run for this animation component
    var node: SKSpriteNode?
    
    //The current set of animations for the component's entity
    var animations: [AnimationState:[Orientation:Animation]]
    
    //The animation that is currently running 
    private(set) var currentAnimation: Animation?
    private(set) var previousAnimation: Animation?
    
    var requestedAnimation: AnimationState? = nil
    
    
    init(animations: [AnimationState:[Orientation: Animation]]){
        
        self.animations = animations
        
        super.init()
    }
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: RenderComponent.self)?.node else {
            print("The entity must have a render component")
            return
        }
        
        self.node = node
        requestedAnimation = nil
    }
    
    override func willRemoveFromEntity() {
        node = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func runAnimationForAnimationState(animationState: AnimationState, orientation: Orientation){
        
       
        
        guard let node = node else { return }
        
        
        //Check if we are already running this animation; if so, then exit the function
        if currentAnimation != nil && currentAnimation!.animationState == animationState && currentAnimation!.orientation == orientation { return }
        
        guard let unwrappedAnimation = animations[animationState]?[orientation] else {
            print("Unknown animation for state \(animationState.rawValue) and orientation \(orientation.rawValue)")
            return
        }
        
        let animation = unwrappedAnimation
        
        switch(animation.self){
            case is TextureAnimation:
                let animation = animation as! TextureAnimation
                
                node.removeAction(forKey: AnimationComponent.textureActionKey)
                
                let texturesAction: SKAction
                
                if animation.textures.count == 1{
                    texturesAction = SKAction.setTexture(animation.textures.first!)
                } else {
                    
                    if animation.repeatTexturesForever{
                        texturesAction = SKAction.repeatForever(SKAction.animate(with: animation.textures, timePerFrame: animation.timePerFrame))
                    } else {
                        texturesAction = SKAction.animate(with: animation.textures, timePerFrame: animation.timePerFrame)
                    }
                }
                
                //Run the new texture animation on the animation node
                node.run(texturesAction, withKey: AnimationComponent.textureActionKey)
                

                break
            case is NonTextureAnimation:
                let animation = animation as! NonTextureAnimation
                
                let nonTextureActionName = animation.animationName
                    
                //Remove the previous action
                node.removeAction(forKey: AnimationComponent.nonTextureActionKey)
                    
                //Reset the position of the animation node so that it aligns with the parent entity's render component node
                node.position = .zero
                    
                let nonTextureAction = animation.nonTextureAction
                
                if animation.repeatNonTextureActionForever{
                    node.run(SKAction.repeatForever(nonTextureAction))
                } else {
                    node.run(nonTextureAction, withKey: AnimationComponent.nonTextureActionKey)

                }
                
                
                
                break
        default:
            print("Unknown animation type. No action exists")
        }
        
       
        
        
     
        currentAnimation = animation
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let orientationComponent = entity?.component(ofType: OrientationComponent.self) else {
            fatalError("An animation component's entity must have an orientation component")
        }
        
        //If the orientation of the character has changed for a given animation state, request a new animation
        

        
        if let currentAnimation = currentAnimation, let previousAnimation = previousAnimation, currentAnimation.animationState == previousAnimation.animationState, orientationComponent.currentOrientation != currentAnimation.orientation{
           

            runAnimationForAnimationState(animationState: currentAnimation.animationState, orientation: orientationComponent.currentOrientation)
        }
        
        //If an animation state has been requested, run the animation
        

        if let animationState = requestedAnimation{
            
            print("Running new animation...")

            
            runAnimationForAnimationState(animationState: animationState, orientation: orientationComponent.currentOrientation)
            
            requestedAnimation = nil
        }
        
        previousAnimation = currentAnimation
    }
}
