//
//  SetPlayerNamesPage.swift
//  PutPutGolf
//
//  Created by Kevin Green on 3/31/24.
//

import SwiftUI

struct SetPlayerNamesPage: View {
    @Binding var numOfPlayers: Int?
    @Binding var playerName: String
    @FocusState.Binding var focusedField: FocusedField?
    
    @State private var playerNum = 1
    
    
    var body: some View {
        VStack {
            Text("Enter player \(playerNum)'s name")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.cellText)
                .shadow(radius: 2)
            
            TextField("", text: $playerName)
                .font(.custom("ChalkboardSE-Regular", size: 50))
                .multilineTextAlignment(.center)
                .frame(height: 100)
                .background(Color.cellBackground)
                .addBorder(Color.accentColor, lineWidth: 5, cornerRadius: 20)
                .focused($focusedField, equals: .playerName)
                .keyboardType(.default)
                .submitLabel(playerNum == numOfPlayers ? .go : .next)
                .padding(.horizontal)
            Spacer()
        }
        .onSubmit {
            if let num = numOfPlayers, playerNum < num  {
                playerNum += 1
            }
        }
        .onChange(of: numOfPlayers) { _ in
            if numOfPlayers == nil {
                playerNum = 1
            }
        }
        
    }
}

#Preview {
    @State var numOfPlayers: Int? = 2
    @State var playerName: String = ""
    @FocusState var focusedField: FocusedField?
    
    return ZStack {
        Image("golf_course").resizable().ignoresSafeArea()
        SetPlayerNamesPage(numOfPlayers: $numOfPlayers, playerName: $playerName, focusedField: $focusedField)
    }
}

