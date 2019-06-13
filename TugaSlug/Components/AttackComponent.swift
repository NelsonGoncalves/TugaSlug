//
//  AttackComponent.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import GameplayKit

class AttackComponent : GKComponent {

    // Container para balas
    // rate of fire
    // numer of bullets?
    var shooting = false
    var ready = false
    var cooldown = 0.0
    var totalCooldown = 0.5
    var dir = CGVector(dx: 0, dy: 0)
    
    func attack(){
        print("attack")
        if let stateMachine = (self.entity as! PlayerEntity?)?.st_machine {
            print("tried to enter state")
            if (stateMachine.canEnterState(AttackingState.self)) {
                print("entered state")	
                stateMachine.enter(AttackingState.self)
            }
        }
    }

    func shoot(direction : CGVector){
        print(direction)
        self.dir = direction
        if let stateMachine = (self.entity as! PlayerEntity?)?.st_machine {
            print("tried to enter shooting")
            if(stateMachine.canEnterState(ShootingState.self)) {
                print("Entered Shooting state")
                shooting = true
                stateMachine.enter(ShootingState.self)
            }
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        if(cooldown > 0.1){
            cooldown -= seconds
        }
        else {
            cooldown = totalCooldown
            if(shooting){
                let bullet = SKSpriteNode(imageNamed: "bullet")
                
                if let player = entity?.component(ofType: GKSKNodeComponent.self)?.node {
                    bullet.position = player.position
                    bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.height/2)
                    
                    player.scene?.addChild(bullet)
                }
                
                
                let direction = CGVector(dx: dir.dx * 20, dy: dir.dy * 20)
                //let shootAmount = direction * 1000
                //let destination = shootAmount + bullet.position

                bullet.setScale(0.5)
                bullet.physicsBody?.applyImpulse(direction)
                bullet.physicsBody?.categoryBitMask = ColliderType.BULLET
                bullet.physicsBody?.collisionBitMask = ColliderType.GROUND
                bullet.physicsBody?.contactTestBitMask =  ColliderType.ENEMY
                bullet.physicsBody?.mass = 0.1
                bullet.physicsBody?.restitution = -0.1
                
                //let actionMove = SKAction.move(to: destination, duration: 2.0)
                let actionWait = SKAction.wait(forDuration: 2.0)
                let actionRemove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([actionWait,actionRemove])
                bullet.run(sequence)
            }
        }
    }
    func MakeBullet(){
        
    }
}


