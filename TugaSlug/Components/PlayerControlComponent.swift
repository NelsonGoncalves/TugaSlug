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
    var currentScene : SKScene!
    var dir = CGVector(dx: 0, dy: 0)
    
    func setupControls(camera : SKCameraNode, scene: SKScene) {
        
        touchControlNode = TouchControlInputNode(frame: scene.frame,camera: camera)
        touchControlNode?.inputDelegate = self
        touchControlNode?.position = CGPoint.zero
        self.currentScene = scene
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
    func getDirectionFromAngle() -> CGVector{
        var dir = CGVector(dx: 0, dy: 0)
        if let angular = (touchControlNode?.childNode(withName: "joystickHiddenArea") as! TLAnalogJoystickHiddenArea).joystick?.angular {
            
            switch angular {
            case (-2.0)...(-1.0):
                // right
                dir = CGVector(dx: 1, dy: 0)
            case (-1.0)...(1.0):
                // up
                dir = CGVector(dx: 0, dy: 1)
            case (1.0)...(2.0):
                // left
                dir = CGVector(dx: -1, dy: 0)
            case (2.0)...(3.0),(-3.0)...(-2.0):
                // down
                dir = CGVector(dx: 0, dy: -1)
            default:
                dir = CGVector(dx: 0, dy: 0)
            }
        }
        print(dir)
        return dir
    }
    func follow(command: String?) {
        print(command as Any)
        if let moveComponent = entity?.component(ofType: ActionComponent.self){
            switch (command!){
            case ("left"):
                dir = getDirectionFromAngle()
                moveComponent.moveLeft()
            case ("right"):
                dir = getDirectionFromAngle()
                moveComponent.moveRight()
            case ("A"):
                moveComponent.jump()
            case ("down"):
                moveComponent.getDown()
            case ("stop down"):
                moveComponent.stopDown()
            case ("X"):
                moveComponent.slide()
            case "stop X","cancel X":
                moveComponent.stopSlide()
            case "stop","cancel":
                dir = getDirectionFromAngle()
                moveComponent.stopMoving()
            case ("B"):
                moveComponent.shoot(direction: dir)
            case "stop B":
                moveComponent.stopShooting()
            default:
                print("otro boton \(String(describing: command))")
            }
        }
    }
}

