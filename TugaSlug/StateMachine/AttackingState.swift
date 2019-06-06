//
//  ShootingState.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import GameplayKit

class AttackingState : GKState {
    
    var node: SKNode
    var anim: SKAction
    var ready = true
    
    var totalDuration : Double = 0.3
    var totalCooldown : Double = 0.5
    
    var duration : Double = 0
    var cooldown : Double = 0
    
    var lastUpdateTime : Double = 0.0
    
    init(withNode: SKNode, animation: SKAction) {
        node = withNode
        anim = animation
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is WalkingState.Type:
            return false
        case is FallingState.Type:
            return false
        case is JumpingState.Type:
            return false
        case is RunningState.Type:
            return false
        case is IdleState.Type:
            return ready
        default:
            return false
        }
    }
    
    
    override func didEnter(from previousState: GKState?) {
        
        if let hitbox = (node as! PlayerNode).hitBoxSprite {
            hitbox.isHidden = false
            ready = false
            duration = totalDuration
            cooldown = totalCooldown
            lastUpdateTime = 0
        }
        
    }
    override func update(deltaTime currentTime: TimeInterval) {
        super.update(deltaTime: currentTime)
        
        if duration > 0.1 {
            duration -= currentTime
        } else if cooldown > 0.1 {
            if !ready {
                if let hitbox = (node as! PlayerNode).hitBoxSprite {
                    hitbox.isHidden = true
                    
                    stateMachine?.enter(IdleState.self)
                }
            }
            cooldown -= currentTime
        } else {
            ready = true
        }
        
    }
    
    
}

