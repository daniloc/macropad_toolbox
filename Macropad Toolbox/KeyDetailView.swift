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
        
        VStack(alignment: .leading) {
            
            if macro.preview.count == 0 {
                Text("[No output]")
                    .foregroundColor(.secondary)
            } else {
                Text(macro.preview)
                    .foregroundColor(.secondary)
            }
            
            
        
            HStack {
            Text("Text output:")
        TextField("Output", text: $macro.textContent ?? "", prompt: Text("Text typed by this key"))
                
            }
            
            Text("Special keys:")
            
            ModifierSelectionView(macro: macro)
            
        }
    }
}

struct KeyDetailView: View {
    
    @ObservedObject var key: Key
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
            
            TextField("Label", text: $key.label ?? "", prompt: Text("Key label"))
                
                Spacer()
                
                Button {
                    key.reset()
                } label: {
                    Label("Reset", systemImage: "clear")
                }
                .padding(8)

            
            }
                
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
