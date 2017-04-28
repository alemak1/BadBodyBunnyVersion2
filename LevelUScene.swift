//
//  LevelUScene.swift
//  Badboy Bunny Learns the ABCs
//
//  Created by Aleksander Makedonski on 4/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation

import GameplayKit
import SpriteKit

class LevelUScene: PlatformerBaseScene{
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.gravity = CGVector(dx: 0.00, dy: -3.00)
        
        if let playerNode = player.component(ofType: RenderComponent.self)?.node{
            // playerNode.position = CGPoint(x: -336, y: 646)
            // playerNode.position = CGPoint(x: 3700, y: 80)
        }
    }
    
    
    
    //MARK: ******** User-Touch Handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    
    //MARK: ********* Game Loop Functions
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        
    }
}
