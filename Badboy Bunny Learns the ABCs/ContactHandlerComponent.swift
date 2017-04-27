//
//  ContactHandlerComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class ContactHandlerComponent: GKComponent{
   
    
    //A CategoryContactHandler is a type for callbacks that enables an entity to respond to other physics bodies belonging to a given category; a NodeContactHandler is a type for callbacks that enables an entity to respond to physics bodies with a specific name
    
    typealias CategoryContactHandler = (_ otherBodyCategoryBitmask: UInt32) -> Void
    typealias NodeContactHandler = (_ otherBodyNodeName: String) -> Void
    
    //A callback method is provided as an argument to the initializer to allow for the parent entity's physics body to respond to physics contacts for handling contact with different physics bodies
    
    var categoryContactHandler: CategoryContactHandler?
    var nodeContactHandler: NodeContactHandler?
    
    var categoryEndContactHandler: CategoryContactHandler?
    var nodeEndContactHandler: NodeContactHandler?
    
    init(categoryContactHandler: CategoryContactHandler?, nodeContactHandler: NodeContactHandler?, categoryEndContactHandler: CategoryContactHandler?, nodeEndContactHandler: NodeContactHandler?) {
        self.categoryContactHandler = categoryContactHandler
        self.nodeContactHandler = nodeContactHandler
        
        self.categoryEndContactHandler = categoryEndContactHandler
        self.nodeEndContactHandler = nodeEndContactHandler
        
        super.init()
        
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ContactHandlerComponent.didMakeContact(notification:)), name: Notification.Name.DidMakeContactNotification, object: nil)
        
        nc.addObserver(self, selector: #selector(ContactHandlerComponent.didEndContact(notification:)), name: Notification.Name.DidEndContactNotification, object: nil)
    }
    
 

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: A notification is posted when a physics body of a given category type makes contact with another physics body; the contact handler is then called as a callback
    func didMakeContact(notification: Notification){
        
        guard let (otherBodyCategoryBitMask, otherBodyNodeName) = getOtherBodyInfoFromPhysicsContact(notification: notification) else {
            
                print("Error: Failed to obtain physics contact info for other body")
                return
            }
            
            if let categoryContactHandler = self.categoryContactHandler{
                categoryContactHandler(otherBodyCategoryBitMask)
            }
            
            if let nodeContactHandler = self.nodeContactHandler{
                nodeContactHandler(otherBodyNodeName)
            }
        
     
    }
    
    func didEndContact(notification: Notification){
        
        guard let (otherBodyCategoryBitMask, otherBodyNodeName) = getOtherBodyInfoFromPhysicsContact(notification: notification) else {
            
                print("Error: Failed to obtain physics contact info for other body")
                return
        }
        
        if let categoryEndContactHandler = self.categoryEndContactHandler{
            categoryEndContactHandler(otherBodyCategoryBitMask)
        }
        
        
        if let nodeEndContactHandler = self.nodeEndContactHandler{
            nodeEndContactHandler(otherBodyNodeName)
        }
        
    }

    /**  MARK:  ********* Convenience Method for getting the category bitmask and node name for the physics body other than that of the current physics body from a notification broadcast during a collision event
 
 
    **/
    private func getOtherBodyInfoFromPhysicsContact(notification: Notification) -> (OtherBodyCategoryBitMask: UInt32, OtherBodyNodeName: String)?{
        
        
        guard let contactInfoDict = notification.userInfo else {
            print("Error: contact user info dict not provided in notification or not available")
            return nil
            
        }
        
        guard let physicsBody = entity?.component(ofType: PhysicsComponent.self)?.physicsBody else {
            print("Error: the entity must have a physics body in order for a contact handler to act as a component")
            return nil
            
        }
        
        
        
        let (bodyAName,bodyACategoryBitmask) = (contactInfoDict[ContactInfoKeys.PhysicsBodyANodeNameKey] as! String, contactInfoDict[ContactInfoKeys.PhysicsBodyACategoryBitmaskKey] as! UInt32)
        
        let (bodyBName,bodyBCategoryBitmask) =
            (contactInfoDict[ContactInfoKeys.PhysicsBodyBNodeNameKey] as! String, contactInfoDict[ContactInfoKeys.PhysicsBodyBCategoryBitmaskKey] as! UInt32)
        
        
        var otherBodyCategoryBitmask: UInt32
        var otherBodyNodeName: String
        
        if(physicsBody.categoryBitMask & bodyACategoryBitmask > 0){
            otherBodyCategoryBitmask = bodyBCategoryBitmask
            otherBodyNodeName = bodyBName
        } else {
            otherBodyCategoryBitmask = bodyACategoryBitmask
            otherBodyNodeName = bodyAName
        }

        return (otherBodyCategoryBitmask, otherBodyNodeName)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
