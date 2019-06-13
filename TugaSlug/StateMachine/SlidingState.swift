//
//  SlidingState.swift
//  TugaSlug
//
//  Created by Aluno Tmp on 12/06/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//
import GameplayKit
import SpriteKit

class SlidingState : GKState {
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
        case is ShootingState.Type:
            return true
        default:
            return false
        }
    }
    
    
    override func didEnter(from previousState: GKState?) {

        node.run(anim, withKey: "Slide")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
    }
}
