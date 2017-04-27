//
//  PlatformerLevelScenePauseState.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit


class PlatformerLevelScenePauseState: GKState{
    
    unowned let levelScene: PlatformerBaseScene
    
    init(levelScene: PlatformerBaseScene) {
        self.levelScene = levelScene
    }
    
    
    //GKState LifeCycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        
        switch(stateClass){
            case is PlatformerLevelSceneActiveState.Type:
                return true
            default:
                return false
        }
    }
    
}
