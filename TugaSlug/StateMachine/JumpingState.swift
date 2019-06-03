//
//  JumpingState.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import GameplayKit
import SpriteKit

class JumpingState : GKState {
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
        case is WalkingState.Type:
            return true
        case is DoubleJumpState.Type:
            return true
        default:
            return false
        }
    }
    
    
    override func didEnter(from previousState: GKState?) {
        if let _ = previousState as? IdleState{
            print("wind up to jump from idle would play here")
        } else if let _ = previousState as? WalkingState{
            print("probably nothing would play here")
        } else {
            print("coming from unknown state")
        }
        node.run(anim)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        if ((node.physicsBody?.velocity.dy)! < 100.0){
            stateMachine?.enter(DoubleJumpState.self)
        }
        
        
        if(node.physicsBody?.velocity.dy == 0){
            if (node.physicsBody?.velocity.dx == 0){
                stateMachine?.enter(IdleState.self)
            } else {
                stateMachine?.enter(WalkingState.self)
            }
        }
    }
}

