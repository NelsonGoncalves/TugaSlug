//
//  PlayerComponent.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 29/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayerControlComponent: GKComponent, ControlInputSourceDelegate {
    
    
    var touchControlNode : TouchControlInputNode?
    
    func setupControls(camera : SKCameraNode, scene: SKScene) {
        
        touchControlNode = TouchControlInputNode(frame: scene.frame)
        touchControlNode?.inputDelegate = self
        touchControlNode?.position = CGPoint.zero
        
        camera.addChild(touchControlNode!)
    }
    
    func follow(command: String?) {
        if let moveComponent = entity?.component(ofType: ActionComponent.self){
            switch (command!){
            case ("left"):
                moveComponent.moveLeft()
            case ("right"):
                moveComponent.moveRight()
            case ("A"):
                moveComponent.jump()
            case ("down"):
                moveComponent.getDown()
            case ("stop down"):
                moveComponent.stopDown()
            case ("X"):
                moveComponent.beginRun()
            case "stop X","cancel X":
                moveComponent.stopRun()
            case "stop right","stop left","cancel right","cancel left":
                moveComponent.stopMoving()
            case ("B"):
                moveComponent.attack()
            default:
                print("otro boton \(String(describing: command))")
            }
        }
    }
    
}

