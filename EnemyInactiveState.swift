//
//  AlienInactiveState.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

/**  Enemies remain in the inactive state for the length of the inactivity interval,a fter which they enter the active state.  Enemies enter an inactive state after causing damage to the player in order to avoid repeated hits.  Players likewise enter an invulnerability period to avoid premature death.
 
 **/

class EnemyInactiveState: GKState{
    
    let enemyEntity: Enemy
    
    var frameCount: TimeInterval = 0.00
    var inactiveInterval : TimeInterval = 7.00
    
    init(enemyEntity: Enemy){
        self.enemyEntity = enemyEntity
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        frameCount += inactiveInterval
        
        if frameCount > inactiveInterval{
            stateMachine?.enter(EnemyActiveState.self)
            frameCount = 0.00
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print("Enemy has entered an inactive state. Setting inactive framecount to zero...")
        
        frameCount = 0.00
        
        if let enemyAnimationComponent = enemyEntity.component(ofType: AnimationComponent.self){
            
            
        }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        
        switch(stateClass){
            case is EnemyActiveState.Type:
                return true
            default:
                return false
        }
        
    }
}


class AlienInactiveState: GKState{
    let alienEntity: Alien
    
    var frameCount: TimeInterval = 0.00
    var inactiveInterval : TimeInterval = 4.00
    
    init(alienEntity: Alien){
        self.alienEntity = alienEntity
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        frameCount += seconds
        
        if frameCount > inactiveInterval{
            stateMachine?.enter(AlienActiveState.self)
            frameCount = 0.00
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print("Enemy has entered an inactive state. Setting inactive framecount to zero...")
        
        frameCount = 0.00
        
        if let renderNode = alienEntity.component(ofType: RenderComponent.self)?.node, renderNode.action(forKey: "attackAnimation") != nil{
            renderNode.removeAction(forKey: "attackAnimation")
            
        }
        
        
    
        
        if let alienAnimationComponent = alienEntity.component(ofType: AnimationComponent.self), let alienRenderComponent = alienEntity.component(ofType: RenderComponent.self){
            
            alienRenderComponent.resetToOriginalPosition()
            alienAnimationComponent.requestedAnimation = .inactive
            
        }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        
        switch(stateClass){
        case is AlienActiveState.Type:
            return true
        default:
            return false
        }
        
    }
}
