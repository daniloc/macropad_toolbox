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
             modifiers,
             consumerControls
    }
    
    enum SpecialKeyInput: Identifiable, Hashable {
        case modifier(AdafruitPythonHIDKeycode),
             consumerControl(AdafruitHIDPythonMediaControlCode)
        
        var id: String {
            switch self {
            case .modifier(let keycode):
                return "modifier:\(keycode.rawValue)"
            case .consumerControl(let controlCode):
                return "consumerControl:\(controlCode.rawValue)"
            }
        }
        
        var uiLabel: String {
            switch self {
            case .modifier(let keycode):
                return String("\(keycode)")
            case .consumerControl(let controlCode):
                return String("\(controlCode)")
            }
        }
    }
    
    var preview: String {
        
        let separator = " + "
        
        let modifierStrings: [String] = specialKeys.map { String("\($0.uiLabel)") }
        let modifierSequence = modifierStrings.joined(separator: separator)
        
        guard let textContent = textContent, textContent.count > 0 else {
            return modifierSequence
        }
        
        if modifierSequence.count > 0 {
            return modifierSequence + separator + textContent
        }
        
        if textContent.count > 0 {
            return textContent
        }
        
        return ""
        
    }
    
    var specialKeys: [SpecialKeyInput] {
        get {
            
            if modifiers == nil {
                self.modifiers = []
            }
            
            if consumerControls == nil {
                self.consumerControls = []
            }
            
            let selectedModifiers = modifiers!.compactMap { AdafruitPythonHIDKeycode(rawValue: $0)}
            let selectedConsumerControls = consumerControls!.compactMap { AdafruitHIDPythonMediaControlCode(rawValue: $0)}
            
            let wrappedModifiers = selectedModifiers.map { SpecialKeyInput.modifier($0) }
            let wrappedConsumercontrols = selectedConsumerControls.map { SpecialKeyInput.consumerControl($0)}
            
            return wrappedModifiers + wrappedConsumercontrols
        }
        
        set {
            
            var rawModifiers: [String] = []
            var rawConsumerControls: [String] = []
            
            newValue.forEach { keyInput in
                
                switch keyInput {
                case .modifier(let keycode):
                    rawModifiers.append(keycode.rawValue)
                case .consumerControl(let keycode):
                    rawConsumerControls.append(keycode.rawValue)
                }
            }
            
            self.modifiers = rawModifiers
            self.consumerControls = rawConsumerControls
            
            self.key?.page?.configuration?.logUpdate()
        }
    }
    
    func toggleKey(_ key: SpecialKeyInput) {
        
        if specialKeys.contains(key) {
            specialKeys.removeAll { $0 == key }
        } else {
            specialKeys.append(key)
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
        self.consumerControls = try container.decode([String].self, forKey: .consumerControls)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(textContent, forKey: .textContent)
        try container.encodeIfPresent(modifiers, forKey: .modifiers)
        try container.encodeIfPresent(consumerControls, forKey: .consumerControls)
    }
}
