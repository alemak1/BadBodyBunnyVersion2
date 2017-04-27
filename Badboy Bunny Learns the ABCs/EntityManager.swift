//
//  EntityManager.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation

import GameplayKit
import SpriteKit

class EntityManager{
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    
    let scene: BaseScene
    
    lazy var componentSystems: [GKComponentSystem] = {
        
        let renderComponent = GKComponentSystem(componentClass: RenderComponent.self)
        
        let portraitMotionResponderComponentX = GKComponentSystem(componentClass: PortraitMotionResponderComponentX.self)
        
        let agentComponent = GKComponentSystem(componentClass: GKAgent2D.self)
        
        let orientationComponent = GKComponentSystem(componentClass: OrientationComponent.self)
        
        let animationComponent = GKComponentSystem(componentClass: AnimationComponent.self)
        
        let jumpComponent = GKComponentSystem(componentClass: JumpComponent.self)
        
        let oscillatorComponent = GKComponentSystem(componentClass: OscillatorComponent.self)
        
        let healthComponent = GKComponentSystem(componentClass: HealthComponent.self)
        
        return [renderComponent, portraitMotionResponderComponentX,orientationComponent, animationComponent, agentComponent, jumpComponent, healthComponent]
    }()
    
    
    init(scene: BaseScene){
        self.scene = scene
    }
    
    
    func update(_ deltaTime: CFTimeInterval){
        for componentSystem in componentSystems{
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for currentRemove in toRemove{
            for componentSystem in componentSystems{
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        
        toRemove.removeAll()
    }
    
    func add(_ entity: GKEntity){
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: RenderComponent.self)?.node{
            spriteNode.move(toParent: scene.worldNode)
        }
        
        for componentSystem in componentSystems{
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    func remove(_ entity: GKEntity){
        if let spriteNode = entity.component(ofType: RenderComponent.self)?.node{
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func getPlayerEntities() -> [Player]{
        return self.entities.flatMap{entity in
            
            if let entity = entity as? Player{
                return entity
            }
            
            return nil
        }
    }
    
   
    
   
}



