//
//  SetupPlayerViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/29/23.
//

import SwiftUI
import Combine

class SetupPlayerViewModel: ObservableObject {
    @Published var playerName: String = ""
    @Published var profileImage: Image = Image(systemName: "person.fill")
    @Published var textFieldDidSubmit: Bool = false
    @Published var newPlayers: [NewPlayer] = []
    @FocusState var focusedTextField
    var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        focusedTextField = true
        setupTextFieldDidSubmitSubscriber()
    }
    
    func setupTextFieldDidSubmitSubscriber() {
        $textFieldDidSubmit
            .sink { [weak self] didSubmit in
                guard let self = self else { return }
                
                // Checks that the user pressed "return" on keyboard, that they actually typed in a name, and if that name is already in the list of names.
                if didSubmit == true, playerName != "", !newPlayers.contains(where: { [weak self] player in
                    return player.name == self?.playerName
                }) {
                    // Initializes a NewPlayer object and appends it to the newPlayers property.
                    let newPlayer = NewPlayer(name: playerName, image: profileImage)
                    self.newPlayers.append(newPlayer)
                    
                    // Then clears the playerName binding and profileImage.
                    self.playerName = ""
                    self.profileImage = Image(systemName: "person.fill")
                }
            }
            .store(in: &cancellables)
    }
    
    
    /// Triggers the TextFieldDidSubmit subscriber.
    /// This is a secondary subscriber used instead of the text field itself so the subscriber isn't run every time theres a new character added.
    func setupNewPlayerSubscriber() {
        $newPlayers
            .sink { [weak self] player in
                self?.textFieldDidSubmit = false
            }
            .store(in: &cancellables)
    }
        
}



struct NewPlayer: Hashable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var image: Image?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
