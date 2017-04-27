//
//  PlatformerLevelSceneActive.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class PlatformerLevelSceneActiveState: GKState{
    
    unowned let levelScene: PlatformerBaseScene
    
    init(levelScene: PlatformerBaseScene) {
        self.levelScene = levelScene
    }
    
    
    //GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        
        switch(stateClass){
            case is PlatformerLevelSceneSuccessState.Type, is PlatformerLevelSceneFailState.Type, is PlatformerLevelScenePauseState.Type:
            return true
            default:
                return false
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if(levelScene.letterFound){
            stateMachine?.enter(PlatformerLevelSceneSuccessState.self)
        }
        
        let player = levelScene.entityManager.getPlayerEntities().first!
        
        if let playerHealth = player.component(ofType: HealthComponent.self)?.currentHealth{
            if(playerHealth <= 0){
                stateMachine?.enter(PlatformerLevelSceneFailState.self)
            }
        }
        
    }
    
}
