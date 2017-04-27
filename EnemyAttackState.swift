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
    
    init(enemyEntity: Enemy){
        
        self.enemyEntity = enemyEntity
        super.init()
        registerForNotifications()

    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
        //If the target node is set to nil (because of a notification sent to the TargetNode component, then the statemachine returns the enemy back to the inactive state
    
        if let targetNodeComponent = enemyEntity.component(ofType: TargetNodeComponent.self){
            
            if targetNodeComponent.playerHasLeftProximity{
                stateMachine?.enter(EnemyActiveState.self)
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
            case is EnemyActiveState.Type, is EnemyInactiveState.Type:
                return true
            default:
                return false
        }
    }
    
    
    func ChangeEnemyToInactiveState(notification: Notification){
        
        guard let managedEnemyNodeName = enemyEntity.component(ofType: NodeNameComponent.self)?.nodeName else {
            print("Error: the enemy alien must have a specific node name")
            return
        }
        
        guard let contactingEnemyNodeName = notification.userInfo?["enemyNodeName"] as? String else {
            print("Error: failed to retrieve node name of the contacting enemy")
            return
        }
        
        if contactingEnemyNodeName == managedEnemyNodeName{
            stateMachine?.enter(EnemyInactiveState.self)

        }
        
    }
    
    
    func registerForNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(EnemyAttackState.ChangeEnemyToInactiveState(notification:)), name: Notification.Name.PlayerDidTakeDamageNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

class AlienAttackState: GKState{
    
    
    let alienEntity: Alien
    var targetNode: SKSpriteNode?
    
    init(alienEntity: Alien){
        
        self.alienEntity = alienEntity
        super.init()
        registerForNotifications()
        
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
        //If the target node is set to nil (because of a notification sent to the TargetNode component, then the statemachine returns the enemy back to the inactive state
        
        if let targetNodeComponent = alienEntity.component(ofType: TargetNodeComponent.self){
            
            if targetNodeComponent.playerHasLeftProximity{
                stateMachine?.enter(AlienActiveState.self)
            } else if let node = alienEntity.component(ofType: RenderComponent.self)?.node {
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
        case is AlienActiveState.Type, is AlienInactiveState.Type:
            return true
        default:
            return false
        }
    }
    
    
    func ChangeEnemyToInactiveState(notification: Notification){
        
        guard let managedEnemyNodeName = alienEntity.component(ofType: NodeNameComponent.self)?.nodeName else {
            print("Error: the enemy alien must have a specific node name")
            return
        }
        
        guard let contactingEnemyNodeName = notification.userInfo?["enemyNodeName"] as? String else {
            print("Error: failed to retrieve node name of the contacting enemy")
            return
        }
        
        if contactingEnemyNodeName == managedEnemyNodeName{
            stateMachine?.enter(AlienInactiveState.self)
            
        }
        
    }
    
    
    func registerForNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(AlienAttackState.ChangeEnemyToInactiveState(notification:)), name: Notification.Name.PlayerDidTakeDamageNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
