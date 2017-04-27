//
//  Blade.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Blade: GKEntity{
    
    convenience init(spriteNode: SKSpriteNode){
        self.init()

        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        let originalPosition = spriteNode.position
        let renderComponent = RenderComponent(position: originalPosition, autoRemoveEnabled: false)
        renderComponent.node = spriteNode
        addComponent(renderComponent)
        
        let orientationComponent = OrientationComponent(currentOrientation: .Right)
        addComponent(orientationComponent)
        
        let animationComponent = AnimationComponent(animations: Blade.AnimationsDict)
        addComponent(animationComponent)
        animationComponent.requestedAnimation = .moving
        
        
    }
  
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension Blade{
    
    static let spinAnimationLeft = TextureAnimation(animationState: .moving, orientation: .Left, animationName: "spin", textures: [
        SKTexture(image: #imageLiteral(resourceName: "spinnerHalf")), SKTexture(image: #imageLiteral(resourceName: "spinnerHalf_spin"))
        ], timePerFrame: 0.10, repeatTexturesForever: true)
    static let spinAnimationRight = TextureAnimation(animationState: .moving, orientation: .Right, animationName: "spin", textures: [
        SKTexture(image: #imageLiteral(resourceName: "spinnerHalf")),SKTexture(image: #imageLiteral(resourceName: "spinnerHalf_spin"))
        ], timePerFrame: 0.10, repeatTexturesForever: true)
    
    static let AnimationsDict: [AnimationState: [Orientation:Animation]] = [
        .moving: [.Left: Blade.spinAnimationLeft,
                  .Right: Blade.spinAnimationRight]
    ]

    
}
