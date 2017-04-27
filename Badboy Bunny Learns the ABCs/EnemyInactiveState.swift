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
    var inactiveInterval : TimeInterval = 5.00
    
    init(enemyEntity: Enemy){
        self.enemyEntity = enemyEntity
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        frameCount += inactiveInterval
        
        if frameCount > inactiveInterval{
            stateMachine?.enter(EnemyActiveState)
            frameCount = 0.00
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        print("Enemy has entered an inactive state. Setting inactive framecount to zero...")
        
        frameCount = 0.00
        
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
