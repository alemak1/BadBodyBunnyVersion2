//
//  InvisibilityComponent.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class InvisibilityComponent: GKComponent{
    
    var spriteNode: SKSpriteNode?
    
    var visibilityInterval: TimeInterval = 0.00
    var frameCount: TimeInterval = 0.00
    
    var isVisible: Bool = true{
        didSet{
            if let spriteNode = spriteNode{
                
                let alphaValue = isVisible ? 1.00 : 0.00
                
                spriteNode.alpha = CGFloat(alphaValue)
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let renderNode = entity?.component(ofType: RenderComponent.self)?.node else {
            print("An invisibility component must have a render component in order ot function")
            return }
        
        self.spriteNode = renderNode
        
    }
    
    override func willRemoveFromEntity() {
        self.spriteNode = nil
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        frameCount += seconds
        
        if frameCount > visibilityInterval{
            
            isVisible = !isVisible
            frameCount = 0
        }
        
        
    }
}
