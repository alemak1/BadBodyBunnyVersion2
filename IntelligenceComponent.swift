//
//  IntelligenceComponent.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class IntelligenceComponent: GKComponent{
    
    var stateMachine: GKStateMachine?
    var notificationObserverQueue = OperationQueue()
    
    init(states: [GKState]) {
        
        stateMachine = GKStateMachine(states: states)
        super.init()
        
        stateMachine?.enter(EnemyActiveState)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        stateMachine?.update(deltaTime: seconds)
    }
    
    
    

    
}
