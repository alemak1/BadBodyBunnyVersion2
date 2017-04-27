//
//  PlatformerEntityManager.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class PlatformerEntityManager{
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    
    
    lazy var componentSystems: [GKComponentSystem] = {
        
        
        let renderComponent = GKComponentSystem(componentClass: RenderComponent.self)
        
        let invisibilityComponent = GKComponentSystem(componentClass: InvisibilityComponent.self)
        
        let nodeNameComponent = GKComponentSystem(componentClass: NodeNameComponent.self)
        
        let physicsComponent = GKComponentSystem(componentClass: PhysicsComponent.self)
        
        let motionResponderComponentX = GKComponentSystem(componentClass: LandscapeMotionResponderComponentX.self)
        
        let orientationComponent = GKComponentSystem(componentClass: OrientationComponent.self)
        
        let animationComponent = GKComponentSystem(componentClass: AnimationComponent.self)
        
        
        let jumpComponent = GKComponentSystem(componentClass: JumpComponent.self)
        
        let agentComponent = GKComponentSystem(componentClass: AgentComponent.self)
        
        let healthComponent = GKComponentSystem(componentClass: HealthComponent.self)
        
       
        let targetComponent = GKComponentSystem(componentClass: TargetNodeComponent.self)
        
        let intelligenceComponent = GKComponentSystem(componentClass: IntelligenceComponent.self)
        
        return [renderComponent,invisibilityComponent, nodeNameComponent, physicsComponent, motionResponderComponentX, orientationComponent, animationComponent, jumpComponent, agentComponent, healthComponent, targetComponent, intelligenceComponent]
    
    }()
    
    let scene: PlatformerBaseScene
    
    init(scene: PlatformerBaseScene){
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
    
    
    func addToEntitySet(_ entity: GKEntity){
        entities.insert(entity)
        
        for componentSystem in componentSystems{
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    
    func addToWorld(_ entity: GKEntity){
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: RenderComponent.self)?.node{
            spriteNode.move(toParent: scene.worldNode)
        }
        
        for componentSystem in componentSystems{
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    
    func addToScene(_ entity: GKEntity){
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: RenderComponent.self)?.node{
            spriteNode.move(toParent: scene)
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
    
    func getEnemyEntities() -> [Enemy]{
        return self.entities.flatMap{
            entity in
            
            if let entity = entity as? Enemy{
                return entity
            }
            
            return nil
        }
        
    }
    
   
    
    
}

extension PlatformerEntityManager{
    /**  For LevelA (Alien Scene), subclass the PlatformerEntityManager and override the update function by calling the prxoimity test function, which posts a notification each time the player enters a proximity zone around the alien, which triggers the alien transition to attack mode. The alien whose proximity space has been trespassed will be identified by its node name, which is stored in the notificaiton userInfo dict
 
    **/
    
}
