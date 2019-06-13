//
//  ShootingState.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 03/06/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import SpriteKit
import GameKit

class ShootingState : GKState {
    
    var node: SKNode
    var anim: SKAction

    
    init(withNode: SKNode, animation: SKAction) {
        node = withNode
        anim = animation
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is WalkingState.Type:
            return false
        case is JumpingState.Type:
            return false
        case is IdleState.Type:
            return false
        case is SlidingState.Type:
            return true
        default:
            return false
        }
    }
    
    
    override func didEnter(from previousState: GKState?) {
        
        node.run(anim, withKey: "Shoot")
    }
    override func update(deltaTime currentTime: TimeInterval) {
        super.update(deltaTime: currentTime)
        
    }
}
