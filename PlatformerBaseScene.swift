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
    
    var obstacleGraph: GKObstacleGraph<GKGraphNode2D>?
    
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
        
        configurePhysicsWorldProperties()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        /** Add the world node **/
        addWorldNode()

        /** Enttiy manager is added after the world node has been added to the scene **/
        entityManager = PlatformerEntityManager(scene: self)
       
        /** Add player to the entity manager; retain a reference to the player in the scene itself for convenience **/
        player = Player()
        entityManager.addToWorld(player)
    
        
        /** Add enemies, obstacles, and backgrounds to world from SKScene file. The player must be initialized before the smart enemies (i.e. those that use the player as a target agent) to be initialized from the scene file **/
        loadNodesFromSKSceneFile()
        
        
        /** After creating GKObstalce graph from scene file, the player's graph node must be added to the obstacle graph

        **/
        
        if let playerGraphNode = player.component(ofType: GraphNodeComponent.self)?.graphNode{
            obstacleGraph?.connectUsingObstacles(node: playerGraphNode)
        }
       
        /** Scene-level state machine enters the active state **/
        stateMachine.enter(PlatformerLevelSceneActiveState.self)
    }
    
    
    //MARK:     ********* Helper Functions for Setting Up Scene
    
    private func addWorldNode(){
        
        guard self.view != nil else {
            fatalError("Error: there must be a view in order for the scene to load")
        }
        
        worldNode = SKSpriteNode()
        worldNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        worldNode.position = .zero
        worldNode.scale(to: view!.bounds.size)
        addChild(worldNode)
        
    }
    
    private func configurePhysicsWorldProperties(){
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.00, dy: -4.00)
        

    }
    
    //MARK: ******** Touch Handlers
    
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
        
        let playerBody = (contact.bodyA.categoryBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyA : contact.bodyB
        
        let otherBody = (contact.bodyA.categoryBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyB : contact.bodyA
        
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
        case CollisionConfiguration.Other.categoryMask:
            if let contactingBodyName = otherBody.node?.name{
                
                if contactingBodyName == "Ladder"{
                    
                    NotificationCenter.default.post(name: Notification.Name.PlayerStartedContactWithLadder, object: nil, userInfo: nil)
                }
            }
                break
            
            default:
                break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        
        guard let playerPhysicsBody = player.component(ofType: PhysicsComponent.self)?.physicsBody else { return }
        
        let playerBody = (contact.bodyA.categoryBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyA : contact.bodyB
        
        let otherBody = (contact.bodyA.categoryBitMask & CollisionConfiguration.Player.categoryMask > 0) ? contact.bodyB : contact.bodyA
        
        switch(otherBody.contactTestBitMask){
            case CollisionConfiguration.Barrier.contactMask:
               // NotificationCenter.default.post(name: Notification.Name.PlayerStoppedBarrierContactNotification, object: nil, userInfo: nil)
                    
 
                break
        case CollisionConfiguration.Other.categoryMask:
            if let contactingBodyName = otherBody.node?.name{
                print("Contact wiht 'other' was made,checking if it's ladder...")
                if contactingBodyName == "Ladder"{
                    print("Contact with ladder was made. Sending notification...")
                    NotificationCenter.default.post(name: Notification.Name.PlayerEndedContactWithLadder, object: nil, userInfo: nil)
                }
            }
            break

            default:
                break
        }
    }
    
    func registerForNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(PlatformerBaseScene.rescaleSceneForDeviceOrientationChange), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
}


