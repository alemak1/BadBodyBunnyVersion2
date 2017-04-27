//
//  ManagedNodeComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class GroundComponent: GKComponent{
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(managedNode: SKSpriteNode){
        self.init()
    }
    
    
    override func didAddToEntity() {
        createBackgroundTiles()
    }
   
   
    func createBackgroundTiles(){
        
            print("Creating background tiles...")
        
            guard let parentNode = entity?.component(ofType: RenderComponent.self)?.node else {
                print("A background component can only be enabled for an entity with a render component")
                return
            }
            
            guard let view = parentNode.parent?.scene?.view else {
                print("A managedNode must be added to scene already in order to lay out the background tiles")
                return }
            
            let groundTexture = SKTexture(image: #imageLiteral(resourceName: "grassMid"))
            let halfViewHeight = view.bounds.size.height/1.7
        
            let screenSize = UIScreen.main.bounds.size
            let viewSize = view.frame.size
        
            let startPos = -Int(view.bounds.size.width*1.5)
            let endPos = Int(view.bounds.size.width*1.5)
            
            for index in startPos...endPos{
                let groundTile = SKSpriteNode(texture: groundTexture)
                groundTile.anchorPoint = CGPoint(x: 0.00, y: 0.00)
                groundTile.xScale *= 1.5
                groundTile.yScale *= 1.5
               
                groundTile.position = CGPoint(x: Double(index), y: -Double(halfViewHeight))
                parentNode.addChild(groundTile)
                
            
            
        }
        
    }
    
}
