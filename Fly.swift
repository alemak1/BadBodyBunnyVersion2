//
//  Fly.swift
//  Badboy Bunny Learns the ABCs
//
//  Created by Aleksander Makedonski on 4/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Fly: GKEntity{
    
    //MARK: Initializers
    
    init(position: CGPoint, scalingFactor: CGFloat, meshGraph: GKMeshGraph<GKGraphNode2D>?) {
        
        super.init()
        
        /** Add the render component with the appropriate SKTexture derived from the Bunny base image
         **/
        let texture = SKTexture(image: #imageLiteral(resourceName: "flyFly1"))
        let renderComponent = RenderComponent(position: position, autoRemoveEnabled: false)
        renderComponent.node = SKSpriteNode(texture: texture, color: .clear, size: texture.size())
        addComponent(renderComponent)
        
        let graphComponent = GraphNodeComponent(cgPosition: renderComponent.node.position)
        addComponent(graphComponent)
        
        let nodeNameComponent = NodeNameComponent(nodeName: "PlayerNode")
        addComponent(nodeNameComponent)
        
        /**  Add a physics body component whose physics body dimensions are based on that of the node texture
         
         **/
        let physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.linearDamping = 0.00
        
        physicsBody.mass = 1.00
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, collisionConfiguration: CollisionConfiguration.Enemy)
        addComponent(physicsComponent)
        
        // addMotionResponderComponent()
        
        /**
        let oscillatorComponent = OscillatorComponent(oscillationInterval: 4.00, leftWardForce: -50.00, rightWardForce: 50.00)
        addComponent(oscillatorComponent)
        **/
        
        
        let orientationComponent = OrientationComponent(currentOrientation: .None)
        addComponent(orientationComponent)
        

        if let meshGraph = meshGraph{
            let randomPathFinderComponent = RandomPathFinderComponent(meshGraph: meshGraph)
            addComponent(randomPathFinderComponent)
        }
        //The fly is scaled down after the physics body is added so that the physics body scaled down along with the node texture
        
        renderComponent.node.xScale *= scalingFactor
        renderComponent.node.yScale *= scalingFactor
        
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

extension Fly{
    
    
    static func configureBackAndForthAnimation(startOrientation: Orientation, currentPosition: CGPoint) -> SKAction{
        
        let randomSrc = GKRandomSource()
        let randomXDist = GKGaussianDistribution(randomSource: randomSrc, lowestValue: 100, highestValue: 200)
        
        let moveLeftPos = CGPoint(x: currentPosition.x - CGFloat(randomXDist.nextUniform()), y: currentPosition.y)
        
        let moveRightPos = CGPoint(x: currentPosition.x + CGFloat(randomXDist.nextUniform()), y: currentPosition.y)
        
        let flyLeftAction = SKAction.repeatForever(SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "flyFly1")),
            SKTexture(image: #imageLiteral(resourceName: "flyFly2"))], timePerFrame: 0.10))
        
        let flyRightAction = SKAction.repeatForever(SKAction.animate(with:  [
            SKTexture(image: #imageLiteral(resourceName: "flyFly1_right")),
            SKTexture(image: #imageLiteral(resourceName: "flyFly2_right"))], timePerFrame: 0.10))
    
        let moveToLeftPositionAction = SKAction.move(to: moveLeftPos, duration: 3.00)
        let moveToRightPositionAction = SKAction.move(to: moveRightPos, duration: 3.00)
        
        
        
        let backAndForthAction = startOrientation == .Left ? SKAction.sequence([
            flyLeftAction, moveToLeftPositionAction, flyRightAction, moveToRightPositionAction
            ]) : SKAction.sequence([
            flyRightAction, moveToRightPositionAction, flyLeftAction, moveToLeftPositionAction
            ])

        return SKAction.repeatForever(backAndForthAction)
        
    }
    
    
    static func configurePathAnimation(startOrientation: Orientation, currentPosition: CGPoint) -> SKAction{
        
        /** The points along the path will be located vertically along a random distribution whose mean is centered at the current yPosition
        **/
        
        let randomSrc = GKRandomSource()
        let randomDstY = GKGaussianDistribution(randomSource: randomSrc, mean: Float(currentPosition.y), deviation: 100)
        
        let randomDstX = GKGaussianDistribution(lowestValue: 40, highestValue: 100)
        
        let offsetLeftPosition =  CGPoint(x: currentPosition.x - CGFloat(randomDstX.nextUniform()), y: CGFloat(randomDstY.nextUniform()))
        
        let offsetRightPosition = CGPoint(x: currentPosition.x + CGFloat(randomDstX.nextUniform()), y: CGFloat(randomDstY.nextUniform()))
        
        
        let secondPoint = startOrientation == .Left ? offsetLeftPosition : offsetRightPosition
        let thirdPoint = startOrientation == .Right ? offsetRightPosition : offsetLeftPosition
        
        
        let flyLeftAction = SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "flyFly1")),
            SKTexture(image: #imageLiteral(resourceName: "flyFly2"))], timePerFrame: 0.10)
        
        let flyRightAction = SKAction.animate(with:  [
            SKTexture(image: #imageLiteral(resourceName: "flyFly1_right")),
            SKTexture(image: #imageLiteral(resourceName: "flyFly2_right"))], timePerFrame: 0.10)
        
        let action1Flapping = startOrientation == .Left ? flyLeftAction : flyRightAction
        let action2Flapping = startOrientation == .Left ? flyRightAction : flyLeftAction
        let action3Flapping = startOrientation == .Left ? flyLeftAction : flyRightAction
        
        let action1 = SKAction.group([
            action1Flapping,
            SKAction.move(to: secondPoint, duration: 4.00)
            ])
        
        let action2 = SKAction.group([
            action2Flapping,
            SKAction.move(to: thirdPoint, duration: 4.00)
            ])
        
        let action3 = SKAction.group([
            action3Flapping,
            SKAction.move(to: currentPosition, duration: 2.00)
            ])
        
        let actionAnimation = SKAction.sequence([
            action1, action2, action3
            ])
        
        return actionAnimation

    }
    
    static let flyLeftAnimation = TextureAnimation(animationState: .moving, orientation: .Left, animationName: "flyLeft", textures: [
        SKTexture(image: #imageLiteral(resourceName: "flyFly2")), SKTexture(image: #imageLiteral(resourceName: "flyFly1"))
        ], timePerFrame: 0.10, repeatTexturesForever: true)
    
    static let flyRightAnimation = TextureAnimation(animationState: .moving, orientation: .Right, animationName: "flyRight", textures: [
        SKTexture(image: #imageLiteral(resourceName: "flyFly1_right")), SKTexture(image: #imageLiteral(resourceName: "flyFly2_right"))
        ], timePerFrame: 0.10, repeatTexturesForever: true)
    

    static let FlyAnimationsDict : [AnimationState:[Orientation:Animation]] = [
    
        .moving : [ .Left: Fly.flyLeftAnimation, .Right: Fly.flyRightAnimation ]
    
    ]
}
