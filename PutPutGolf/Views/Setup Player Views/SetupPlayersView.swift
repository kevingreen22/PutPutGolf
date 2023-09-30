//
//  SetupPlayersView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/29/23.
//

import SwiftUI

struct SetupPlayersView: View {
    @StateObject var vm = SetupPlayerViewModel()
    @State private var profileImage: Image = Image(systemName: "circle.fill")
    var navTag: Int = 1
    
    var body: some View {
        VStack {
            profileImage
                .resizable()
                .modifier(ProfileImageMod())
            
            TextField("Player \(vm.playerCount) Name", text: $vm.playerName)
                .focused(vm.$focusedTextField)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()
                .keyboardType(.namePhonePad)
                .submitLabel(.next)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("Add") {
                            // add player to list here
                            
                        }
                    }
                }
            
            Spacer()
            
        }
        .padding(.top)
        
        .navigationTitle("Setup Players")
        
        .onAppear {
            vm.focusedTextField = true
        }
    }
    
}

struct SetupPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        SetupPlayersView()
            .environmentObject(NavigationViewModel())
    }
}




struct ProfileImageMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.gray)
            .frame(width: 200, height: 200)
            .overlay(alignment: .bottom) {
                Button {
                    // choose profile photo here
                    
                } label: {
                    Text("Edit")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                }
                .background(alignment: .bottom) {
                    Color.black.opacity(0.3)
                        .frame(width: 200)
                }
            } // edit button
            .clipShape(Circle())
            .padding(3)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
            } // border
    }
}
