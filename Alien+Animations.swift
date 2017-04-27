//
//  Alien+Animations.swift
//  Badboy Bunny Learns the ABCs
//
//  Created by Aleksander Makedonski on 4/27/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

/**  Define alien animations and alien animations dictionary **/

extension Alien{
    
    //Define Alien Animations
    static let setUnmannedTexturePink = TextureAnimation(animationState: .inactive, orientation: .None, animationName: "setUnmanned", textures: [
        SKTexture(image: #imageLiteral(resourceName: "shipPink"))
        ], timePerFrame: 0.10, repeatTexturesForever: false)
    
    
    static let setMannedTexturePink = TextureAnimation(animationState: .moving, orientation: .None, animationName: "setManned", textures: [
        SKTexture(image: #imageLiteral(resourceName: "shipPink_manned"))
        ], timePerFrame: 0.10, repeatTexturesForever: false)
    
    static let setUnmannedTextureBlue = TextureAnimation(animationState: .inactive, orientation: .None, animationName: "setUnmanned", textures: [
        SKTexture(image: #imageLiteral(resourceName: "shipBlue"))
        ], timePerFrame: 0.10, repeatTexturesForever: false)
    
    
    static let setMannedTextureBlue = TextureAnimation(animationState: .moving, orientation: .None, animationName: "setManned", textures: [
        SKTexture(image: #imageLiteral(resourceName: "shipBlue_manned"))
        ], timePerFrame: 0.10, repeatTexturesForever: false)
    
    static let setUnmannedTextureBeige = TextureAnimation(animationState: .inactive, orientation: .None, animationName: "setUnmanned", textures: [
        SKTexture(image: #imageLiteral(resourceName: "shipBeige"))
        ], timePerFrame: 0.10, repeatTexturesForever: false)
    
    
    static let setMannedTextureBeige = TextureAnimation(animationState: .moving, orientation: .None, animationName: "setManned", textures: [
        SKTexture(image: #imageLiteral(resourceName: "shipBeige_manned"))
        ], timePerFrame: 0.10, repeatTexturesForever: false)
    
    static let setUnmannedTextureYellow = TextureAnimation(animationState: .inactive, orientation: .None, animationName: "setUnmanned", textures: [
        SKTexture(image: #imageLiteral(resourceName: "shipYellow"))
        ], timePerFrame: 0.10, repeatTexturesForever: false)
    
    
    static let setMannedTextureYellow = TextureAnimation(animationState: .moving, orientation: .None, animationName: "setManned", textures: [
        SKTexture(image: #imageLiteral(resourceName: "shipYellow_manned"))
        ], timePerFrame: 0.10, repeatTexturesForever: false)
    
    
    //Define animations dictionary for different colored aliens
    
    typealias AnimationsDictionary = [AnimationState: [Orientation: Animation]]
    
    
    static var PinkAlienAnimationsDict: AnimationsDictionary = [
        .inactive: [.None: Alien.setUnmannedTexturePink],
        .moving: [.None: Alien.setMannedTexturePink]
    ]
    
    static var BlueAlienAnimationsDict: AnimationsDictionary = [
        .inactive: [.None: Alien.setUnmannedTextureBlue],
        .moving: [.None: Alien.setMannedTextureBlue]
    ]
    
    static var BeigeAlienAnimationsDict: AnimationsDictionary = [
        .inactive: [.None: Alien.setUnmannedTextureBeige],
        .moving: [.None: Alien.setMannedTextureBeige]
    ]
    
    
    static var YellowAlienAnimationsDict: AnimationsDictionary = [
        .inactive: [.None: Alien.setUnmannedTextureYellow],
        .moving: [.None: Alien.setMannedTextureYellow]
    ]
    
    static func getAlienAnimationsDict(color: AlienColor) -> AnimationsDictionary{
        
        switch(color){
            case .Beige:
                return BeigeAlienAnimationsDict
            case .Yellow:
                return YellowAlienAnimationsDict
            case .Blue:
                return BlueAlienAnimationsDict
            case .Pink:
                return PinkAlienAnimationsDict
            
        }
    }
    
    
    static func setAlienColor(alienColor: inout AlienColor, nodeName: String){
        
        if nodeName.contains("Blue"){
            alienColor = .Blue
        }
        
        if nodeName.contains("Yellow"){
            alienColor = .Yellow
        }
        
        if nodeName.contains("Beige"){
            alienColor = .Beige
        }
        
        if nodeName.contains("Pink"){
            alienColor = .Pink
        }
        
    }
    
}
