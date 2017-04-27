//
//  PlatformerLevelSceneSuccessState.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit

class PlatformerLevelSceneSuccessState: GKState{
    
    unowned let levelScene: PlatformerBaseScene
    
    init(levelScene: PlatformerBaseScene) {
        self.levelScene = levelScene
    }
    

    
    //GKState LifeCycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
       // print("Player now in the success state..")
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        
        return false
    }
    
    
}
