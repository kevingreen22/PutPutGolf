//
//  SetupPlayerViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/29/23.
//

import SwiftUI
import Combine

struct NewPlayer: Hashable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var image: UIImage?
    var color: Color
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(image)
        hasher.combine(color)
    }
}


class SetupPlayerViewModel: ObservableObject {
    @AppStorage(AppStorageKeys.savedGames.description) var savedGames: [SavedGame]?

    @Published var newPlayers: [NewPlayer] = []
    @Published var profileImage: UIImage?
    @Published var playerName: String = ""
    @Published var pickedColor: Color = Color.random()

    @Published var textFieldDidSubmit: Bool = false
    @Published var showImageChooser: Bool = false
    @Published var showCurrentGameAlert: Bool = false
    
    var cancellables: Set<AnyCancellable> = []
    var savedGame: SavedGame?
    
    init() {
        print("\(type(of: self)).\(#function)")
        textFieldDidSubmitSubscriber()
        setupNewPlayerSubscriber()
    }
    
    func textFieldDidSubmitSubscriber() {
        $textFieldDidSubmit
            .sink { [weak self] didSubmit in
                guard let self = self else { return }
                
                // Checks that the user pressed "return" on keyboard, that they actually typed in a name, and if that name is already in the list of names.
                if didSubmit == true, playerName != "", !newPlayers.contains(where: { [weak self] player in
                    return player.name.lowercased() == self?.playerName.lowercased()
                }) {
                    // Initializes a NewPlayer object and appends it to the newPlayers property.
                    let newPlayer = NewPlayer(name: playerName, image: profileImage, color: self.pickedColor)
                    self.newPlayers.append(newPlayer)
                    
                    // Then clears the playerName binding and profileImage.
                    self.playerName = ""
                    self.profileImage = nil
                    self.pickedColor = Color.random()
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
    
    
    /// Creates an array of Player objects from an array of NewPlayer objects.
    func createPlayers(on course: Course) -> [Player] {
        var players: [Player] = []
        for player in newPlayers {
            players.append(Player(id: UUID().uuidString, name: player.name, image: player.image, color: player.color, course: course))
        }
        return players
    }
 
    
    func checkForCurrentGameOn(course: Course) {
        guard savedGames != nil else { return }
        for game in savedGames! {
            if !game.isCompleted && game.course == course {
                self.savedGame = game
                self.showCurrentGameAlert = true
                break
            }
        }
    }
    
}



