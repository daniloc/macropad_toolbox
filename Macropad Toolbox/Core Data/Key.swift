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
public class Key: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.color = Color(white: 1, opacity: 1)
        self.label = ""
        
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

}
