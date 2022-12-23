//
//  InvocationSelectionView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/22/22.
//

import SwiftUI

struct PageInvocationEditView: View {
    
    @ObservedObject var page: Page
    
    
    var body: some View {
        HStack {
            Text("Activation:")
            Spacer()
            
            VStack(spacing: 2) {
                ForEach((0...page.invocation!.count - 1), id: \.self) { index in
                    Button {
                        
                        if page.invocation![index] == 1 {
                            page.invocation![index] = 0
                        } else {
                            page.invocation![index] = 1
                        }
                        
                        page.pendingInvocationChange()
                        
                    } label: {
                        Group {
                            if page.invocation![index] == 0 {
                                Image(systemName: "square")
                            } else {
                                Image(systemName: "square.fill")
                            }
                        }
                        .font(.system(size: 16))

                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}

struct InvocationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PageInvocationEditView(page: Page(context: PersistenceController.preview.container.viewContext))
    }
}
