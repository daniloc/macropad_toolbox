//
//  JSONExportSupport.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//

import SwiftUI

//adapted via: https://www.donnywals.com/using-codable-with-core-data-and-nsmanagedobject/

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

enum ExportError: Error {
  case unableToCapturePages
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

extension Decoder {
    var managedObjectContext: NSManagedObjectContext? {
        return self.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext
    }
}
