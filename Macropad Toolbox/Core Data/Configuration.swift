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
    
    func claim(invocation: [Int], page: Page) {
        for page in self.pages?.array as! [Page] {
            if page.invocation == invocation {
                page.clearInvocation()
            }
        }
        
        page.invocation = invocation
        self.objectWillChange.send()
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
        
        logUpdate()
    }
    
    func deletePage(_ page: Page) {
        
        guard let context = self.managedObjectContext else { return }
        
        page.configuration = nil
        
        context.delete(page)
        context.attemptSaveLoggingErrors()
        
        logUpdate()
    }
    
    func delete() {
        guard let context = self.managedObjectContext else { return }
        
        context.delete(self)
        context.attemptSaveLoggingErrors()
    }
    
    func logUpdate() {
        self.modificationDate = Date()
        self.managedObjectContext?.attemptSaveLoggingErrors()
    }
    
}
