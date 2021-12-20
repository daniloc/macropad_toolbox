//
//  KeyDetailView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//

import SwiftUI

struct MacroEditView: View {
    @ObservedObject var macro: Macro
    
    var body: some View {
        TextField("Output", text: $macro.asciiContent ?? "", prompt: Text("Typed by this key"))
    }
}

struct KeyDetailView: View {
    
    @ObservedObject var key: Key
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Label", text: $key.label ?? "", prompt: Text("Key label"))
            
            ColorPicker("Color", selection: $key.color)
            
            if let macro = key.macro {
                MacroEditView(macro: macro)
            }
            

        }
    }
}

struct KeyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KeyDetailView(key: Key(context: PersistenceController.preview.container.viewContext))
    }
}
