//
//  Configuration+CoreDataClass.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//
//

import Foundation
import CoreData

@objc(Configuration)
public class Configuration: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        name = "New Configuration"
        
        let page = Page(context: self.managedObjectContext!)
        page.name = "New Page"
        
        addToPages(page)
    }
    
}
