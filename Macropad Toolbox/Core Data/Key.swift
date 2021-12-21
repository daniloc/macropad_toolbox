//
//  Key+CoreDataClass.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//
//

import SwiftUI
import CoreData

@objc(Key)
public class Key: NSManagedObject, Codable {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.color = Color(white: 0.0, opacity: 1)
        self.label = ""
        
        self.macro = Macro(context: self.managedObjectContext!)
        
        self.macro?.textContent = " "
        
    }
    
    var color: Color {
        get {
            return Color(hex: self.colorHex ?? "000000")
        }
        
        set {
            
            self.colorHex = newValue.toHex
            self.objectWillChange.send()
        }
    }
    
    //MARK: - Codable

    enum CodingKeys: CodingKey {
        case color,
        label,
        macro
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.managedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.colorHex = try container.decode(String.self, forKey: .color)
        
        self.label = try container.decode(String.self, forKey: .label)
        
        self.macro = try container.decode(Macro.self, forKey: .macro)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        guard let rawColor = color.cgColor, let convertedColor = NSColor(cgColor: rawColor) else {
            return
        }
        
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0
        
        convertedColor.getHue(&h, saturation: &s, brightness: &b, alpha: nil)

        let cappedBrightness = min(b, 0.25)

        
        let adjustedColor = Color(hue: h, saturation: s, brightness: cappedBrightness)

        if let hex = adjustedColor.toHex {
            try container.encode(hex, forKey: .color)
        }
        
        try container.encodeIfPresent(label, forKey: .label)
        
        try container.encodeIfPresent(macro, forKey: .macro)
    }
}
