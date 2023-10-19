//
//  MockData.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation
import UIKit

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
    
    private init() {
        // creates holes for course
        let holes = [
            Hole(number: 1, par: 2, difficulty: .medium),
            Hole(number: 2, par: 3, difficulty: .hard),
            Hole(number: 3, par: 3, difficulty: .easy),
            Hole(number: 4, par: 4, difficulty: .easy),
            Hole(number: 5, par: 2, difficulty: .medium),
            Hole(number: 6, par: 3, difficulty: .medium),
            Hole(number: 7, par: 1, difficulty: .medium),
            Hole(number: 8, par: 3, difficulty: .hard),
            Hole(number: 9, par: 1, difficulty: .medium),
            Hole(number: 10, par: 4, difficulty: .medium),
            Hole(number: 11, par: 3, difficulty: .veryHard),
            Hole(number: 12, par: 2, difficulty: .medium),
            Hole(number: 13, par: 2, difficulty: .medium),
            Hole(number: 14, par: 2, difficulty: .easy),
            Hole(number: 15, par: 2, difficulty: .medium),
            Hole(number: 16, par: 2, difficulty: .easy),
            Hole(number: 17, par: 2, difficulty: .easy),
            Hole(number: 18, par: 1, difficulty: .medium),
            Hole(number: 19, par: 2, difficulty: .medium),
            Hole(number: 20, par: 2, difficulty: .hard),
            Hole(number: 21, par: 1, difficulty: .easy)
        ]
        
        // creates challenges for course
        let challenges = [
            Challenge(name: "Time Trial", rules: "there are the rules for time trials", difficulty: .easy),
            Challenge(name: "Closest To the Hole", rules: "there are the rules for time trials", difficulty: .medium),
            Challenge(name: "First In wins.", rules: "there are the rules for time trials", difficulty: .hard),
        ]
        
        // puts courses in to courses property array
        courses.append(contentsOf: [
            Course(
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
                    "*Hours are weather permitting. Rain, high heat or extreme cold may cause us to close. Please call ahead if you are unsure if we may not be open. \nGolfers welcome to begin playing up to 15 minutes before close"
                ]),
            Course(
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
                    "*Hours are weather permitting. Rain, high heat or extreme cold may cause us to close. Please call ahead if you are unsure if we may not be open. \nGolfers welcome to begin playing up to 15 minutes before close"
                ]),
            Course(
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
                    "*Hours are weather permitting. Rain, high heat or extreme cold may cause us to close. Please call ahead if you are unsure if we may not be open. \nGolfers welcome to begin playing up to 15 minutes before close"
                ]),
            Course(
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
                    "*Hours are weather permitting. Rain, high heat or extreme cold may cause us to close. Please call ahead if you are unsure if we may not be open. \nGolfers welcome to begin playing up to 15 minutes before close"
                ])
        ])
        
        // creates new players
        newPlayers = [
            NewPlayer(name: "Kevin", color: .random()),
            NewPlayer(name: "Nell", color: .random()),
            NewPlayer(name: "Holly", color: .random()),
            NewPlayer(name: "Whit", color: .random())
        ]
        
        // creates players
        players = [
            Player(name: "Kevin", course: courses.first!),
            Player(name: "Nell", course: courses.first!),
            Player(name: "Holly", course: courses.first!),
            Player(name: "Whitney", course: courses.first!)
        ]
        
        // creates player scores
        for player in players {
            for _ in 0..<Int.random(in: 0..<21) {
                player.scores.append(String(Int.random(in: 1...5)))
            }
            
            for _ in 0..<Int.random(in: 0..<3) {
                player.challengeScores.append(String(Int.random(in: 1...5)))
            }
        }
        
    }
}
