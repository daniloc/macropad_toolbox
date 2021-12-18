//
//  ContentView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/18/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Configuration.modificationDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Configuration>

    var body: some View {
        NavigationView {

            ConfigurationListView()
            
            Text("Select a configuration")
            
            Text("Select a page")
        }
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
