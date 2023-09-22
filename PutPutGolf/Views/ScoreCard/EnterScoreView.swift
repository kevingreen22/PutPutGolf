//
//  EnterScoreView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/20/23.
//

import SwiftUI

struct EnterScoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var score: String = ""
    var player: Player
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                TextField("", text: $score)
                    .font(.largeTitle)
                    .padding()
                    .keyboardType(.numberPad)
                    .focused($focused)
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title)
                }
                
            }.padding()
            
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Add")
                    .font(.title)
                    .fontWeight(.medium)
                    .frame(minWidth: 200, idealWidth: 300)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.capsule)
        }
        
        .onAppear {
            focused = true
        }
    }
}

struct EnterScoreView_Previews: PreviewProvider {
    static var previews: some View {
        EnterScoreView(player: Player(name: "Temp Player", course: MockData.shared.courses.first!))
    }
}
