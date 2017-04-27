//
//  SKNodeExtension.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


extension SKNode{
    
    func copySKNode() -> SKNode{
        let copy = self.copy() as! SKNode
        
        return copy
    }
    
    
}

extension SKSpriteNode{
    func copySpriteNodeWithPhysicsProperites() -> SKSpriteNode{
        let copy = self.copy() as! SKSpriteNode
        copy.physicsBody = self.physicsBody
        
        return copy
    }
}
