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
                                .border(Color.black, width: 1)
                        } else {
                            Color.specialKeyBackground
                                .border(Color.black, width: 1)
                        }
                        
                        Text(String("\(keycode)"))
                            .foregroundColor(.primary)
                            .font(.system(size: 12))
                            .lineLimit(1)
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
