//
//  BaseScene+SKPhysicsContactDelegate.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

//MARK: Conformance to SKPhysicsContactDelegate Method

/** Information in SKPhysicsContact is refactored into a userInfo dictionary which is passed to a notification so that component-level observers can process contact information through individual, customized contacthandlers configured for ContactHandler componenets
 
 
 **/

extension BaseScene{
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactInfoDict = SKPhysicsContact.getUserInfoDictFromPhysicsContact(contact: contact)
        
        NotificationCenter.default.post(Notification(name: Notification.Name.DidMakeContactNotification, object: nil, userInfo: contactInfoDict))
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
       
        let contactInfoDict = SKPhysicsContact.getUserInfoDictFromPhysicsContact(contact: contact)
        
        NotificationCenter.default.post(Notification(name: Notification.Name.DidEndContactNotification, object: nil, userInfo: contactInfoDict))
    }
    
}

