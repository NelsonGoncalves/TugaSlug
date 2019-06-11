//
//  TouchControlInputNode.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 29/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import SpriteKit

class TouchControlInputNode : SKSpriteNode {
    
    var alphaUnpressed:CGFloat = 0.5
    var alphaPressed:CGFloat   = 0.9
    
    var pressedButtons = [SKSpriteNode]()
  
    //var joystick = TLAnalogJoystick(withDiameter: 100)
    
    let buttonA = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "button_A")))
    let buttonB = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "button_B")))
    let buttonX = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "button_X")))
    let buttonY = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "button_Y")))
    
    var inputDelegate : ControlInputSourceDelegate?
    
    init(frame: CGRect,camera: SKCameraNode) {
        
        
        super.init(texture: nil, color: UIColor.clear, size: frame.size)
        
        setupControls(size: frame.size)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupControls(size : CGSize) {
        
        joystickSetup()
        
        addButton(button: buttonX,
                  position: CGPoint(x: (size.width / 3 ), y: -size.height / 4 + 50),
                  name: "X",
                  scale: 0.40)
        addButton(button: buttonY,
                  position: CGPoint(x: (size.width / 3 ) - 50, y: -size.height / 4),
                  name: "Y",
                  scale: 0.40)
        addButton(button: buttonB,
                  position: CGPoint(x: (size.width / 3 ), y: -size.height / 4 - 50),
                  name: "B",
                  scale: 0.40)
        addButton(button: buttonA,
                  position: CGPoint(x: (size.width / 3 ) + 50, y: -size.height / 4),
                  name: "A",
                  scale: 0.40)

    }
    
    func addButton(button: SKSpriteNode, position: CGPoint, name: String, scale: CGFloat){
        button.position = position
        button.setScale(scale)
        button.name = name
        button.zPosition = 10
        button.alpha = alphaUnpressed
        self.addChild(button)
    }
    func joystickSetup(){
    
        let joystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: -(size.width/2), y: -size.height / 2, width: size.width/2, height: size.height/2))
        joystickHiddenArea.joystick = TLAnalogJoystick(withDiameter: 100)
        joystickHiddenArea.joystick?.isMoveable = true
        let randomColor = UIColor.random()
        joystickHiddenArea.joystick?.handleColor = randomColor
        joystickHiddenArea.joystick?.baseColor = randomColor
        joystickHiddenArea.name = "joystickHiddenArea"
        joystickHiddenArea.physicsBody = SKPhysicsBody(rectangleOf: joystickHiddenArea.accessibilityFrame.size)
      
        self.addChild(joystickHiddenArea)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            let location = t.location(in: parent!)
            // for all 4 buttons
            for button in [buttonA, buttonB, buttonX, buttonY] {
                // I cheangular: ck if they are already registered in the list
                if button.contains(location) && pressedButtons.index(of: button) == nil {
                    pressedButtons.append(button)
                    if ((inputDelegate) != nil){
                        inputDelegate?.follow(command: button.name!)
                    }
                }
                if pressedButtons.index(of: button) == nil {
                    button.alpha = alphaUnpressed
                }
                else {
                    button.alpha = alphaPressed
                }
            }
        }
        //MARK: Handlers begin
        (self.childNode(withName: "joystickHiddenArea")as! TLAnalogJoystickHiddenArea).joystick?.on(.begin) { [unowned self] joystick in
            //if ((self.inputDelegate) != nil){
            debugPrint(joystick.angular, "begin")
                self.inputDelegate?.getCommandFromAngular(angular: joystick.angular)
            //}
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            let location = t.location(in: parent!)
            let previousLocation = t.previousLocation(in: parent!)
            for button in [buttonA, buttonB, buttonX, buttonY] {
                // if I get off the button where my finger was before
                if button.contains(previousLocation)
                    && !button.contains(location) {
                    // I remove it from the list
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                        
                        if ((inputDelegate) != nil){
                            inputDelegate?.follow(command: "cancel \(String(describing: button.name!))")
                        }
                        
                    }
                }
                    // if I get on the button where I wasn't previously
                else if !button.contains(previousLocation)
                    && button.contains(location)
                    && pressedButtons.index(of: button) == nil {
                    // I add it to the list
                    pressedButtons.append(button)
                    if ((inputDelegate) != nil){
                        inputDelegate?.follow(command: button.name!)
                    }
                }
                if pressedButtons.index(of: button) == nil {
                    button.alpha = alphaUnpressed
                }
                else {
                    button.alpha = alphaPressed
                }
            }
            //MARK: Handlers begin
            ///joystick.on(.begin) { [unowned self] _ in
              //
            //}
            // movement
            (self.childNode(withName: "joystickHiddenArea")as! TLAnalogJoystickHiddenArea).joystick?.on(.move) { [unowned self] joystick in
                 //   if ((self.inputDelegate) != nil){
                debugPrint(joystick.angular,"move")
                    self.inputDelegate?.getCommandFromAngular(angular: joystick.angular)
                //}
            }
            
            //joystick.on(.end) { [unowned self] _ in
             //
            //}
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touchUp(touches: touches, withEvent: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touchUp(touches: touches, withEvent: event)
        
    }
    
    func touchUp(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for touch in touches! {
            let location = touch.location(in: parent!)
            let previousLocation = touch.previousLocation(in: parent!)
            for button in [buttonA, buttonB, buttonX, buttonY] {
                if button.contains(location) {
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                        if ((inputDelegate) != nil){
                            inputDelegate?.follow(command: "stop \(String(describing: button.name!))")
                        }
                    }
                }
                else if (button.contains(previousLocation)) {
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                        if ((inputDelegate) != nil){
                            inputDelegate?.follow(command: "stop \(String(describing: button.name!))")
                        }
                    }
                }
                if pressedButtons.index(of: button) == nil {
                    button.alpha = alphaUnpressed
                }
                else {
                    button.alpha = alphaPressed
                }
            }
        }
        //MARK: Handlers begin
        //joystick.on(.begin) { [unowned self] _ in
        //
        //}
        //
        // movement
        //joystick.on(.move) { [unowned self] joystick in
        //    if ((self.inputDelegate) != nil){
        //        self.inputDelegate?.getCommandFromAngular(angular: joystick.angular)
        //    }
        //}
        
        (self.childNode(withName: "joystickHiddenArea")as! TLAnalogJoystickHiddenArea).joystick?.on(.end) { [unowned self] joystick in
            debugPrint(joystick.angular ,"end")
            self.inputDelegate?.follow(command: "stop")
        }
        
    }
    
    
    
}



protocol ControlInputSourceDelegate : class {
    func getCommandFromAngular(angular : CGFloat)
    func follow(command : String?)
}

