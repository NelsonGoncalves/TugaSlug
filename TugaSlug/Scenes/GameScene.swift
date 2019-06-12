//
//  GameScene.swift
//  TugaSlug
//
//  Created by Aluno Tmp on 23/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameViewController : GameViewController?
    
    var playerNode: PlayerNode?
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    //var parallaxComponentSystem: GKComponentSystem<ParallaxComponent>?
    //var platformComponentSystem: GKComponentSystem<PlatformComponent>?
    
    var before = false
    
    private var lastUpdateTime : TimeInterval = 0

    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        backgroundColor = .white
        //physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        

        //MARK: Handlers end
    
        view.isMultipleTouchEnabled = true
        
        //Actual game
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0.0,dy: -1)
        
        if ((self.childNode(withName: "Player") as? PlayerNode!) != nil){
            playerNode = (self.childNode(withName: "Player") as? PlayerNode)!
            let ent = self.entities.index(of: (playerNode?.entity)!)
            self.entities.remove(at: ent!)
            playerNode?.setupPlayer()
            self.entities.append((playerNode?.entity)!)
            if let pcc = playerNode?.entity?.component(ofType: PlayerControlComponent.self){
                pcc.setupControls(camera: camera!, scene: self)
            }
        }
        
        
        //parallaxComponentSystem = GKComponentSystem.init(componentClass: ParallaxComponent.self)
        //platformComponentSystem = GKComponentSystem.init(componentClass: PlatformComponent.self)
        
        //for entity in self.entities{
        //    parallaxComponentSystem?.addComponent(foundIn: entity)
        //    platformComponentSystem?.addComponent(foundIn: entity)
        //}
        
        

        //for component in (parallaxComponentSystem?.components)!{
        //    component.prepareWith(camera: camera)
        //}
        //for component in (platformComponentSystem?.components)!{
        //    component.setUpWithPlayer(playerNode: playerNode)
        //}
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        before = true
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        //parallaxComponentSystem?.update(deltaTime: currentTime)
        //
        //platformComponentSystem?.update(deltaTime: currentTime)
        
        self.lastUpdateTime = currentTime
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        
    }
    //MARK: ============= Physics
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.PLAYER || contact.bodyB.categoryBitMask == ColliderType.PLAYER){
            if let moveComponent = playerNode?.entity?.component(ofType: ActionComponent.self){
                moveComponent.onGround = true
            }
        }
        
        if (contact.bodyA.contactTestBitMask == ColliderType.GROUND && contact.bodyB.contactTestBitMask == ColliderType.PLATFORM){
            if let platComponent = contact.bodyB.node?.entity?.component(ofType: PlatformComponent.self) {
                platComponent.contactWithPlayerNode = true
            }
        }
        if (contact.bodyB.contactTestBitMask == ColliderType.GROUND && contact.bodyA.contactTestBitMask == ColliderType.PLATFORM){
            if let platComponent = contact.bodyA.node?.entity?.component(ofType: PlatformComponent.self) {
                platComponent.contactWithPlayerNode = true
            }
        }
        //bullet
        if(contact.bodyA.categoryBitMask == ColliderType.BULLET && contact.bodyB.categoryBitMask != ColliderType.BULLET){
            if contact.bodyA.contactTestBitMask == ColliderType.GROUND || contact.bodyA.contactTestBitMask == ColliderType.PLATFORM{
                contact.bodyA.node?.run(SKAction.removeFromParent())
            }
            if contact.bodyA.contactTestBitMask == ColliderType.ENEMY {
                if let attackComponent = contact.bodyA.node?.entity?.component(ofType: AttackComponent.self){
                    
                }
                contact.bodyA.node?.run(SKAction.removeFromParent())
            }
        }
        if(contact.bodyB.categoryBitMask == ColliderType.BULLET && contact.bodyA.categoryBitMask != ColliderType.BULLET){
            
            contact.bodyB.node?.run(SKAction.removeFromParent())
        }
    }
    
    let despawnBulletAction: SKAction = {
        let growAndFadeAction = SKAction.group([SKAction.scale(to: 50, duration: 0.5),
                                                SKAction.fadeOut(withDuration: 0.5)])
        
        let sequence = SKAction.sequence([growAndFadeAction,
                                          SKAction.removeFromParent()])
        
        return sequence
    }()
    
    
    //MARK: ============= Camera
    
    
    func centerOnNode(node: SKNode) {
        //let cameraPositionInScene: CGPoint = node.scene!.convert(node.position, from: node.parent!)
        self.camera?.run(SKAction.move(to: CGPoint(x:node.position.x , y:node.position.y), duration: 0.5))
    }
    
    override func didFinishUpdate() {
        //self.camera?.position = CGPoint(x: (playerNode?.position.x)!, y: (playerNode?.position.y)!)
        centerOnNode(node: playerNode!)
    }

}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
