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
    //var jumpAnimation: String = "JumpAnim"
    //var doubleJumpAnimation: String = "DoubleJumpAnim"
    //var fallAnimation: String = "FallAnim"
    //var walkAnimation: String = "WalkAnim"
   // var runAnimation: String  = "RunAnim"
    
    var idle:SKAction?
   // var jump:SKAction?
   // var doubleJump:SKAction?
   // var fall:SKAction?
   // var walk:SKAction?
   // var run:SKAction?
    
    func prepareSprite(){
        
        idle = SKAction(named: idleAnimation)!
        //jump = SKAction(named: jumpAnimation)!
        //doubleJump = SKAction(named: doubleJumpAnimation)!
        //fall = SKAction(named: fallAnimation)!
        //walk = SKAction(named: walkAnimation)!
        //run =  SKAction(named: runAnimation)!
        
        if let node = self.component(ofType: GKSKNodeComponent.self)?.node as! SKSpriteNode? {
            st_machine = GKStateMachine(states: [
                IdleState(withNode: node , animation: idle!),
                //WalkingState(withNode: node , animation: walk!),
                //JumpingState(withNode: node, animation: jump!),
                //DoubleJumpState(withNode: node, animation: doubleJump!),
                //FallingState(withNode: node, animation: fall!),
                //RunningState(withNode: node, animation: run!),
                //AttackingState(withNode: node, animation: run!)
                ])
            st_machine?.enter(IdleState.self)
        }

    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        st_machine?.update(deltaTime: seconds)
    }
}
