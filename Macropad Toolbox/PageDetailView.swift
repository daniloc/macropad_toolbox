//
//  PageDetailView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//

import SwiftUI

struct PageDetailView: View {
    
    @ObservedObject var page: Page
    @State var selectedKey: Key?
    
    var keys: [Key] {
        guard let keySet = page.keys else {
            return []
        }
        
        return keySet.array as! [Key]
    }
    
    var items: [GridItem] {
        Array(repeating: .init(.fixed(80)), count: 3)
    }
    
    func borderColorForKey(_ key: Key) -> Color {
        if key == selectedKey {
            return .yellow
        } else {
            return .black
        }
    }
    
    func borderWidthForKey(_ key: Key) -> Double {
        if key == selectedKey {
            return 3
        } else {
            return 1
        }
    }

    func keyView(_ key: Key) -> some View {
        ZStack {
            key.color
            
            RadialGradient(colors: [.clear, .init(white: 0.5, opacity: 0.5)].reversed(), center: .center, startRadius: 1, endRadius: 25)
            
            VStack {
                if key.label?.count == 0 {
                    Text("Blank")
                        .foregroundColor(.secondary)
                }
                
            }
        }
        .border(borderColorForKey(key), width: borderWidthForKey(key))
        .frame(width: 80, height: 80)
        .onTapGesture {
            selectedKey = key
        }
    }
    
    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: items) {
                
                ForEach(keys) { key in
                    
                    keyView(key)
                    
                }                
            }
        }
    }
}

struct PageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PageDetailView(page: Page(context: PersistenceController.preview.container.viewContext))
    }
}
