//
//  GameScene.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/21/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformerBaseScene: SKScene, SKPhysicsContactDelegate {
    
    var entityManager: PlatformerEntityManager!
    
    var player: Player!
    var worldNode: SKSpriteNode!
    
    let playerContactNotificationQueue = DispatchQueue(label: "playerBarrierContactNotificationQueue", attributes: .concurrent)
    
    private var lastUpdateTime : TimeInterval = 0
 
    var letterFound: Bool = false
    
    lazy var stateMachine : GKStateMachine = GKStateMachine(states: [
        PlatformerLevelSceneFailState(levelScene: self),
        PlatformerLevelSceneActiveState(levelScene: self),
        PlatformerLevelSceneSuccessState(levelScene: self),
        PlatformerLevelScenePauseState(levelScene: self)
        ])
    
    override func sceneDidLoad() {
        
        
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        super.didMove(to: view)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.00, dy: -4.00)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        

        worldNode = SKSpriteNode()
        worldNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        worldNode.position = .zero
        worldNode.scale(to: view.bounds.size)
        addChild(worldNode)
        
        
        /**
        let groundTexture = SKTexture(image: #imageLiteral(resourceName: "grassMid"))
        
        let adjustedBottomLeftCorner = CGPoint(x: ScreenPoints.BottomLeftCorner.x, y: ScreenPoints.BottomLeftCorner.y + groundTexture.size().height)
        let adjustedBottomRightCorner = CGPoint(x: ScreenPoints.BottomRightCorner.x, y: ScreenPoints.BottomRightCorner.y + groundTexture.size().height)
        
        self.physicsBody = SKPhysicsBody(edgeFrom: adjustedBottomLeftCorner, to: adjustedBottomRightCorner)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = CollisionConfiguration.Barrier.categoryMask
        self.physicsBody?.collisionBitMask = CollisionConfiguration.Barrier.collisionMask
        self.physicsBody?.contactTestBitMask = CollisionConfiguration.Barrier.contactMask
        **/
        
        /**
        let adjustedBottomLeftCornerExtension = CGPoint(x: adjustedBottomLeftCorner.x - 1000, y: adjustedBottomLeftCorner.y)

        let extendedPhysicsGround = SKPhysicsBody(edgeFrom: adjustedBottomLeftCorner, to: adjustedBottomLeftCornerExtension)
        extendedPhysicsGround.affectedByGravity = false
        extendedPhysicsGround.isDynamic = false
        extendedPhysicsGround.allowsRotation = false
        extendedPhysicsGround.categoryBitMask = CollisionConfiguration.Barrier.categoryMask
        extendedPhysicsGround.collisionBitMask = CollisionConfiguration.Barrier.collisionMask
        extendedPhysicsGround.contactTestBitMask = CollisionConfiguration.Barrier.contactMask
        **/
        
        /**
        let newJoint = SKPhysicsJoint()
        newJoint.bodyA = worldNode.physicsBody!
        newJoint.bodyB = extendedPhysicsGround
         **/
        
        /**
        let islandTexture = SKTexture(image: #imageLiteral(resourceName: "ground_grass"))
        let islandNode = SKSpriteNode(texture: islandTexture)
        islandNode.position = CGPoint(x: 100.00, y: 0.00)
        islandNode.physicsBody = SKPhysicsBody(texture: islandTexture, size: islandTexture.size())
        islandNode.physicsBody?.affectedByGravity = false
        islandNode.physicsBody?.isDynamic = false
        islandNode.physicsBody?.categoryBitMask = CollisionConfiguration.Island.categoryMask
        islandNode.physicsBody?.collisionBitMask = CollisionConfiguration.Island.collisionMask
        islandNode.physicsBody?.contactTestBitMask = CollisionConfiguration.Island.categoryMask
        worldNode.addChild(islandNode)
 
        **/
        
        
        entityManager = PlatformerEntityManager(scene: self)
        
        //let background = Background()
        // entityManager.addToScene(background)
        // background.completeSceneDependentInitialization()
        
        player = Player()
        entityManager.addToWorld(player)
        
        
        var newEntities = [GKEntity]()
        
        let islandSceneRootNode = SKScene(fileNamed: "IslandScene")?.childNode(withName: "RootNode")
        
        
        saveSpriteInformation(rootNode: islandSceneRootNode!)
        
        islandSceneRootNode!.move(toParent: worldNode)
        
        
        for node in islandSceneRootNode!.children{
            if var node = node as? SKNode{
                
                if node.name == "BladeIsland"{
                   
                    if let bladeNode = node.childNode(withName: "Blade") as? SKSpriteNode{
                        let positionVal = node.userData?.value(forKey: "position") as! NSValue
                        let position = positionVal.cgPointValue
                        

                        let texture = SKTexture(image: #imageLiteral(resourceName: "spinnerHalf"))
                        node = SKSpriteNode(texture: texture)
                        bladeNode.move(toParent: worldNode)
                    
                        bladeNode.position = position
                    
                   
                    
                        let blade = Blade(spriteNode: bladeNode as! SKSpriteNode)
                    
                        newEntities.append(blade)
                    }
                }
                
                if node.name == "Alien"{
                    let positionVal = node.userData?.value(forKey: "position") as! NSValue
                    let alienPos = positionVal.cgPointValue
                    
                    let player = entityManager.getPlayerEntities().first!
                    
                    guard let playerNode = player.component(ofType: RenderComponent.self)?.node else { break }
                    
                
                    let alienEntity = Alien(alienColor: .Pink, position: alienPos, nodeName: "alien\(alienPos)", targetNode: playerNode, minimumProximityDistance: 400.00)
                    entityManager.addToWorld(alienEntity)
                }
                
                if node.name == "EnemySun"{
                    
                    let positionVal = node.userData?.value(forKey: "position") as! NSValue
                    let position = positionVal.cgPointValue
                    
                    let texture = SKTexture(image: #imageLiteral(resourceName: "sun1"))
                    node = SKSpriteNode(texture: texture)
                    node.move(toParent: worldNode)
                    
                    node.position = position
                    
                    guard let playerAgent = player.component(ofType: AgentComponent.self)?.entityAgent else { return }
                    
                    let enemySun = EnemySun(spriteNode: node as! SKSpriteNode, targetAgent: playerAgent)
                    
                
                    
                    newEntities.append(enemySun)
                    
                }
                
                if let nodeName = node.name, nodeName.contains("Letter/"){
                    let lastChar = nodeName.characters.endIndex
                    let letterIndex = nodeName.index(before: lastChar)
                    
                    let letterString = nodeName.substring(from: letterIndex)
                    
                    switch(letterString){
                        case "A":
                            
                            let positionVal = node.userData?.value(forKey: "position") as! NSValue
                            let position = positionVal.cgPointValue
                            
                            let letterEntity = Letter(letterCategory: .letterA, position: position)
                            
                            entityManager.addToWorld(letterEntity)
                            
                            break
                        
                        default:
                            break
                    }
                    
                    
                }
            }
        }
     
       
        for entity in newEntities{
            entityManager.addToEntitySet(entity)
        }
        
        let bladeIslandPos = CGPoint(x: -250, y: 0)
        let bladeIsland = BladeIsland(position: bladeIslandPos, bladeScalingFactor: 2.0)
        entityManager.addToWorld(bladeIsland)
        bladeIsland.moveSubnodesToWorld()
        
        stateMachine.enter(PlatformerLevelSceneActiveState.self)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
     
    }
    
    func touchMoved(toPoint pos : CGPoint) {
   
    }
    
    func touchUp(atPoint pos : CGPoint) {
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: worldNode)
    
        guard let playerNode = player.component(ofType: RenderComponent.self)?.node else { return }
        
        if playerNode.contains(touchLocation){
            NotificationCenter.default.post(name: Notification.Name.DidTouchPlayerNodeNotification, object: nil, userInfo: nil)
            }
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        stateMachine.update(deltaTime: currentTime)
      
        
        entityManager.update(dt)
        
        self.lastUpdateTime = currentTime
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        guard let playerNode = player.component(ofType: RenderComponent.self)?.node else { return }
        centerOnNode(node: playerNode)
    }
    
    
    func centerOnNode(node: SKNode){
        
        guard let world = self.worldNode else { return }
        
        let nodePositionInScene = self.convert(node.position, from: world)
        
        world.position = CGPoint(x: world.position.x - nodePositionInScene.x, y: world.position.y - nodePositionInScene.y)

        
    }
    
    func saveSpriteInformation(rootNode: SKNode){
        
        for node in rootNode.children{
            
            node.userData = NSMutableDictionary()
            let positionValue = NSValue(cgPoint: node.position)
            node.userData?.setValue(positionValue, forKey: "position")
            
            saveSpriteInformation(rootNode: node)
        }
    }
    
    /**
    func centerBackground(node: SKNode){
        
        let nodePositionInScene = self.convert(node.position, from: backgroundNode)
        backgroundNode.position = CGPoint(x: backgroundNode.position.x - nodePositionInScene.x, y: backgroundNode.position.y)
    }
     **/
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let playerPhysicsBody = player.component(ofType: PhysicsComponent.self)?.physicsBody else { return }
        
        let playerBody = (contact.bodyA.contactTestBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyA : contact.bodyB
        
        let otherBody = (contact.bodyA.contactTestBitMask & CollisionConfiguration.Player.contactMask > 0) ? contact.bodyB : contact.bodyA
        
        switch(otherBody.categoryBitMask){
            case CollisionConfiguration.Barrier.categoryMask:
              //  NotificationCenter.default.post(name: Notification.Name.PlayerStartedBarrierContactNotification, object: nil, userInfo: nil)
              
                break
            case CollisionConfiguration.Letter.categoryMask:
                print("Player contacted the Letter")
                otherBody.node?.removeFromParent()
                letterFound = true
                break
            case CollisionConfiguration.Enemy.categoryMask:
                print("Sending player damage notification...")
                NotificationCenter.default.post(name: Notification.Name.PlayerDidTakeDamageNotification, object: nil, userInfo: nil)
              
                
                break
            default:
                break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        guard let playerPhysicsBody = player.component(ofType: PhysicsComponent.self)?.physicsBody else { return }
        
        let playerBody = (contact.bodyA.contactTestBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyA : contact.bodyB
        
        let otherBody = (contact.bodyA.contactTestBitMask & CollisionConfiguration.Player.contactMask > 0) ? contact.bodyB : contact.bodyA
        
        switch(otherBody.contactTestBitMask){
            case CollisionConfiguration.Barrier.contactMask:
               // NotificationCenter.default.post(name: Notification.Name.PlayerStoppedBarrierContactNotification, object: nil, userInfo: nil)
                    
 
                break
            default:
                break
        }
    }
}
