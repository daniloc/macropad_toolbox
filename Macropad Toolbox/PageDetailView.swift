//
//  PageDetailView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//

import SwiftUI

struct PageDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.undoManager) var undoManager
    
    @ObservedObject var page: Page
    @State var selectedKey: Key?
    @State var selectedRotaryMacro: Macro?
    @State var groupBoxLabel: String?
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
                        
                        PageInvocationEditView(page: page)
                        
                        Divider()
                        
                        HStack {
                            RotaryConfigView(encoder: page.rotary(for: .left), selectedMacro: $selectedRotaryMacro, activeEventString: $groupBoxLabel, label: "Left Rotary")
                            
                            Spacer()
                            
                            RotaryConfigView(encoder: page.rotary(for: .right), selectedMacro: $selectedRotaryMacro, activeEventString: $groupBoxLabel, label: "Right Rotary")
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 2)
                        
                        LazyVGrid(columns: items) {
                            
                            ReorderableForEach(items: keys) { key in
                                
                                KeyGridElementView(key: key, selectedKey: $selectedKey)
                                
                            } moveAction: { indices, index in
                                page.moveKeys(indices: indices, destination: index)
                            }
                        }

                    }
                    .frame(width: 260)
                    .padding()
                    
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
                .buttonStyle(.borderless)
                .padding(.vertical, 8)
                
                
                
                
            }
            
            if let key = selectedKey {
                GroupBox("Key details") {
                    
                    KeyDetailView(key: key)
                        .padding(.horizontal)

                    
                }
            }
            
            if let macro = selectedRotaryMacro, let groupBoxLabel = groupBoxLabel {
                GroupBox(groupBoxLabel) {
                    MacroEditView(macro: macro)
                        .padding(.horizontal)
                }
            }
            
            
            Spacer()
            
            
        }
        .padding()
        
        .onAppear {
            selectedKey = keys.first
            viewContext.undoManager = undoManager
        }
        .onChange(of: selectedKey) { _ in
            if selectedKey != nil {
                selectedRotaryMacro = nil
            }
        }
        .onChange(of: selectedRotaryMacro) { _ in
            if selectedRotaryMacro != nil {
                selectedKey = nil
            }
        }
        
        
    }
}



struct PageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PageDetailView(page: Page(context: PersistenceController.preview.container.viewContext))
    }
}
