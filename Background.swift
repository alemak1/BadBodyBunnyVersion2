//
//  Ground.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class Background: GKEntity{
    
    var hasAddedRemainingComponents: Bool = false
    
    override init() {
        super.init()
        
        let renderComponent = RenderComponent()
        addComponent(renderComponent)
        
        renderComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        renderComponent.node.position = CGPoint(x: Double(0.00), y: Double(0.00))
       
    }
    
    
    
    func completeSceneDependentInitialization(){
        
        updateBackgroundNodeScale()
        
        let groundComponent = GroundComponent()
        addComponent(groundComponent)
        
        
        
    }
    
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func updateBackgroundNodeScale(){
        
        guard let backgroundNode = component(ofType: RenderComponent.self)?.node else {
            print("A background entity must have a render component that vends node for the background")
            return }
        
        guard let view = backgroundNode.parent?.scene?.view else {
            print("The Background node must be added to a scene before its scale can be updated")
            return
            
        }
        
        backgroundNode.scale(to: view.bounds.size)
        

    }
    
   
    
}
