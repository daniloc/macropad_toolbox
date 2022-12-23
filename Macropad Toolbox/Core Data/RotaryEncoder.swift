//
//  RotaryEncoder+CoreDataClass.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/22/22.
//
//

import Foundation
import CoreData

@objc(RotaryEncoder)
public class RotaryEncoder: NSManagedObject {
    
    enum Position: Int16 {
        case left,
             right
        
        func descriptionString() -> String {
            switch self {
            case .left:
                return "Left Rotary"
            case .right:
                return "Right Rotary"
                
            }
        }
    }
    
    var position: Position {
        get {
            return Position(rawValue: positionInt)!
        }
        
        set {
            positionInt = newValue.rawValue
        }
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.leftTurn = Macro(context: self.managedObjectContext!)
        self.rightTurn = Macro(context: self.managedObjectContext!)
        self.press = Macro(context: self.managedObjectContext!)
    }
    
}
