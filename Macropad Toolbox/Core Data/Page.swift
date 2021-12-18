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
public class Page: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.name = "New Page"
        
        for _ in 1...12 {
            let key = Key(context: self.managedObjectContext!)
            
            self.addToKeys(key)
        }
    }
}
