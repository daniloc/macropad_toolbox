//
//  Macro+CoreDataClass.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//
//

import Foundation
import CoreData

enum Modifier: String, Codable {
    case command = "cmd",
    alt,
    control = "ctrl",
    shift
}

enum SpecialKeys: String, Codable {
    case returnKey = "return",
    enter,
    pageUp,
    pageDown,
    home,
    end
}

@objc(Macro)
public class Macro: NSManagedObject, Codable {

    
    //MARK: - Codable
    
    enum CodingKeys: CodingKey {
        case asciiContent,
        modifiers
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.managedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.asciiContent = try container.decode(String.self, forKey: .asciiContent)
        self.modifiers = try container.decode([String].self, forKey: .modifiers)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(asciiContent, forKey: .asciiContent)
        try container.encodeIfPresent(modifiers, forKey: .modifiers)
    }
}
