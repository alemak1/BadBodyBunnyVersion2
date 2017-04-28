//
//  RandomPathFinderComponent.swift
//  Badboy Bunny Learns the ABCs
//
//  Created by Aleksander Makedonski on 4/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


//TODO: Not yet fully implemented

class RandomPathFinderComponent: GKComponent{
    
    let pathfindingQueue = DispatchQueue(label: "pathFindingQueue", qos: .background, attributes: .concurrent)
    
    
    var meshGraph: GKMeshGraph<GKGraphNode2D>
    
    var nodePath: [GKGraphNode]?
    var currentPathNodeIndex: Int = 0
 
    var renderNode: SKSpriteNode?
    
    
    init(meshGraph: GKMeshGraph<GKGraphNode2D>){
        self.meshGraph = meshGraph
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if inPathFindingMode(){ return } else {
            
            startPathfinding()
        }
            
        
    }
    
    override func didAddToEntity() {
        renderNode = entity?.component(ofType: RenderComponent.self)?.node
    }
    
    func startPathfinding(){
        
        nodePath = findRandomPath()
        print("Debug info for nodePath is\(nodePath?.debugDescription)")
        
        pathfindingQueue.async {
            
            guard let renderNode = self.renderNode else {
                print("The renderNode must be available in order to set the initial position")
                return
            }
            
            guard let nodePath = self.nodePath as? [GKGraphNode2D] else {
                print("The node path must be initialized in order to set the intial position")
                return
            }
            
        
            print("Node path found...")
            print("The total number of nodes in the path is: \(nodePath.count)")
        
            renderNode.position = nodePath[self.currentPathNodeIndex].position.getCGPoint()

            while self.currentPathNodeIndex < nodePath.count{
                self.currentPathNodeIndex += 1
                
                let nextNode = nodePath[self.currentPathNodeIndex]
                
                let nextPosition = nextNode.position.getCGPoint()
                
                renderNode.run(SKAction.move(to: nextPosition, duration: 3.00))
            }
            
        
        }
        
        self.currentPathNodeIndex = 0
        self.nodePath = nil
        
    }
    
    
    
    
    func inPathFindingMode() -> Bool{
        
        return nodePath != nil
    }
    
    func findRandomPath() -> [GKGraphNode]?{
        
        guard let graphNodes = meshGraph.nodes else {
            print("Error: Cannot implement pathfinding unless mesh graph is available")
            return nil }

        print("The total number of graph nodes is\(graphNodes.count)")
        print("Finding a random path...")
        
        let randSrc = GKMersenneTwisterRandomSource()
        let randDst = GKRandomDistribution(randomSource: randSrc, lowestValue: 0, highestValue: graphNodes.count-1)
        
        
        var firstRandomIndex = randDst.nextInt()
        var secondRandomIndex: Int
        
        var isTrulyNew: Bool
        
        repeat{
            isTrulyNew = true
            print("Finding random end index for pathnode array..")
            secondRandomIndex = randDst.nextInt()
            
            if secondRandomIndex == firstRandomIndex{
                isTrulyNew = false
            }
        }while(!isTrulyNew)
        
        let randomStartIndex =  firstRandomIndex < secondRandomIndex ? firstRandomIndex : secondRandomIndex
        let randomEndIndex = firstRandomIndex < secondRandomIndex ? secondRandomIndex : firstRandomIndex
        
        let startNode = graphNodes[randomStartIndex]
        let endNode = graphNodes[randomEndIndex]
        
        print("The startNode index is \(randomStartIndex), the endNode index is \(randomEndIndex)")
        print("The startNode is \(startNode.debugDescription)")
        print("The endNode is \(endNode.debugDescription)")
        
        meshGraph.connectToLowestCostNode(node: startNode, bidirectional: true)
        meshGraph.connectToLowestCostNode(node: endNode, bidirectional: true)
            
        return meshGraph.findPath(from: startNode, to: endNode)
    }
}
