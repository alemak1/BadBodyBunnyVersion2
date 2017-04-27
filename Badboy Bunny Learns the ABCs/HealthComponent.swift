//
//  HealthComponent.swift
//  Badboy Bunny Saves the Alphabet
//
//  Created by Aleksander Makedonski on 4/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class HealthComponent: GKComponent{
    
    
    let startingHealth: Int
    var currentHealth: Int
    var isInvulnerable: Bool = false
    
    var invulnerabilityInterval: TimeInterval = 6.00
    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    
    init(startingHealth: Int){
        self.startingHealth = startingHealth
        self.currentHealth = startingHealth
        super.init()
        
        //TODO: Add observer to NotificationCenter for damage notification
        
        NotificationCenter.default.addObserver(self, selector: #selector(HealthComponent.playerTakesDamage(notification:)), name: Notification.Name.PlayerDidTakeDamageNotification, object: nil)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** Called when the player has contact with a colliding/non-colliding enemy or a hostile barrier/object entity (i.e. spikes, fire, etc.) ; the level of damage may vary based on the specific enemy causing the damage, which can be ascertained from the notifications userInfo dictionary
 
    **/
    func playerTakesDamage(notification: Notification){
        if isInvulnerable {
           // print("No damage: player is temporarily invulnerable")
            return }
        
        print("Player health decreasing by -1")
        currentHealth -= 1
        
        isInvulnerable = true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
       
        
        if isInvulnerable{
            frameCount += seconds
            //print("Invulnerability frameCount is \(frameCount)")
            if(frameCount > invulnerabilityInterval){
                isInvulnerable = false
                frameCount = 0
            }
            
        }
        

    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
