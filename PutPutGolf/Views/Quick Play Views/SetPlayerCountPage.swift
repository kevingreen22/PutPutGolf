//
//  SetPlayerCountPage.swift
//  PutPutGolf
//
//  Created by Kevin Green on 3/31/24.
//

import SwiftUI

struct SetPlayerCountPage: View {
    @Binding var numOfPlayers: Int?
    @FocusState.Binding var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            Text("How many Players?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.cellText)
                .shadow(radius: 2)
            
            TextField("", value: $numOfPlayers, format: .number)
                .font(.custom("ChalkboardSE-Regular", size: 80))
                .multilineTextAlignment(.center)
                .frame(width: 150, height: 200)
                .background(Color.cellBackground)
                .addBorder(Color.accentColor, lineWidth: 5, cornerRadius: 20)
                .focused($focusedField, equals: FocusedField.setPlayerCount)
                .submitLabel(.next)
                .keyboardType(.numbersAndPunctuation)
            Spacer()
        }.padding(.top)
    }
}

// MARK: Preview
#Preview {
    @State var numOfPlayers: Int? = 2
    @FocusState var focusedField: FocusedField?
    
    return ZStack {
        Image("golf_course").resizable().ignoresSafeArea()
        SetPlayerCountPage(numOfPlayers: $numOfPlayers, focusedField: $focusedField)
    }
}

