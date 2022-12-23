//
//  RotaryConfigView.swift
//  Macropad Toolbox
//
//  Created by Danilo Campos on 12/22/22.
//

import SwiftUI

struct RotaryConfigView: View {
    
    @State var activeEvent: RotaryEvent?
    @ObservedObject var encoder: RotaryEncoder
    @Binding var selectedMacro: Macro?
    @Binding var activeEventString: String?
    let label: String
    
    enum RotaryEvent: CaseIterable {
        case leftTurn,
             press,
             rightTurn
        
        func image() -> Image {
            switch self {
            case .leftTurn:
                return Image(systemName: "chevron.left")
            case .rightTurn:
                return Image(systemName: "chevron.right")
            case .press:
                return Image(systemName: "chevron.down")
            }
        }
        
        func labelText() -> Text {
            switch self {
            case .press:
                return Text("Press")
            default:
                return Text("Turn")
            }
        }
        
        func groupBoxString() -> String {
            switch self {
            case .leftTurn:
                return "Left Turn"
            case .rightTurn:
                return "Right Turn"
            case .press:
                return "Press"
            }
        }
    }
    
    func handleSelection(for event: RotaryEvent) {
        
        switch event {
        case .leftTurn:
            selectedMacro = encoder.leftTurn
        case .rightTurn:
            selectedMacro = encoder.rightTurn
        case .press:
            selectedMacro = encoder.press
        }
    }
    
    func label(for event: RotaryEvent) -> some View {
        return HStack {
            event.image()
            event.labelText()
        }
    }
    
    var body: some View {
        VStack {
            
            Text(label)
                .foregroundColor(.secondary)
            
            ForEach(RotaryEvent.allCases, id: \.self) { event in
                ZStack {
                    
                    if activeEvent == event {
                        Color.blue
                    } else {
                        Color.specialKeyBackground
                    }
                    
                    label(for: event)
                        .frame(width: 80, height: 50)
                    

                }
                .frame(height: 25)
                .clipped()
                .onTapGesture {
                    self.handleSelection(for: event)
                }

            }
        
            
        }
        .onChange(of: selectedMacro, perform: { macro in
            if macro == encoder.leftTurn {
                activeEvent = .leftTurn
            } else if macro == encoder.rightTurn {
                activeEvent = .rightTurn
            } else if macro == encoder.press {
                activeEvent = .press
            } else {
                activeEvent = nil
            }
            
            if let groupBoxString = activeEvent?.groupBoxString(){
                activeEventString = "\(groupBoxString), \(encoder.position.descriptionString())"
            }
            
        })
        .frame(width: 80)
    }
}

struct RotaryConfigView_Previews: PreviewProvider {
    static var previews: some View {
        RotaryConfigView(encoder: RotaryEncoder(context: PersistenceController.preview.container.viewContext), selectedMacro: .constant(nil), activeEventString: .constant(nil), label: "Left Encoder")
    }
}
