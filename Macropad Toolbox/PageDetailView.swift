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
    @State var confirmDeleteShown = false
    
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
            
            VStack {
            
            GroupBox("Page Detail") {
                
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
                Spacer()
                
                Button {
                    confirmDeleteShown = true
                } label: {
                    Label("Delete \(page.name ?? "Unnamed Page")", systemImage: "trash")
                }
                .confirmationDialog("Are you sure you want to delete \(page.name ?? "")?", isPresented: $confirmDeleteShown, actions: {

                    
                    Button("Delete \(page.name ?? "")", role: .destructive) {
                        page.configuration?.deletePage(page)
                    }
                    Button("Cancel", role: .cancel) {

                    }
                })
                .padding(.vertical, 8)
            
                

                
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
