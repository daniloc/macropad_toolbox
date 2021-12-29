//
//  Macro+CoreDataClass.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//
//

import Foundation
import CoreData

@objc(Macro)
public class Macro: NSManagedObject, Codable {

    
    //MARK: - Codable
    
    enum CodingKeys: CodingKey {
        case textContent,
        modifiers
    }
    
    var preview: String {
                
        let separator = " + "
                
        let modifierStrings: [String] = specialKeys.map { String("\($0)") }
        let modifierSequence = modifierStrings.joined(separator: separator)
                
        guard let textContent = textContent, textContent.count > 0 else {
            return modifierSequence
        }

        if modifierSequence.count > 0 {
            return modifierSequence + separator + textContent
        }
        
        return ""
        
    }
    
    var specialKeys: [AdafruitPythonHIDKeycode] {
        get {
            
            guard let modifiers = modifiers else { return [] }
            
            return modifiers.compactMap { AdafruitPythonHIDKeycode(rawValue: $0) }
            
        }
        
        set {
            
            modifiers = newValue.map { $0.rawValue }
            
            self.key?.page?.configuration?.logUpdate()
        }
    }
    
    func toggleKey(_ key: AdafruitPythonHIDKeycode) {
        
        if specialKeys.contains(key) {
            specialKeys.removeAll { $0 == key }
        } else {
            specialKeys.insert(key, at: 0)
        }
        
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.managedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
                    
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.textContent = try container.decode(String.self, forKey: .textContent)
        self.modifiers = try container.decode([String].self, forKey: .modifiers)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(textContent, forKey: .textContent)
        try container.encodeIfPresent(modifiers, forKey: .modifiers)
    }
}
