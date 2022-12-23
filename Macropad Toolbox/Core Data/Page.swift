//
//  Page+CoreDataClass.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//
//

import Foundation
import CoreData

@objc(Page)
public class Page: NSManagedObject, Codable {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.name = "New Page"
        
        for _ in 1...12 {
            let key = Key(context: self.managedObjectContext!)
            
            self.addToKeys(key)
        }
    }
    
    //MARK: - Codable
    
    enum CodingKeys: CodingKey {
        case name,
        keys,
        invocation
    }
        
    func rotary(for position: RotaryEncoder.Position) -> RotaryEncoder {
                
        for storedEncoder in self.encoders?.allObjects as! [RotaryEncoder] {
            if storedEncoder.position == position {
                return storedEncoder
            }
        }
        
        let encoder = RotaryEncoder(context: self.managedObjectContext!)
        encoder.position = position
        
        self.addToEncoders(encoder)
        
        return encoder
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.managedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        let keysArray = try container.decode([Key].self, forKey: .keys)
        
        self.keys = NSOrderedSet(array: keysArray)
        
        self.invocation = try container.decode([Int].self, forKey: .invocation)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
            
        try container.encodeIfPresent(name, forKey: .name)
        
        try container.encodeIfPresent(invocation, forKey: .invocation)

        if let keysArray = keys?.array as? [Key] {
            try container.encode(keysArray, forKey: .keys)
        }
    }
    
    func moveKeys(indices: IndexSet, destination: Int) {
        var keysArray = keys?.array ?? []
        
        keysArray.move(fromOffsets: indices, toOffset: destination)
        
        self.keys = NSOrderedSet(array: keysArray)
        
        self.configuration?.logUpdate()
    }
    
}
