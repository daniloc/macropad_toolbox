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
        keys
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
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
            
        try container.encodeIfPresent(name, forKey: .name)

        if let keysArray = keys?.array as? [Key] {
            try container.encode(keysArray, forKey: .keys)
        }
    }
    
    func moveKeys(indices: IndexSet, destination: Int) {
        var keysArray = keys?.array ?? []
        
        keysArray.move(fromOffsets: indices, toOffset: destination)
        
        self.keys = NSOrderedSet(array: keysArray)
    }
    
}
