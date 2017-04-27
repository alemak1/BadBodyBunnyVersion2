//
//  NodeNameComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class NodeNameComponent: GKComponent{
    
    var nodeName: String
    
    
    init(nodeName: String){
        self.nodeName = nodeName
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: RenderComponent.self)?.node else {
            print("The NodeNameComponent entity must have a render component")
            return
        }
        
        node.name = nodeName
        
    }
    
    override func willRemoveFromEntity() {
        guard let node = entity?.component(ofType: RenderComponent.self)?.node else {
            print("The NodeNameComponent entity must have a render component")
            return
        }
        
        node.name = nil
    }
}
