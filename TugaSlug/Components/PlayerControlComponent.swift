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
        
        touchControlNode = TouchControlInputNode(frame: scene.frame,camera: camera)
        touchControlNode?.inputDelegate = self
        touchControlNode?.position = CGPoint.zero
        
        camera.addChild(touchControlNode!)
    }
    func getCommandFromAngular(angular: CGFloat) {
        //switch angular {
        //case (-1.0)...(-2.0):
        //    follow(command: "right")
        //case (-1.0)...(1.0):
        //    follow(command: "up")
        //case (1.0)...(2.0):
        //    follow(command: "left")
        //case (2.0)...(3.0),(-2.0)...(-3.0):
        //    follow(command: "down")
        //default:
        //    follow(command: "other")
        //}
        if(angular > -2.0 && angular < -1.0){
            follow(command: "right")
            
        }
        else
        if(angular > -1.0 && angular < 1.0){
            follow(command: "up")
        }
        else
        if(angular > 1.0 && angular < 2.0){
            follow(command: "left")
        }
        else
        if(angular > 2.0 && angular < 3.0 || angular > -3.0 && angular < -2.0){
            follow(command: "down")
        }
    }
    func getAngleForShooting(angular: CGFloat){
        switch angular {
        case (-1.0)...(-2.0):
            follow(command: "right")
        case (-1.0)...(1.0):
            follow(command: "up")
        case (1.0)...(2.0):
            follow(command: "left")
        case (2.0)...(3.0),(-3.0)...(-2.0):
            follow(command: "down")
        default:
            follow(command: "other")
        }
    }
    func follow(command: String?) {
        print(command as Any)
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
            case "stop","cancel":
                moveComponent.stopMoving()
            case ("B"):
                moveComponent.shoot()
            default:
                print("otro boton \(String(describing: command))")
            }
        }
    }
    
}

