//
//  PlatformerBaseScene+SKPhysicsContactDelegate.swift
//  Badboy Bunny Learns the ABCs
//
//  Created by Aleksander Makedonski on 4/27/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

/**  Conformace to SKPhysicsContactDelegate
 
 
 **/

extension PlatformerBaseScene{

    func didBegin(_ contact: SKPhysicsContact) {
    
        guard let playerPhysicsBody = player.component(ofType: PhysicsComponent.self)?.physicsBody else { return }
    
        let playerBody = (contact.bodyA.categoryBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyA : contact.bodyB
    
        let otherBody = (contact.bodyA.categoryBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyB : contact.bodyA
    
        switch(otherBody.categoryBitMask){
            case CollisionConfiguration.Barrier.categoryMask:
                //  NotificationCenter.default.post(name: Notification.Name.PlayerStartedBarrierContactNotification, object: nil, userInfo: nil)
        
            break
        case CollisionConfiguration.Letter.categoryMask:
            print("Player contacted the Letter")
            otherBody.node?.removeFromParent()
            letterFound = true
            break
        case CollisionConfiguration.Enemy.categoryMask:
        
            if let contactingEnemyNodeName = otherBody.node?.name{
            let userinfo = ["enemyNodeName":contactingEnemyNodeName]
            
            NotificationCenter.default.post(name: Notification.Name.PlayerDidTakeDamageNotification, object: nil, userInfo: userinfo)
            
            }
            break
        case CollisionConfiguration.Other.categoryMask:
            if let contactingBodyName = otherBody.node?.name{
            
            if contactingBodyName == "Ladder"{
                
                NotificationCenter.default.post(name: Notification.Name.PlayerStartedContactWithLadder, object: nil, userInfo: nil)
                }
            }
            break
        
        default:
            break
        }
    }

func didEnd(_ contact: SKPhysicsContact) {
    
    
    guard let playerPhysicsBody = player.component(ofType: PhysicsComponent.self)?.physicsBody else { return }
    
    let playerBody = (contact.bodyA.categoryBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyA : contact.bodyB
    
    let otherBody = (contact.bodyA.categoryBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyB : contact.bodyA
    
    switch(otherBody.contactTestBitMask){
    case CollisionConfiguration.Barrier.contactMask:
        // NotificationCenter.default.post(name: Notification.Name.PlayerStoppedBarrierContactNotification, object: nil, userInfo: nil)
        
        
        break
    case CollisionConfiguration.Other.categoryMask:
        if let contactingBodyName = otherBody.node?.name{
            print("Contact wiht 'other' was made,checking if it's ladder...")
            if contactingBodyName == "Ladder"{
                print("Contact with ladder was made. Sending notification...")
                NotificationCenter.default.post(name: Notification.Name.PlayerEndedContactWithLadder, object: nil, userInfo: nil)
            }
        }
        break
        
    default:
        break
    }
    }

}
