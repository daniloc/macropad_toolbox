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
    
    var body: some View {
        
        HStack {
            
            GroupBox("Page Layout") {
                
                VStack {
                    
                    HStack {
                        Text("Title:")
                        TextField("Page title:", text: $page.name ?? "")
                    }
                    

                    
                    LazyVGrid(columns: items) {
                        
                        ReorderableForEach(items: keys) { key in
                            
                            KeyGridElementView(key: key, selectedKey: $selectedKey)
                            
                        } moveAction: { indices, index in
                            page.moveKeys(indices: indices, destination: index)
                        }
                    }
                    
                }
                
            }
            
            GroupBox("Key details") {
                if let key = selectedKey {
                    
                    KeyDetailView(key: key)
                }
                    
                    Spacer()
            
            }
        }
        .padding()

        .onAppear {
            selectedKey = keys.first
        }
        
            
    }
}



struct PageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PageDetailView(page: Page(context: PersistenceController.preview.container.viewContext))
    }
}
