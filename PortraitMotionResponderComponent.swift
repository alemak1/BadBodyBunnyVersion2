//
//  PortraitMotionResponderComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import CoreMotion

class PortraitMotionResponderComponent: MotionResponderComponent{
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    
    }
    
    
    func setAppliedForceDeltaX(){
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable, let motionData = motionManager.deviceMotion{
            let horizontalAttitude = motionData.attitude.roll
            let horizontalRotationRate = motionData.rotationRate.y
            
            /**
            if((horizontalAttitude > 0.00 && horizontalRotationRate > 0.00) || (horizontalAttitude < 0.00 && horizontalRotationRate < 0.00)){
                appliedForceDeltaX = CGFloat(horizontalRotationRate)*150.00
            } **/
            
            print("Setting appliedForceDeltaX from PortraitMotionResponderComponent")
            appliedForceDeltaX = CGFloat(horizontalAttitude*adjustmentCoefficientX)

            
            
        }
    }
    
    
    func setAppliedForceDeltaY(){
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable, let motionData = motionManager.deviceMotion{
            let verticalAttitude = -motionData.attitude.pitch
            let verticalRotationRate = -motionData.rotationRate.x
            
            /**
            if((verticalAttitude < 0.00 && verticalRotationRate < 0.00) || (verticalAttitude > 0.00 && verticalRotationRate > 0.00)){
                appliedForceDeltaY = CGFloat(verticalRotationRate)*150.00
            } **/
            
            print("Setting appliedForceDeltaY from PortraitMotionResponderComponent")
            appliedForceDeltaY = CGFloat(verticalAttitude*adjustmentCoefficientY)

            
        }
    }
    
    
    
    func applyPhysicsBodyForceFromRotationInput(){
        let appliedImpulseVector = CGVector(dx: appliedForceDeltaX, dy: appliedForceDeltaY)
        physicsBody.applyForce(appliedImpulseVector)
        
    }
    
   
}

class PortraitMotionResponderComponentXY: PortraitMotionResponderComponent{
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaX()
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
    
}

class PortraitMotionResponderComponentX: PortraitMotionResponderComponent{
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaX()
        applyPhysicsBodyForceFromRotationInput()
    }
    
}


class PortraitMotionResponderComponentY: PortraitMotionResponderComponent{
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
    
}
