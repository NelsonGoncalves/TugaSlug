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
    var hitBoxSprite : SKSpriteNode?
    
    
    
    func setupPlayer(){
        c_Entity = PlayerEntity()
        
        for comp in (self.entity?.components)! {
            c_Entity?.addComponent(comp)
        }
        
        c_Entity?.prepareSprite()
        
        self.entity = c_Entity
        
        if let hitbox = self.childNode(withName: "HitBox") as? SKSpriteNode {
            hitBoxSprite = hitbox
            hitBoxSprite?.isHidden = true
            
        }
        
        let imageTexture = SKTexture(imageNamed: "PlayerIdle2")
        
        let body = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 5, center: CGPoint(x: 0.0, y: -12.0))
        body.affectedByGravity = true
        body.isDynamic = true
        body.allowsRotation = false
        body.categoryBitMask = ColliderType.PLAYER
        body.collisionBitMask = ColliderType.GROUND + ColliderType.PLATFORM + ColliderType.ENEMY
        body.contactTestBitMask = ColliderType.GROUND
        body.restitution = -1.0
        self.physicsBody = body
        
    }
    
}
