//
//  GKEntityExtension.swift
//  Badboy Bunny Learns the ABCs
//
//  Created by Aleksander Makedonski on 4/27/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

extension GKEntity{
    
    subscript(componentType: GKComponent.Type) -> GKComponent?{
        get{
            let ComponentType = componentType.self
            return self.component(ofType: componentType)
        }
    
       
        set(newComponent){
            if self.component(ofType: componentType) != nil{
                self.removeComponent(ofType: componentType)
            }
            
            if newComponent != nil{
                self.addComponent(newComponent!)
            }
        }
    }
}
