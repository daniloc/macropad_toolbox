//
//  KeyGridElementView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//

import SwiftUI

struct KeyGridElementView: View {
    
    @ObservedObject var key: Key
    @Binding var selectedKey: Key?
    
    var borderColor: Color {
        if key == selectedKey {
            return .yellow
        } else {
            return .black
        }
    }
    
    var borderWidth: Double {
        if key == selectedKey {
            return 3
        } else {
            return 1
        }
    }
    
    var body: some View {
        
        ZStack {
            
            if key == selectedKey {
                Color.primary
                    .opacity(0.2)
                    .cornerRadius(4)
            }
        
        VStack {
            
            ZStack {
                key.color
                
                RadialGradient(colors: [.clear, .init(white: 0.5, opacity: 0.25)].reversed(), center: .center, startRadius: 1, endRadius: 25)
            }
            .frame(width: 60, height: 60)
            .border(.black, width: 1)
            .cornerRadius(8)
            
            
            if key.label?.count == 0 {
                Text("Blank")
                    .foregroundColor(.secondary)
            } else {
                Text(key.label ?? "")
            }
            
            
        }
        .padding(4)
        .onTapGesture {
            selectedKey = key
        }
        }
    }
}

struct KeyGridElementView_Previews: PreviewProvider {
    static var previews: some View {
        KeyGridElementView(key: Key(context: PersistenceController.previewObjectContext), selectedKey: .constant(nil))
    }
}
