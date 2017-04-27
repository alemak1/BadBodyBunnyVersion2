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
    var skSceneFileName: String
    
    let playerContactNotificationQueue = DispatchQueue(label: "playerBarrierContactNotificationQueue", attributes: .concurrent)
    
    private var lastUpdateTime : TimeInterval = 0
 
    var letterFound: Bool = false
    
    lazy var stateMachine : GKStateMachine = GKStateMachine(states: [
        PlatformerLevelSceneFailState(levelScene: self),
        PlatformerLevelSceneActiveState(levelScene: self),
        PlatformerLevelSceneSuccessState(levelScene: self),
        PlatformerLevelScenePauseState(levelScene: self)
        ])
    
  
    
    //MARK: ******************  Initializers
    
    init(sksFileName: String, size: CGSize){
        self.skSceneFileName = sksFileName
        super.init(size: size)
        
       // registerForNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: *************** Scene Life Cycle
    
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
        
        
        entityManager = PlatformerEntityManager(scene: self)
       
        player = Player()
        entityManager.addToWorld(player)
        
        
        loadNodesFromSKSceneFile()
       
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
    
    
    func rescaleSceneForDeviceOrientationChange(notification: Notification){
        print("Rescaling scene")
        self.size = UIScreen.main.bounds.size
        MainMotionManager.sharedMotionManager.stopDeviceMotionUpdates()
        
        player.removeComponent(ofType: MotionResponderComponent.self)
        
        if UIDevice.current.orientation.isPortrait{
            let portraitMotionResponderComponentX = PortraitMotionResponderComponentX(motionManager: MainMotionManager.sharedMotionManager)
            player.addComponent(portraitMotionResponderComponentX)
        } else {
            let landscapeMotionResponderComponentX = LandscapeMotionResponderComponentX(motionManager: MainMotionManager.sharedMotionManager)
            player.addComponent(landscapeMotionResponderComponentX)
            
        }
        
        MainMotionManager.sharedMotionManager.startDeviceMotionUpdates()
        MainMotionManager.sharedMotionManager.deviceMotionUpdateInterval = 0.50
    }
   
    
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
                
                if let contactingEnemyNodeName = otherBody.node?.name{
                    let userinfo = ["enemyNodeName":contactingEnemyNodeName]
                
                    NotificationCenter.default.post(name: Notification.Name.PlayerDidTakeDamageNotification, object: nil, userInfo: userinfo)
              
                }
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
    
    func registerForNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(PlatformerBaseScene.rescaleSceneForDeviceOrientationChange), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
}

extension PlatformerBaseScene{
    
    func loadNodesFromSKSceneFile(){
        
        /** Get the root node for the sks file or else crash the app
        **/
        guard let rootNode = SKScene(fileNamed: skSceneFileName)?.childNode(withName: "RootNode") else {
            fatalError("Error: the SKS file must have a root node in order to be loaded into the present scene")
            return
        }
        
        
        /** Loop through each node in the SKS file, and save each node's position in its user dictionary.  Position data for placeholder nodes is used to initialize new entities
 
        **/
        saveSpriteInformation(rootNode: rootNode)
        
        /** Move the root node from the sks file to the world node of the current scene **/
        
        rootNode.move(toParent: worldNode)
        
        /**  Loop through all the child nodes of the root node, and if the placeholder node name contains specific keyword names, add letters, enemies, etc.
 
        **/
        for node in rootNode.children{
            if var node = node as? SKNode{
            
                addEnemy(node: node)
                addLetterEntity(node: node)
            }
        }
        
        
    
        
    }
    
    func addEnemy(node: SKNode){
        if let nodeName = node.name,nodeName.contains("Enemy/"){
            
            if nodeName.contains("BladeIsland"){
                print("Adding a blade island based on placeholder position...")
                
                let positionVal = node.userData?.value(forKey: "position") as! NSValue
                let bladeIslandPos = positionVal.cgPointValue
                
                let bladeIsland = BladeIsland(position: bladeIslandPos, bladeScalingFactor: 2.0)
                entityManager.addToWorld(bladeIsland)
                bladeIsland.moveSubnodesToWorld()
                
            }
            
            
            if nodeName.contains("Alien"){
                print("Adding an alien to the scene")
                let positionVal = node.userData?.value(forKey: "position") as! NSValue
                let alienPos = positionVal.cgPointValue
            
                let player = entityManager.getPlayerEntities().first!
            
                guard let playerNode = player.component(ofType: RenderComponent.self)?.node else {
                    print("Error: Unable to retrieve render node from player entity")
                    return

                }
                
                var alienColor: Alien.AlienColor = .Pink
            
                Alien.setAlienColor(alienColor: &alienColor, nodeName: nodeName)
            
                let alienEntity = Alien(alienColor: alienColor, position: alienPos, nodeName: "alien\(alienPos)", targetNode: playerNode, minimumProximityDistance: 400.00)
                entityManager.addToWorld(alienEntity)
            }
        }
    }
    
    
    
    
    func addLetterEntity(node: SKNode){
        
        if let nodeName = node.name, nodeName.contains("Letter/"){
            
            /** Get the letter character from the node name **/
            let letterIndex = nodeName.index(before: nodeName.characters.endIndex)
            let letterString = nodeName.substring(from: letterIndex)
        
            /** Get node position info from node's userData **/
            let positionVal = node.userData?.value(forKey: "position") as! NSValue
            let position = positionVal.cgPointValue
            
            /**  Initialize a new letter entity based on the character in the node name and the
             position from the userData dict **/
        
            var baseString = "letter"
            baseString.append(letterString)
        
            guard let letterCategory = LetterNode.LetterCategory(rawValue: baseString) else {
                print("Error: Failed to initialize a letter cateogry")
                return
            }
            
            /** Initialize a new letter entity from the letter category and position information **/
            let letterEntity = Letter(letterCategory: letterCategory, position: position, letterMass: 0.1)
            
            /** Add the letter entity to the entity manager **/
            entityManager.addToWorld(letterEntity)
            
       
        }
    }
}
