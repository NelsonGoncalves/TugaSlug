//
//  PlayerEntity.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerEntity : GKEntity {
    
    var st_machine : GKStateMachine?
    
    var idleAnimation: String = "Idle"
    var jumpAnimation: String = "Jump"
    var walkAnimation: String = "Run"
    var shootAnimation: String = "Shoot"
    var slideAnimation : String = "Slide"
    
    var idle:SKAction?
    var jump:SKAction?
    var walk:SKAction?
    var shoot:SKAction?
    var slide : SKAction?

    
    func prepareSprite(){
        
        idle = SKAction(named: idleAnimation)!
        jump = SKAction(named: jumpAnimation)!
        walk = SKAction(named: walkAnimation)!
        shoot = SKAction(named: shootAnimation)!
        slide = SKAction(named: slideAnimation)
        
        if let node = self.component(ofType: GKSKNodeComponent.self)?.node as! SKSpriteNode? {
            st_machine = GKStateMachine(states: [
                IdleState(withNode: node , animation: idle!),
                WalkingState(withNode: node , animation: walk!),
                JumpingState(withNode: node, animation: jump!),
                ShootingState(withNode: node, animation: shoot!),
                SlidingState(withNode: node, animation: slide!)
                ])
            st_machine?.enter(IdleState.self)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        st_machine?.update(deltaTime: seconds)
    }
}
