//
//  AlienAttackState.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class EnemyAttackState: GKState{
    
    
    let enemyEntity: Enemy
    var targetNode: SKSpriteNode?
    
    init(enemyEntity: Alien){
        
        self.enemyEntity = enemyEntity
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
        //If the target node is set to nil (because of a notification sent to the TargetNode component, then the statemachine returns the enemy back to the inactive state
    
        if let targetNodeComponent = enemyEntity.component(ofType: TargetNodeComponent.self){
            
            if targetNodeComponent.playerHasLeftProximity{
                stateMachine?.enter(EnemyActiveState)
            } else if let node = enemyEntity.component(ofType: RenderComponent.self)?.node {
                node.lerpToPoint(targetPoint: targetNodeComponent.targetNode.position, withLerpFactor: 0.05)
                
            }

        }
        
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print("Enemy has entered the attack state, setting target node...")
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
