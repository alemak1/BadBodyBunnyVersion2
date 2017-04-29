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
    
    var obstacleGraph: GKObstacleGraph<GKGraphNode2D>? {
        get{
            
            if let scene = alienEntity.component(ofType: RenderComponent.self)?.node.scene as? PlatformerBaseScene{
                
                return scene.obstacleGraph
            }
            
            return nil
        }
    }
    
  
    
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
                //node.lerpToPoint(targetPoint: targetNodeComponent.targetNode.position, withLerpFactor: 0.05)
            
            
                guard let targetGraphNode = alienEntity.component(ofType: TargetNodeComponent.self)?.targetNode.entity?.component(ofType: GraphNodeComponent.self)?.graphNode else {
                    print("Could not get graph node for target i.e. the player")
                    return
                }
                
                
                guard let startGraphNode = alienEntity.component(ofType: GraphNodeComponent.self)?.graphNode else {
                    print("Could not get graph node for the start point i.e. the alien")
                    return
                }
                
                
                
                guard let obstacleGraph = obstacleGraph else {
                    print("Could not get obstacle graph")
                    return
                }
                
               
                    
                        print("Connecting start and end nodes to obstacle graph...")
                
                
                
                        obstacleGraph.connectUsingObstacles(node: startGraphNode)
                        obstacleGraph.connectUsingObstacles(node: targetGraphNode)
                
                
                        print("Determining attack path...")
                        let attackPath = obstacleGraph.findPath(from: startGraphNode, to: targetGraphNode)
                    
                    for graphNode in attackPath{
                        
                        let graphNode = graphNode as! GKGraphNode2D
                        
                        let nextPoint = graphNode.getCGPointFromGraphNodeCoordinates()
                        let moveToNextPointAction = SKAction.move(to: nextPoint, duration: 2.00)
                        
                        print("Executing move to next point in path..")
                        node.run(moveToNextPointAction)
                    }
                    
                    obstacleGraph.remove([startGraphNode,targetGraphNode])
                    
                
                
 
            
            } //
        
        }
        
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print("Enemy has entered the attack state, setting target node...")
        
        
        if let renderNode = alienEntity.component(ofType: RenderComponent.self)?.node{
            
            let colorizeAction1 = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.50, duration: 2.00)
            let colorizeAction2 = colorizeAction1.reversed()
            let colorizationSequence = SKAction.sequence([ colorizeAction1, colorizeAction2 ])
            
        
            let attackAnimation = SKAction.repeatForever(colorizationSequence)
            renderNode.run(attackAnimation, withKey: "attackAnimation")
        }
        
        if let agentComponent = alienEntity.component(ofType: AgentComponent.self){
            agentComponent.hasReachedGoal = false
        }
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


extension GKGraphNode2D{
    
    func getCGPointFromGraphNodeCoordinates() -> CGPoint{
        
        let xPos = CGFloat(self.position.x)
        let yPos = CGFloat(self.position.y)
        
        return CGPoint(x: xPos, y: yPos)
    }
    
}
