//
//  CoreMotionHelper.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import CoreMotion

class CoreMotionHelper{
    
    static let sharedHelper = CoreMotionHelper()
    
    let motionManager = CMMotionManager()
    
    private init() {
        
    }
    
    
    func getDeviceMotionData(interval: TimeInterval = 0.1, closure: @escaping (_ pitch: Double, _ roll: Double, _ yaw: Double) -> Void){
        
        if motionManager.isDeviceMotionAvailable{
            
            motionManager.deviceMotionUpdateInterval = interval
            
            motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: {
                
                (data: CMDeviceMotion?, error: Error?) -> Void in
                
                if(error != nil){
                    print("An error occurred while retrieving device motion data: \(error.debugDescription)")
                    return
                }
                
                if let data = data{
                    let pitch = data.attitude.pitch
                    let yaw = data.attitude.yaw
                    let roll = data.attitude.roll
                    
                    closure(pitch, roll, yaw)
                }
                
                
            })
        }
    }
    
    
    func getGyroData(interval: TimeInterval = 0.1, closure: @escaping (_ rotationRateX: Double, _ rotationRateY: Double, _ rotationRateZ: Double) -> Void){
        
        if motionManager.isGyroAvailable{
            
            motionManager.gyroUpdateInterval = interval
            
            motionManager.startGyroUpdates(to: OperationQueue(), withHandler: {
                (data: CMGyroData?, error: Error?) -> Void in
                
                if error != nil {
                    print("An error occurred while retrieving gyroscope data: \(error.debugDescription)")
                    return
                }
                
                
                if let data = data{
                    
                    let deviceRotationRateX = data.rotationRate.x
                    let deviceRotationRateY = data.rotationRate.y
                    let deviceRotationRateZ = data.rotationRate.z
                    
                    closure(deviceRotationRateX,deviceRotationRateY,deviceRotationRateZ)
                }
                
            })
        }
    }
}
