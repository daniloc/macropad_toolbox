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
        Text(page.name ?? "")
    }
}

struct PageListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var configuration: Configuration
    
    @State var selectedPage: Page?
    
    var index: Int? {
        pages.firstIndex(where: { $0.objectID == selectedPage?.objectID })
    }
    
    var pages: [Page] {
        guard let pageSet = configuration.pages else {
            return []
        }
        
        return pageSet.array as! [Page]
    }
    
    var body: some View {
        List{
            ForEach(pages) { page in
                NavigationLink {
                    PageDetailView(page: page)
                        .onAppear {
                            selectedPage = page
                        }
                } label: {
                    PageListItem(page: page)
                }
            }
            .onDelete(perform: deleteItems)
        }
        
        //        .onMove { indices, destination in
        //            book.chapters.move(fromOffsets: indices,
        //                toOffset: destination)
        //        }
        .toolbar {
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
                
            }
            
            ToolbarItem {
                Button {
                    
                    do {
                        let data = try configuration.jsonData()

                        let saveURL = showSavePanel()
                        
                        write(json: data, to: saveURL)
                        
                    } catch {
                        print("Error generating json: \(error)")
                    }
                    
                    
                } label: {
                    Text("Export Config")
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
