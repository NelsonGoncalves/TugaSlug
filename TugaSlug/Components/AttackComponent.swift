//
//  AttackComponent.swift
//  TugaSlug
//
//  Created by Nelson Gonçalves on 28/05/2019.
//  Copyright © 2019 NelsonTiago. All rights reserved.
//

import GameplayKit

class AttackComponent : GKComponent {

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
    
}

