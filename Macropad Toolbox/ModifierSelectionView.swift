//
//  ModifierSelectionView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/20/21.
//

import SwiftUI

struct ModifierSelectionView: View {
    
    @ObservedObject var macro: Macro
    
    var items: [GridItem] {
        Array(repeating: .init(.fixed(90), spacing: 3), count: 4)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: items, spacing: 3) {
                ForEach(AdafruitPythonHIDKeycode.allCases) { keycode in
                    
                    ZStack {
                        
                        if macro.specialKeys.contains(keycode) {
                            Color.blue
                        } else {
                            Color.specialKeyBackground
                        }
                        
                        Text(String("\(keycode)"))
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .padding(2)
                    }
                    .onTapGesture {
                        macro.toggleKey(keycode)
                    }
                    
                }
            }
        }
    }
}

struct ModifierSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ModifierSelectionView(macro: Macro(context: PersistenceController.previewObjectContext))
    }
}
