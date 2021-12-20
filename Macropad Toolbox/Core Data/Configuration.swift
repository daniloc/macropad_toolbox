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
    
    func jsonData() throws -> Data {
        
        guard let pages = pages?.array as? [Page] else {
            throw ExportError.unableToCapturePages
        }
        
        let data = try JSONEncoder().encode(pages)
        
        return data
        
    }
    
    func movePages(indices: IndexSet, destination: Int) {
        
        var pagesArray = pages?.array ?? []
        
        pagesArray.move(fromOffsets: indices, toOffset: destination)
        
        self.pages = NSOrderedSet(array: pagesArray)
                
    }
    
}
