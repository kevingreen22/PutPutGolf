//
//  MockData.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation
import SwiftUI

protocol MockDataProtocol {
    var courses: [Course] { get }
    var players: [Player] { get }
    var newPlayers: [NewPlayer] { get }
}

public class MockData: MockDataProtocol {
    
    static let instance: MockData = MockData()
    
    var courses: [Course] = []
    
    var players: [Player] = []
    
    var newPlayers: [NewPlayer] = []
    
    var quickPlayers: [QuickPlayer] = []
    
    private init() {
        // creates Holes for course
        let holes = [
            Hole(id: UUID().uuidString, number: 1, par: 2, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 2, par: 3, difficulty: .hard),
            Hole(id: UUID().uuidString, number: 3, par: 3, difficulty: .easy),
            Hole(id: UUID().uuidString, number: 4, par: 4, difficulty: .easy),
            Hole(id: UUID().uuidString, number: 5, par: 2, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 6, par: 3, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 7, par: 1, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 8, par: 3, difficulty: .hard),
            Hole(id: UUID().uuidString, number: 9, par: 1, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 10, par: 4, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 11, par: 3, difficulty: .veryHard),
            Hole(id: UUID().uuidString, number: 12, par: 2, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 13, par: 2, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 14, par: 2, difficulty: .easy),
            Hole(id: UUID().uuidString, number: 15, par: 2, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 16, par: 2, difficulty: .easy),
            Hole(id: UUID().uuidString, number: 17, par: 2, difficulty: .easy),
            Hole(id: UUID().uuidString, number: 18, par: 1, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 19, par: 2, difficulty: .medium),
            Hole(id: UUID().uuidString, number: 20, par: 2, difficulty: .hard),
            Hole(id: UUID().uuidString, number: 21, par: 1, difficulty: .easy)
        ]
        
        // creates Challenges for course
        let challenges = [
            Challenge(id: UUID().uuidString, name: "Time Trial", rules: "These are the rules for time trials", difficulty: .easy),
            Challenge(id: UUID().uuidString, name: "Closest To the Hole", rules: "These are the rules for time trials", difficulty: .medium),
            Challenge(id: UUID().uuidString, name: "First In wins.", rules: "These are the rules for time trials", difficulty: .hard),
        ]
        
        // puts courses into courses property array
        courses.append(contentsOf: [
            Course(
                id: UUID().uuidString,
                name: "Goat Track Country Club",
                address: "Walnut Creek, Ca",
                latitude: 37.9101,
                longitude: -122.0652,
                imageData: UIImage(named: "walnut_creek")?.jpegData(compressionQuality: 1)!,
                difficulty: .medium,
                holes: holes,
                challenges: challenges,
                rules: [
                    "This area and activity can be dangerous and poses risk of injury; we do not provide supervision. By entering you acknowledge and argree that you assume all risks on behalf of your party.",
                    "Never rais the club abouve your knees; no wild swinging.",
                    "Watch your step; the playing field is uneven.",
                    "Do not stand on railings. No climbing.",
                    "Do not try to retrieve lost balls; please ask for a replacement.",
                    "You will be responsible for any damage caused by malicious swinging or throwing of the club or ball.",
                    "We will deny entrance or expel people who are drunk, unruly,m and/or do damage with no refunds.",
                    "Players Assume All Risks."
                ],
                hours: [
                    "Monday: Closed",
                    "Tuesday: Closed",
                    "Wednesday: Closed",
                    "Thursday: 3pm - 7pm",
                    "Friday: 3pm - 8pm",
                    "Saturday: 12:30pm - 7:30pm",
                    "Sunday: 11:30am - 6pm",
                    "Other Info: *Hours are weather permitting. Rain, high heat or extreme cold may cause us to close. Please call ahead if you are unsure if we may not be open. \nGolfers welcome to begin playing up to 15 minutes before close."
                ]),
            Course(
                id: UUID().uuidString,
                name: "Cow Track Country Club",
                address: "Martinez, Ca",
                latitude: 38.0194,
                longitude: -122.1341,
                imageData: UIImage(named: "martinez")?.jpegData(compressionQuality: 1)!,
                difficulty: .easy,
                holes: holes,
                challenges: challenges,
                rules: [
                    "This area and activity can be dangerous and poses risk of injury; we do not provide supervision. By entering you acknowledge and argree that you assume all risks on behalf of your party.",
                    "Never rais the club abouve your knees; no wild swinging.",
                    "Watch your step; the playing field is uneven.",
                    "Do not stand on railings. No climbing.",
                    "Do not try to retrieve lost balls; please ask for a replacement.",
                    "You will be responsible for any damage caused by malicious swinging or throwing of the club or ball.",
                    "We will deny entrance or expel people who are drunk, unruly,m and/or do damage with no refunds.",
                    "Players Assume All Risks."
                ],
                hours: [
                    "Monday: Closed",
                    "Tuesday: Closed",
                    "Wednesday: Closed",
                    "Thursday: 3pm - 7pm",
                    "Friday: 3pm - 8pm",
                    "Saturday: 12:30pm - 7:30pm",
                    "Sunday: 11:30am - 6pm",
                    "Other Info: *Hours are weather permitting. Rain, high heat or extreme cold may cause us to close. Please call ahead if you are unsure if we may not be open. \nGolfers welcome to begin playing up to 15 minutes before close."
                ]),
            Course(
                id: UUID().uuidString,
                name: "Pig Track Country Club",
                address: "Alameda, Ca",
                latitude: 37.7799,
                longitude: -122.2822,
                imageData: UIImage(named: "alameda")?.jpegData(compressionQuality: 1)!,
                difficulty: .hard,
                holes: holes,
                challenges: challenges,
                rules: [
                    "This area and activity can be dangerous and poses risk of injury; we do not provide supervision. By entering you acknowledge and argree that you assume all risks on behalf of your party.",
                    "Never rais the club abouve your knees; no wild swinging.",
                    "Watch your step; the playing field is uneven.",
                    "Do not stand on railings. No climbing.",
                    "Do not try to retrieve lost balls; please ask for a replacement.",
                    "You will be responsible for any damage caused by malicious swinging or throwing of the club or ball.",
                    "We will deny entrance or expel people who are drunk, unruly,m and/or do damage with no refunds.",
                    "Players Assume All Risks."
                ],
                hours: [
                    "Monday: Closed",
                    "Tuesday: Closed",
                    "Wednesday: Closed",
                    "Thursday: 3pm - 7pm",
                    "Friday: 3pm - 8pm",
                    "Saturday: 12:30pm - 7:30pm",
                    "Sunday: 11:30am - 6pm",
                    "Other Info: *Hours are weather permitting. Rain, high heat or extreme cold may cause us to close. Please call ahead if you are unsure if we may not be open. \nGolfers welcome to begin playing up to 15 minutes before close."
                ]),
            Course(
                id: UUID().uuidString,
                name: "Sheep Track Country Club",
                address: "Palo Alto, Ca",
                latitude: 37.4419,
                longitude: -122.1430,
                imageData: UIImage(named: "palo_alto")?.jpegData(compressionQuality: 1),
                difficulty: .easy,
                holes: holes,
                challenges: challenges,
                rules: [
                    "This area and activity can be dangerous and poses risk of injury; we do not provide supervision. By entering you acknowledge and argree that you assume all risks on behalf of your party.",
                    "Never rais the club abouve your knees; no wild swinging.",
                    "Watch your step; the playing field is uneven.",
                    "Do not stand on railings. No climbing.",
                    "Do not try to retrieve lost balls; please ask for a replacement.",
                    "You will be responsible for any damage caused by malicious swinging or throwing of the club or ball.",
                    "We will deny entrance or expel people who are drunk, unruly,m and/or do damage with no refunds.",
                    "Players Assume All Risks."
                ],
                hours: [
                    "Monday: Closed",
                    "Tuesday: Closed",
                    "Wednesday: Closed",
                    "Thursday: 3pm - 7pm",
                    "Friday: 3pm - 8pm",
                    "Saturday: 12:30pm - 7:30pm",
                    "Sunday: 11:30am - 6pm",
                    "Other Info: *Hours are weather permitting. Rain, high heat or extreme cold may cause us to close. Please call ahead if you are unsure if we may not be open.\nGolfers welcome to begin playing up to 15 minutes before close."
                ])
        ])
        
        // creates NewPlayers
        newPlayers = [
            NewPlayer(name: "Kevin", color: .random()),
            NewPlayer(name: "Nell", color: .random()),
            NewPlayer(name: "Holly", color: .random()),
            NewPlayer(name: "Whit", color: .random())
        ]
        
        // creates Players
        players = [
            Player(id: UUID().uuidString, name: "Kevin", course: courses.first!),
            Player(id: UUID().uuidString, name: "Nell", course: courses.first!),
            Player(id: UUID().uuidString, name: "Holly", course: courses.first!),
            Player(id: UUID().uuidString, name: "Whitney", course: courses.first!)
        ]
        
        // creates player scores
        for player in players {
            player.color = Color.random()
            
            for i in 0..<21 {
                let randInt = Int.random(in: 1...5)
                player.scores[i] = String(randInt)
            }
            
            for i in 0..<3 {
                let randInt = Int.random(in: 1...5)
                player.challengeScores[i] = String(randInt)
            }
        }
        
        
        // creates QuickPlayers
        quickPlayers = [
            QuickPlayer(name: "Kevin"),
            QuickPlayer(name: "Nell"),
            QuickPlayer(name: "Holly"),
            QuickPlayer(name: "Whitney")
        ]
        
        for player in quickPlayers {
            player.scores = Array(repeating: "", count: 1)
        }
        
        //        print("MockData_players.scores: \(players.first!.scores)")
        //        print("MockData_players.challengeScores: \(players.first!.challengeScores)")
        
    }
    
}
