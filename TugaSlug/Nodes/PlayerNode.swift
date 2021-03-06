//
//  PlayerNode.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerNode : SKSpriteNode {
    
    var c_Entity:PlayerEntity?
    var currentSpeed:CGFloat = 0
    var pressingDown = false
    var maxHealth  = 5
    var currentHealth  = 0
    var score = 0
    
    
    func setupPlayer(){
        c_Entity = PlayerEntity()
        
        for comp in (self.entity?.components)! {
            c_Entity?.addComponent(comp)
        }
        
        c_Entity?.prepareSprite()
        
        self.entity = c_Entity
        
        let imageTexture = SKTexture(imageNamed: "Armature_IDLE_00")
        
        let body = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 15, center: CGPoint(x: 0, y: -8.0))
        
        //let body = SKPhysicsBody(edgeLoopFrom: imageTexture.textureRect())
        body.affectedByGravity = true
        body.isDynamic = true
        body.allowsRotation = false
        body.mass = 0.4
        
        body.categoryBitMask = ColliderType.PLAYER
        body.collisionBitMask = ColliderType.GROUND + ColliderType.PLATFORM + ColliderType.ENEMY
        body.contactTestBitMask = ColliderType.GROUND
        body.restitution = -0.1
        
        self.physicsBody = body
        
        self.currentHealth = maxHealth
        
    }
}
