//
//  MainMenuScene.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import SpriteKit

class MainMenuScene : SKScene {
    var gameViewController : GameViewController?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (gameViewController != nil){
            gameViewController?.startGame()
        }
    }
    
}
