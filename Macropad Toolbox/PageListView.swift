//
//  PageListView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//

import SwiftUI

struct PageListItem: View {
    
    @ObservedObject var page: Page
    
    var body: some View {
        
        HStack {
            VStack {
                ForEach((0...page.invocation!.count - 1), id: \.self) { index in
                    
                    Group {
                        
                        if page.invocation![index] == 0 {
                            Image(systemName: "square")
                                .foregroundColor(.secondary)
                        } else {
                            Image(systemName: "square.fill")
                        }
                    }
                    .font(.system(size: 6))
                }
            }
            .frame(height: 20)
            
            Text(page.name ?? "")
        }
        .padding(.vertical, 2)
    }
}

struct PageListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var configuration: Configuration
    
    @State var selectedPage: Page?
    @State var confirmDeleteShown = false
    
    var pages: [Page] {
        guard let pageSet = configuration.pages else {
            return []
        }
        
        return pageSet.array as! [Page]
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 4) {
                
                TextField("Config Name", text: $configuration.name ?? "", prompt: Text("Config Name"))
                    .padding([.top, .horizontal])
                
                
                Button(action: {
                    confirmDeleteShown = true
                }) {
                    Label("Delete", systemImage: "trash")
                }
                .confirmationDialog("Are you sure you want to delete \(configuration.name ?? "")?", isPresented: $confirmDeleteShown, actions: {
                    
                    
                    Button("Delete \(configuration.name ?? "")", role: .destructive) {
                        configuration.delete()
                    }
                    Button("Cancel", role: .cancel) {
                        
                    }
                })
                .buttonStyle(.borderless)
                .padding()
                Divider()
                    .padding([.horizontal, .bottom])
                
                Text("Pages:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .bottom])
                    .foregroundColor(.secondary)
                
            }
            
            Divider()
            
            
            List{
                ForEach(pages) { page in
                    NavigationLink {
                        PageDetailView(page: page)
                            .onAppear {
                                selectedPage = page
                            }
                    } label: {
                        PageListItem(page: page)
                            .id(page.invocation)

                    }
                }
                .onDelete(perform: deleteItems)
                .onMove { indices, destination in
                    configuration.movePages(indices: indices, destination: destination)
                }
            }
            
            Divider()
            
            Button(action: addItem) {
                Label("Add Page", systemImage: "plus")
            }
            .buttonStyle(.borderless)
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            
            
        }
        
        .toolbar {
            
            
            ToolbarItem {
                Button {
                    
                    viewContext.attemptSaveLoggingErrors()
                    
                    do {
                        let data = try configuration.jsonData()
                        
                        let saveURL = showSavePanel()
                        
                        write(json: data, to: saveURL)
                        
                    } catch {
                        print("Error generating json: \(error)")
                    }
                    
                    
                } label: {
                    Text("Export \(configuration.name ?? "[Unnamed Configuration]")")
                }
            }
            
        }
    }
    
    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.json]
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save your Macropad configuration:"
        savePanel.nameFieldLabel = "File name:"
        savePanel.nameFieldStringValue = "macro.json"
        
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }
    
    func write(json: Data, to url: URL?) {
        guard let url = url else {
            return
        }
        
        
        do {
            try json.write(to: url)
        } catch {
            print("Error writing to file: \(error)")
        }
        
    }
    
    private func deleteConfig() {
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Page(context: viewContext)
            
            configuration.addToPages(newItem)
            configuration.objectWillChange.send()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { configuration.pages?[$0] as! NSManagedObject }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private struct SelectedPageKey: FocusedValueKey {
    typealias Value = Binding<Page>
}

extension FocusedValues {
    var selectedPage: Binding<Page>? {
        get { self[SelectedPageKey.self] }
        set { self[SelectedPageKey.self] = newValue }
    }
}

struct PageListView_Previews: PreviewProvider {
    static var previews: some View {
        PageListView(configuration: Configuration(context: PersistenceController.preview.container.viewContext))
    }
}
