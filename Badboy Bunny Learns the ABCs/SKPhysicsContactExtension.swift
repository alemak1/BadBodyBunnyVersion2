//
//  SKPhysicsContactExtension.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

/** Extends SKPhysicsContact so as to make available convenience functions for formatting SKPhysicsContact information into a userInfo dictionary, which in turn can be passed into a Notification **/

extension SKPhysicsContact{
    
    static func getUserInfoDictFromPhysicsContact(contact: SKPhysicsContact) -> [String: Any]{
        
        let (categoryBitMaskA, collisionBitMaskA, contactBitmaskA) =
            (contact.bodyA.categoryBitMask,
             contact.bodyA.collisionBitMask,
             contact.bodyA.contactTestBitMask)
        
        
        let (categoryBitmaskB, collisionBitMaskB, contactBitMaskB) =
            (contact.bodyB.categoryBitMask,
             contact.bodyB.collisionBitMask,
             contact.bodyB.contactTestBitMask)
        
        let (nodeNameA, nodeNameB) =
            (contact.bodyA.node?.name ?? "None",
             contact.bodyB.node?.name ?? "None" )
        
        let contactInfoDict: [String: Any] = [
            
            ContactInfoKeys.PhysicsBodyACategoryBitmaskKey: categoryBitMaskA,
            ContactInfoKeys.PhysicsBodyACollisionBitmaskKey: collisionBitMaskA,
            ContactInfoKeys.PhysicsBodyAContactBitmaskKey: contactBitmaskA,
            ContactInfoKeys.PhysicsBodyANodeNameKey: nodeNameA,
            ContactInfoKeys.PhysicsBodyBCategoryBitmaskKey: categoryBitmaskB,
            ContactInfoKeys.PhysicsBodyBCollisionBitmaskKey: collisionBitMaskB,
            ContactInfoKeys.PhysicsBodyBContactBitmaskKey: contactBitMaskB,
            ContactInfoKeys.PhysicsBodyBNodeNameKey: nodeNameB
        ]
        
        return contactInfoDict
    }
    
    func getUserInfoDictionary()-> [String: Any]{
      
        let (categoryBitMaskA, collisionBitMaskA, contactBitmaskA) =
            (self.bodyA.categoryBitMask,
             self.bodyA.collisionBitMask,
             self.bodyA.contactTestBitMask)
        
       
        let (categoryBitmaskB, collisionBitMaskB, contactBitMaskB) =
            (self.bodyB.categoryBitMask,
             self.bodyB.collisionBitMask,
             self.bodyB.contactTestBitMask)
        
        let (nodeNameA, nodeNameB) =
            (self.bodyA.node?.name ?? "None",
             self.bodyB.node?.name ?? "None" )
        
        let contactInfoDict: [String: Any] = [
            
            ContactInfoKeys.PhysicsBodyACategoryBitmaskKey: categoryBitMaskA,
            ContactInfoKeys.PhysicsBodyACollisionBitmaskKey: collisionBitMaskA,
            ContactInfoKeys.PhysicsBodyAContactBitmaskKey: contactBitmaskA,
            ContactInfoKeys.PhysicsBodyANodeNameKey: nodeNameA,
            ContactInfoKeys.PhysicsBodyBCategoryBitmaskKey: categoryBitmaskB,
            ContactInfoKeys.PhysicsBodyBCollisionBitmaskKey: collisionBitMaskB,
            ContactInfoKeys.PhysicsBodyBContactBitmaskKey: contactBitMaskB,
            ContactInfoKeys.PhysicsBodyBNodeNameKey: nodeNameB
        ]
        
        return contactInfoDict
    }
}

class ContactInfoKeys{
    static let PhysicsBodyACategoryBitmaskKey: String = "categoryBitmaskA"
    static let PhysicsBodyACollisionBitmaskKey: String = "collisionBitmaskA"
    static let PhysicsBodyAContactBitmaskKey: String = "contactBitmaskA"
    static let PhysicsBodyANodeNameKey: String = "PhysicsBodyANodeName"
    
    static let PhysicsBodyBCategoryBitmaskKey: String = "categoryBitmaskB"
    static let PhysicsBodyBCollisionBitmaskKey: String = "collisionBitmaskB"
    static let PhysicsBodyBContactBitmaskKey: String = "contactBitmaskB"
    static let PhysicsBodyBNodeNameKey: String = "PhysicsBodyBNodeName"
    
    
}

