//
//  DoubleJumpState.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import GameplayKit
import SpriteKit

class DoubleJumpState : GKState {
    var node: SKSpriteNode
    var anim: SKAction
    
    init(withNode: SKSpriteNode, animation: SKAction) {
        node = withNode
        anim = animation
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is FallingState.Type:
            return true
        default:
            return false
        }
    }
    
    
    override func didEnter(from previousState: GKState?) {
        if let _ = previousState as? JumpingState{
            node.run(anim, completion: {
                self.stateMachine?.enter(FallingState.self)
            })
        }  else {
            print("coming from unknown state")
        }
    }
    
}
