//
//  AgentComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class AgentComponent: GKComponent, GKAgentDelegate{
    
    var entityAgent = GKAgent2D()
    var renderNode: SKSpriteNode?
    var isAgentDriven: Bool = false
    var lerpingEnabled: Bool = false
    var targetAgent: GKAgent2D?
    var hasReachedGoal: Bool = false
    
    var frameCount: TimeInterval = 0.00
    var restInterval: TimeInterval = 6.00
    
    convenience init(passiveAgent: GKAgent2D, lerpingEnabled: Bool = false) {
        self.init()
        
        entityAgent.delegate = self
        self.isAgentDriven = false
        self.lerpingEnabled = lerpingEnabled
    }
    
    
    //Convenience initializer for initializing agent components for agent-driven entities
    
    convenience init(targetAgent: GKAgent2D, maxPredictionTime: TimeInterval, maxSpeed: Float, maxAcceleration: Float, lerpingEnabled: Bool = true) {
        
        self.init()
        
        entityAgent.delegate = self
        self.isAgentDriven = true
        self.lerpingEnabled = true
        self.targetAgent = targetAgent
        
        guard let spriteNode = entity?.component(ofType: RenderComponent.self)?.node else {
            print("An agent can only be added to an entity with a render component. Error occurred for Entity: \(entity.self)")
            return
        }
        
       
        //Set initial position of the entity agent to that of the entity's sprite node
    
        entityAgent.position = spriteNode.position.getVectorFloat2()
        
        //Configure agent goals and behavior
        
        let mainGoal = GKGoal(toInterceptAgent: targetAgent, maxPredictionTime: maxPredictionTime)
        
        entityAgent.behavior = GKBehavior(goal: mainGoal, weight: 1.00)
        entityAgent.maxSpeed = maxSpeed
        entityAgent.maxAcceleration = maxAcceleration
    }
    
    override func didAddToEntity() {
        guard let renderComponentNode = entity?.component(ofType: RenderComponent.self)?.node else {
            print("An agent can only be added to an entity with a render component")
            return
        }
        
        self.renderNode = renderComponentNode
    }
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /** An entity that is agent-driven will call the agentDidUpdate method so that its Render Component updates its sprite node position to follow that of the agent; An entity that is not agent-driven will call the agentWillUpdate method so that the agent's position updates to match that of the Render Component's sprite node
 
 
    **/
    
    func agentDidUpdate(_ agent: GKAgent) {
        
        if(!isAgentDriven) { return }
        
        guard let renderNode = self.renderNode else {
            print("RenderNode failed to set for current agent component")
            return }
        
        guard let agent = agent as? GKAgent2D else {
            print("The agent must be a GKAgent2D agent")
            return
        }
        
        
        if !hasReachedGoal{
            
           // print("Trying to attack target again...")
            let adjustmentFunction: (Void) -> (Void) = lerpingEnabled ?
                {
                   // print("Lerping to target position...")
                    renderNode.lerpToPoint(agentPosition: agent.position, withLerpFactor: 0.1)
                   
                    /** This causes an uncaught exception for some reason:
                     
                     renderNode.physicsBody?.lerpToVelocity(agentVelocity: agent.velocity, withLerpFactor: 0.10) **/}
                :
                {
                   // print("Lerping to target position...")
                    renderNode.position = agent.position.getCGPoint()
                   /** renderNode.physicsBody?.velocity = agent.velocity.getCGVector() **/ }
        
        
            adjustmentFunction()
            
            if let targetAgent = targetAgent{
                if( abs(agent.position.getDistanceToPoint(otherPoint: targetAgent.position)) < 10.00){
                    hasReachedGoal = true
                    print("Goal has been reached")
                    
                }
            }
        
        }
        
        /**
        guard let targetAgent = self.targetAgent else {
            print("An active agent must have a target agent specified")
            return
        }
        
        
        if( agent.position.getDistanceToPoint(otherPoint: targetAgent.position) < 10.0){ adjustmentFunction() }
        **/
        
        
        /**
        if(lerpingEnabled){
            renderNode.lerpToPoint(agentPosition: agent.position, withLerpFactor: 0.10)
            renderNode.physicsBody?.lerpToVelocity(agentVelocity: agent.velocity, withLerpFactor: 0.10)

        } else {
            renderNode.position = agent.position.getCGPoint()
            renderNode.physicsBody?.velocity = agent.velocity.getCGVector()
        }
        **/
        
        /**
        let lerpXPos = (CGFloat(agent.position.x) - renderNode.position.x)*0.10
        let lerpYPos = (CGFloat(agent.position.y) - renderNode.position.y)*0.10
        
        renderNode.position.x += lerpXPos
        renderNode.position.y += lerpYPos
        **/
        
        
        /**
        let renderNodeVelocityDx = renderNode.physicsBody?.velocity.dx ?? 0.00
        let renderNodeVelocityDy = renderNode.physicsBody?.velocity.dy ?? 0.00
        
        let lerpXVelocity = (CGFloat(agent.velocity.x) - renderNodeVelocityDx)*0.10
        let lerpYVelocity = (CGFloat(agent.velocity.y) - renderNodeVelocityDy)*0.10
        
        renderNode.physicsBody?.velocity.dx += lerpXVelocity
        renderNode.physicsBody?.velocity.dy += lerpYVelocity
        **/
        
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        
        if(isAgentDriven) { return }
        
        
        guard let renderNode = self.renderNode else {
            print("RenderNode failed to set for current agent component")
            return }
        
        guard let agent = agent as? GKAgent2D else {
            print("The agent must be a GKAgent2D agent")
            return
        }
        
        let adjustmentFunction: (Void) -> (Void) = lerpingEnabled ?
            { agent.lerpToPoint(cgPoint: renderNode.position, withLerpFactor: 0.10) } :
            { agent.position = renderNode.position.getVectorFloat2() }
        
        adjustmentFunction()
        
        /**
        let lerpXPos = (Float(renderNode.position.x) - agent.position.x)*0.10
        let lerpYPos = (Float(renderNode.position.y) - agent.position.y)*0.10
        
        agent.position.x += lerpXPos
        agent.position.y += lerpYPos
         **/
        

    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        //guard let renderNode = renderNode else { return }
        
        if(isAgentDriven){
        
        if !hasReachedGoal{
         //   print("Updating agent...")
            entityAgent.update(deltaTime: seconds)
        } else {
          //  print("Running time until next agent-initiated behavior starts...")
            frameCount += seconds
            
            if frameCount > restInterval{
                hasReachedGoal = false
              //  print("hasReached goal reset to false")
                
    
                frameCount = 0
                }
            }
        } else {
            entityAgent.update(deltaTime: seconds)
        }
    }
}


//MARK: ******* Convenience Methods (via extension of CGPoint and vector_float2 classes) to allow easy interconversion between CGPoint and vector_float2 values


extension GKAgent2D{
    func lerpToPoint(cgPoint: CGPoint, withLerpFactor lerpFactor: Float){
        
        let lerpXPos = (Float(cgPoint.x) - self.position.x)*lerpFactor
        let lerpYPos = (Float(cgPoint.y) - self.position.y)*lerpFactor
        
        self.position.x += lerpXPos
        self.position.y += lerpYPos
        
    }
}


extension SKSpriteNode{
    func lerpToPoint(agentPosition: vector_float2, withLerpFactor lerpFactor: CGFloat){
        let lerpXPos = (CGFloat(agentPosition.x) - self.position.x)*lerpFactor
        let lerpYPos = (CGFloat(agentPosition.y) - self.position.y)*lerpFactor
        
        self.position.x += lerpXPos
        self.position.y += lerpYPos
        
    }
    
    func lerpToPoint(targetPoint: CGPoint, withLerpFactor lerpFactor: CGFloat){
        let xLerp = (targetPoint.x - self.position.x)*lerpFactor
        let yLerp = (targetPoint.x - self.position.y)*lerpFactor
        
        self.position.x += xLerp
        self.position.y += yLerp 
    }
}

extension SKPhysicsBody{
    func lerpToVelocity(agentVelocity: vector_float2, withLerpFactor lerpFactor: CGFloat){
        
        let renderNodeVelocityDx = self.velocity.dx 
        let renderNodeVelocityDy = self.velocity.dy 
        
        let lerpXVelocity = (CGFloat(agentVelocity.x) - renderNodeVelocityDx)*0.10
        let lerpYVelocity = (CGFloat(agentVelocity.y) - renderNodeVelocityDy)*0.10
        
        self.velocity.dx += lerpXVelocity
        self.velocity.dy += lerpYVelocity
    }
}

extension CGPoint{
    
    func getVectorFloat2() -> vector_float2{
        let xPos = Float(self.x)
        let yPos = Float(self.y)
        
        return vector_float2(x: xPos, y: yPos)
    }
    
    
    func getDistanceToPoint(otherPoint: CGPoint) -> Double{
        let dx = otherPoint.x - self.x
        let dy = otherPoint.y - self.y
        
        let dxSquared = Double(pow(dx, 2.0))
        let dySquared = Double(pow(dy, 2.0))
        
        return sqrt(dxSquared + dySquared)
       
       
    }
}

extension vector_float2{
    
    
    func getDistanceToPoint(otherPoint: vector_float2) -> Double{
        
        let dx = otherPoint.x - self.x
        let dy = otherPoint.y - self.y
        
        let dxSquared = Double(pow(dx, 2.0))
        let dySquared = Double(pow(dy, 2.0))
        
        return sqrt(dxSquared+dySquared)
    }
    
    func getCGPoint() -> CGPoint{
        let xPos = CGFloat(self.x)
        let yPos = CGFloat(self.y)
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func getCGVector() -> CGVector{
        
        let dx = CGFloat(self.x)
        let dy = CGFloat(self.y)
        
        return CGVector(dx: dx, dy: dy)
    
    }
    
    /**
    func getConvertedDataType<T>() -> T{
        let convertedX = CGFloat(self.x)
        let convertedY = CGFloat(self.y)
        
        var t = T()
        t.x = convertedX
        t.y = convertedY
        
        return t
    }
    **/
}
