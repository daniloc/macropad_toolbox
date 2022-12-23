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
public class RotaryEncoder: NSManagedObject, Codable {
    
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
    
    //MARK: - Codable
    
    enum CodingKeys: CodingKey {
        case position,
        leftTurn,
        rightTurn,
        press
        
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.managedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
            
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.leftTurn = try container.decode(Macro.self, forKey: .leftTurn)
        self.rightTurn = try container.decode(Macro.self, forKey: .rightTurn)
        self.press = try container.decode(Macro.self, forKey: .press)
        
        let positionString = try container.decode(String.self, forKey: .position)
        
        if positionString == Position.left.descriptionString() {
            self.position = .left
        } else {
            self.position = .right
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
            
        try container.encode(position.descriptionString(), forKey: .position)
        
        try container.encode(leftTurn, forKey: .leftTurn)
        
        try container.encode(rightTurn, forKey: .rightTurn)
        
        try container.encode(press, forKey: .press)
    }
}
