//
//  SceneOverlay.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/21/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

/** UIOverlayNode manages all user interactions with UserInterface Buttons such as Pause, Restart, Return-to-Main Menu, as well as ReplayKit buttons (StartRecord, StopRecord, and PreviewRecordedContent buttons)
 
 **/

class PauseOverlayNode: SKSpriteNode{
    
    //MARK: Properties
    var levelScene: BaseScene!
    
    //MARK: Initialization
    
    convenience init(levelScene: BaseScene){
        //Delegate to designated initializer
        self.init(texture: nil, color: .clear, size: CGSize.zero)

        //Load the scene and get the overlay node from it
        self.levelScene = levelScene
        
        //Scale the node to fit the entire view of the LevelScene/BaseScene
        scale(to: levelScene.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
  
    func configureRecordButtons(){
    
    }
    
    func configurePauseButton(){
        
    }
    
    func respondToUserTouchEvent(atTouchLocation touchLocation: CGPoint){
        
        
    }
    
    
    
    func showPauseStateButtons(){
        
    }
    
}
