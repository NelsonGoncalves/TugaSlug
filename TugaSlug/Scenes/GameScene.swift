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
    var parallaxComponentSystem: GKComponentSystem<ParallaxComponent>?
    var platformComponentSystem: GKComponentSystem<PlatformComponent>?
    
    var before = false
    
    private var lastUpdateTime : TimeInterval = 0
    
    let jSizePlusSpriteNode = SKSpriteNode(imageNamed: "plus")
    let jSizeMinusSpriteNode = SKSpriteNode(imageNamed: "minus")
    let setJoystickStickImageBtn = SKLabelNode()
    let setJoystickSubstrateImageBtn = SKLabelNode()
    //let joystickStickColorBtn = SKLabelNode(text: "Sticks random color")
    //let joystickSubstrateColorBtn = SKLabelNode(text: "Substrates random color")

    
    let moveJoystick = 🕹(withDiameter: 100)
    let rotateJoystick = TLAnalogJoystick(withDiameter: 100)
    
    var joystickStickImageEnabled = true {
        didSet {
            let image = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            moveJoystick.handleImage = image
            rotateJoystick.handleImage = image
            setJoystickStickImageBtn.text = "\(joystickStickImageEnabled ? "Remove" : "Set") stick image"
        }
    }
    
    var joystickSubstrateImageEnabled = true {
        didSet {
            let image = joystickSubstrateImageEnabled ? UIImage(named: "jSubstrate") : nil
            moveJoystick.baseImage = image
            rotateJoystick.baseImage = image
            setJoystickSubstrateImageBtn.text = "\(joystickSubstrateImageEnabled ? "Remove" : "Set") substrate image"
        }
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        backgroundColor = .white
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: 0, y: 0, width: frame.midX, height: frame.height))
        moveJoystickHiddenArea.joystick = moveJoystick
        moveJoystick.isMoveable = true
        addChild(moveJoystickHiddenArea)
        
        let rotateJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: frame.midX, y: 0, width: frame.midX, height: frame.height))
        rotateJoystickHiddenArea.joystick = rotateJoystick
        addChild(rotateJoystickHiddenArea)
        
        //MARK: Handlers begin
        moveJoystick.on(.begin) { [unowned self] _ in
            let actions = [
                SKAction.scale(to: 0.5, duration: 0.5),
                SKAction.scale(to: 1, duration: 0.5)
            ]
            
            self.playerNode?.run(SKAction.sequence(actions))
        }
        
        moveJoystick.on(.move) { [unowned self] joystick in
            guard let playerNode = self.playerNode else {
                return
            }
            
            let pVelocity = joystick.velocity;
            let speed = CGFloat(0.12)
            
            playerNode.position = CGPoint(x: playerNode.position.x + (pVelocity.x * speed), y: playerNode.position.y + (pVelocity.y * speed))
        }
        
        moveJoystick.on(.end) { [unowned self] _ in
            let actions = [
                SKAction.scale(to: 1.5, duration: 0.5),
                SKAction.scale(to: 1, duration: 0.5)
            ]
            
            self.playerNode?.run(SKAction.sequence(actions))
        }
        
        rotateJoystick.on(.move) { [unowned self] joystick in
            guard let playerNode = self.playerNode else {
                return
            }
            
            playerNode.zRotation = joystick.angular
        }
        
        rotateJoystick.on(.end) { [unowned self] _ in
            self.playerNode?.run(SKAction.rotate(byAngle: 3.6, duration: 0.5))
        }
        
        //MARK: Handlers end
        let selfHeight = frame.height
        let btnsOffset: CGFloat = 10
        let btnsOffsetHalf = btnsOffset / 2
        let joystickSizeLabel = SKLabelNode(text: "Joysticks Size:")
        joystickSizeLabel.fontSize = 20
        joystickSizeLabel.fontColor = UIColor.black
        joystickSizeLabel.horizontalAlignmentMode = .left
        joystickSizeLabel.verticalAlignmentMode = .top
        joystickSizeLabel.position = CGPoint(x: btnsOffset, y: selfHeight - btnsOffset)
        addChild(joystickSizeLabel)
        
        //joystickStickColorBtn.fontColor = UIColor.black
        //joystickStickColorBtn.fontSize = 20
        //joystickStickColorBtn.verticalAlignmentMode = .top
        //joystickStickColorBtn.horizontalAlignmentMode = .left
        //joystickStickColorBtn.position = CGPoint(x: btnsOffset, y: selfHeight - 40)
        //addChild(joystickStickColorBtn)
        
        //joystickSubstrateColorBtn.fontColor = UIColor.black
        //joystickSubstrateColorBtn.fontSize = 20
        //joystickSubstrateColorBtn.verticalAlignmentMode = .top
        //joystickSubstrateColorBtn.horizontalAlignmentMode = .left
        //joystickSubstrateColorBtn.position = CGPoint(x: btnsOffset, y: selfHeight - 65)
        //addChild(joystickSubstrateColorBtn)
        
        jSizeMinusSpriteNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        jSizeMinusSpriteNode.position = CGPoint(x: joystickSizeLabel.frame.maxX + btnsOffset, y: joystickSizeLabel.frame.midY)
        addChild(jSizeMinusSpriteNode)
        
        jSizePlusSpriteNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        jSizePlusSpriteNode.position = CGPoint(x: jSizeMinusSpriteNode.frame.maxX + btnsOffset, y: joystickSizeLabel.frame.midY)
        addChild(jSizePlusSpriteNode)
        
        let startLabelY = CGFloat(40)
        
        setJoystickStickImageBtn.fontColor = UIColor.black
        setJoystickStickImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .bottom
        setJoystickStickImageBtn.position = CGPoint(x: frame.midX, y: startLabelY - btnsOffsetHalf)
        addChild(setJoystickStickImageBtn)
        
        setJoystickSubstrateImageBtn.fontColor  = UIColor.black
        setJoystickSubstrateImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .top
        setJoystickSubstrateImageBtn.position = CGPoint(x: frame.midX, y: startLabelY + btnsOffsetHalf)
        addChild(setJoystickSubstrateImageBtn)
        joystickStickImageEnabled = true
        joystickSubstrateImageEnabled = true
        
        
        view.isMultipleTouchEnabled = true
        
        //Actual game
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0.0,dy: -5)
        
        parallaxComponentSystem = GKComponentSystem.init(componentClass: ParallaxComponent.self)
        platformComponentSystem = GKComponentSystem.init(componentClass: PlatformComponent.self)
        
        for entity in self.entities{
            parallaxComponentSystem?.addComponent(foundIn: entity)
            platformComponentSystem?.addComponent(foundIn: entity)
        }
        
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
        
        for component in (parallaxComponentSystem?.components)!{
            component.prepareWith(camera: camera)
        }
        for component in (platformComponentSystem?.components)!{
            component.setUpWithPlayer(playerNode: playerNode)
        }
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if let touch = touches.first {
            let node = atPoint(touch.location(in: self))
            
            switch node {
            case jSizePlusSpriteNode:
                moveJoystick.diameter += 10
                rotateJoystick.diameter += 10
            case jSizeMinusSpriteNode:
                moveJoystick.diameter -= 10
                rotateJoystick.diameter -= 10
            case setJoystickStickImageBtn:
                joystickStickImageEnabled = !joystickStickImageEnabled
            case setJoystickSubstrateImageBtn:
                joystickSubstrateImageEnabled = !joystickSubstrateImageEnabled
            //case joystickStickColorBtn:
            //    setRandomStickColor()
            //case joystickSubstrateColorBtn:
            //    setRandomSubstrateColor()
            default:
                playerNode?.setupPlayer();
            }
        }
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
    }
    
    
    
    //MARK: ============= Camera
    
    
    func centerOnNode(node: SKNode) {
        //let cameraPositionInScene: CGPoint = node.scene!.convert(node.position, from: node.parent!)
        self.camera!.run(SKAction.move(to: CGPoint(x:node.position.x , y:node.position.y), duration: 0.5))
    }
    
    override func didFinishUpdate() {
        //self.camera?.position = CGPoint(x: (thePlayer?.position.x)!, y: (thePlayer?.position.y)!)
        centerOnNode(node: playerNode!)
    }

    
    func setRandomStickColor() {
        let randomColor = UIColor.random()
        moveJoystick.handleColor = randomColor
        rotateJoystick.handleColor = randomColor
    }
    
    func setRandomSubstrateColor() {
        let randomColor = UIColor.random()
        moveJoystick.baseColor = randomColor
        rotateJoystick.baseColor = randomColor
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }

}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
