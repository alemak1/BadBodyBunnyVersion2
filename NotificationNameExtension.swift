//
//  NotificationNameExtension.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation


extension Notification.Name{
    
    static let DidMakeContactNotification = Notification.Name(rawValue: "didMakeContactNotification")
    static let DidEndContactNotification = Notification.Name(rawValue: "didEndContactNotification")
    static let DidTouchPlayerNodeNotification = Notification.Name("didTouchPlayerNodeNotification")
    static let DidTouchScreenNotification = Notification.Name(rawValue: "didTouchScreenNotification")
    static let PlayerDidContactLetterNotification = Notification.Name(rawValue: "playerDidContactLetterNotification")
    static let PlayerStartedBarrierContactNotification = Notification.Name(rawValue: "playerStartedBarrierContactNotification")
    static let PlayerStoppedBarrierContactNotification = Notification.Name(rawValue: "playerStoppedBarrierContactNotification")
    static let PlayerDidTakeDamageNotification = Notification.Name(rawValue: "playerDidTakeDamageNotification")
    
    static let PlayerStartedContactWithSpring = Notification.Name(rawValue: "playerStartedContactWithSpring")
    static let PlayerEndedContactWithSpring = Notification.Name(rawValue: "playerEndedContactWithSpring")
    static let PlayerStartedContactWithIce = Notification.Name(rawValue: "playerStartedContactWithIce")
    static let PlayerEndedContactWithIce = Notification.Name(rawValue: "playerEndedContactWithIce")
    
    static let PlayerStartedContactWithLadder = Notification.Name(rawValue: "playerStartedContactWithLadderNotification")
    static let PlayerEndedContactWithLadder = Notification.Name(rawValue: "playerEndedContactWithLadderNotification")
    /**
    static let PlayerEnteredEnemyProximityNotification = Notification.Name(rawValue: "playerEnteredEnemyProximityNotification")
    
    static let PlayerExitedEnemyProximityNotification = Notification.Name("playerExitedEnemyProximityNotification")
    static let EnemyDidHitPlayerNotification = Notification.Name(rawValue: "enemyDidHitPlayerNotification")
    **/
    
}
