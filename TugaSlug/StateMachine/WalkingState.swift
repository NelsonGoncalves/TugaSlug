//
//  WalkingState.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import SpriteKit
import GameplayKit

class WalkingState: GKState {
    var node: SKNode
    var anim: SKAction
    
    init(withNode: SKNode, animation: SKAction) {
        node = withNode
        anim = animation
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is IdleState.Type:
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
        if let _ = previousState as? IdleState{
            print("start walking animation would play here")
        } else if let _ = previousState as? FallingState{
            print("landingState would play here")
        } else if let _ = previousState as? RunningState{
            
        } else {
            print("coming from unknown state")
        }
        
        node.run(anim,withKey: "Walk")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
    }
}
