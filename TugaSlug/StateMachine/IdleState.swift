//
//  IdleState.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import SpriteKit
import GameplayKit

class IdleState: GKState {
    
    var node: SKNode
    var anim: SKAction
    
    init(withNode: SKNode, animation: SKAction) {
        node = withNode
        anim = animation
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is WalkingState.Type:
            return true
        case is JumpingState.Type:
            return true
        case is ShootingState.Type:
            return true
        case is SlidingState.Type:
            return true
        default:
            return false
        }
    }
    
    
    override func didEnter(from previousState: GKState?) {
        if let _ = previousState as? WalkingState{
            
            print("stopping animation would play here")
        } else if let _ = previousState as? FallingState{
            print("landingState would play here")
        } else if let _ = previousState as? RunningState{
            print("breaking animation would play here")
        }
        
        
        node.run(anim, withKey: "Idle")
        
        
    }
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
    }
    
}
