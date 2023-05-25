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
    
    func itemLabel(_ content: String) -> some View {
        Text(content)
            .font(.system(size: 11, design: .monospaced))
            .foregroundColor(.primary)
            .lineLimit(1)
            .padding(2)
    }
    
    fileprivate func modifierPickerItem(_ keycode: Macro.SpecialKeyInput) -> some View {
        return ZStack {
            
            if macro.specialKeys.contains(keycode) {
                Color.blue
            } else {
                Color.specialKeyBackground
            }
            
            itemLabel(keycode.uiLabel)

        }
        .onTapGesture {
            macro.toggleKey(keycode)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: items, spacing: 3) {
                
                Section("Media Keys") {
                    ForEach(AdafruitHIDPythonMediaControlCode.allCases) { keycode in
                        
                        modifierPickerItem(Macro.SpecialKeyInput.consumerControl(keycode))
                            .id(Macro.SpecialKeyInput.consumerControl(keycode).id)
                    }
                }
                
                Section("Modifier Keys") {
                    ForEach(AdafruitPythonHIDKeycode.allCases) { keycode in
                        
                        modifierPickerItem(Macro.SpecialKeyInput.modifier(keycode))
                            .id(Macro.SpecialKeyInput.modifier(keycode).id)
                        
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
