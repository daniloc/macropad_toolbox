//
//  PageListView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//

import SwiftUI

struct PageListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var configuration: Configuration
    
    var pages: [Page] {
        guard let pageSet = configuration.pages else {
            return []
        }
        
        return pageSet.array as! [Page]
    }
    
    var body: some View {
        List {
            ForEach(pages) { page in
                NavigationLink {
                    PageDetailView(page: page)
                } label: {
                    Text(page.name ?? "")
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

struct PageListView_Previews: PreviewProvider {
    static var previews: some View {
        PageListView(configuration: Configuration(context: PersistenceController.preview.container.viewContext))
    }
}
