//
//  EnterScoreView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/20/23.
//

import SwiftUI

struct EnterScoreView: View {
    @State private var score: Int = 0
    var player: Player
    
    @FocusState private var focused: Bool
    
    var body: some View {
        HStack {
            TextField("", value: $score, formatter: NumberFormatter())
                .font(.largeTitle)
                .padding()
                .keyboardType(.numberPad)
                .focused($focused)
            
            Button("Done") {
                focused = false
            }.bold()
        }
        .padding()
        .onAppear {
            focused = true
        }
    }
}

struct EnterScoreView_Previews: PreviewProvider {
    static var previews: some View {
        EnterScoreView(player: Player(name: "Temp Player"))
    }
}
