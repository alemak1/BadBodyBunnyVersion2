//
//  InProgressWord.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit



class InProgressWord: GKEntity{
    
    var targetWord: String = String()
    var inProgressWord: String = String()
    
    override init() {
        super.init()
    }
    
    convenience init(targetWord: String) {
        self.init()
        self.targetWord = targetWord.capitalized
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(InProgressWord.updateInProgressWord(notification:)), name: Notification.Name.PlayerDidContactLetterNotification, object: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
    
    func updateInProgressWord(notification: Notification){
        let userInfo = notification.userInfo
        
        if let letter = userInfo?["letter"] as? Character{
            inProgressWord.append(letter)

            let letterIndex = inProgressWord.characters.index(of: letter)
            let endIndex = inProgressWord.index(after: letterIndex!)
            
            var targetSubstring = String()
            
            if endIndex <= targetWord.endIndex{
                 targetSubstring = targetWord.substring(to: endIndex)
            } else {
                print("The inProgress word is too long")
                return
            }
            
            print("The inProgress word is \(inProgressWord)")
            print("The target substring is \(targetSubstring)")
            
            if(targetSubstring == inProgressWord){
                print("The inProgressWord still matches the target word")
                
                //Once the word matches completely, send a notification; the scene will have observer for this notification, which will signal for its stateMachine to enter the game success state
            } else {
                print("The inProgressWord does not match the target word. Clearing the inProgressWord...")
                //inProgressWord = String()
            }
            
        }
        
        
        
    }
}
