//
//  PlatformComponent.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import SpriteKit
import GameKit

class PlatformComponent : GKComponent {
    
    var playerNode:PlayerNode?
    var node:SKNode?
    var contactWithPlayerNode = false
    
    func setUpWithPlayer(playerNode: PlayerNode?){
        self.playerNode = playerNode
        if let nodeComponent = self.entity?.component(ofType: GKSKNodeComponent.self){
            node = nodeComponent.node
        }
        node?.physicsBody?.categoryBitMask = ColliderType.PLATFORM
        node?.physicsBody?.contactTestBitMask = ColliderType.PLATFORM
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        if ((playerNode?.position.y)! - 46) > (node?.position.y)! && (playerNode?.pressingDown)! {
            node?.physicsBody?.categoryBitMask = ColliderType.PLATFORM
        }else {
            node?.physicsBody?.categoryBitMask = 0
        }
        
    }
    
    //    func getDown(){
    //        if (contactWithPlayerNode){
    //            node?.physicsBody?.categoryBitMask = 0
    //            contactWithPlayerNode = false
    //        }
    //    }
    
}

