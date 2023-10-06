//
//  ScoreCardView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

struct ScoreCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: ScoreCardViewModel
    var course: Course
    var players: [Player]
    
    init(course: Course, players: [Player], isResumingGame resuming: Bool = false) {
        _vm = StateObject(wrappedValue: ScoreCardViewModel(course: course, players: players, isResumingGame: resuming))
        self.course = course
        self.players = players
    }
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollView(.vertical, showsIndicators: false) {
                Grid(horizontalSpacing: -1, verticalSpacing: -1) {
                    
                    // Hole-num row
                    GridRow {
                        // Header cell
                        StandardTextCell(title: "Hole", color: .green, textColor: .white)
                            .border(Color.black)
                        
                        // Hole number
                        ForEach(course.holes) { hole in
                            StandardTextCell(title: "\(hole.number)", color: .green, textColor: .white)
                                .border(Color.black)
                        }
                        
                        // TOT footer
                        StandardTextCell(title: "TOT", color: .green, textColor: .white)
                            .border(Color.black)
                        
                        // Challenges desc.
                        ForEach(course.challenges) { challenge in
                            ChallengeCell(challenge: challenge)
                        }
                        
                        // Final total footer
                        StandardTextCell(title: "Final", color: .green, textColor: .white)
                            .font(.title)
                            .frame(height: 150)
                            .border(Color.black)
                            .offset(y: 15)
                    }
                    .frame(width: 80, height: 60)
                    
                    // Par row
                    GridRow {
                        StandardTextCell(title: "Par", color: .brown, textColor: .white)

                        // Hole par cells
                        ForEach(course.holes) { hole in
                            HoleParNumberCell(hole: hole)
                        }
                        
                        TotalParCell(course: course)
                    }
                    .frame(width: 80, height: 60)
                    .border(Color.black)
                    
                    // Player's row & scores
                    ForEach(players, id: \.id) { player in
                        GridRow {
                            PlayerInfoCell(player: player)
                            
                            GridRow {
                                // Score box cells
                                ForEach(course.holes) { hole in
                                    ScoreBoxCell(playerIndex: getPlayerIndex(player), hole: hole)
                                        .environmentObject(vm)
                                }
                                
                                TotalScoreCell(player: player)
                                
                                // Challenge Score cells
                                ForEach(course.challenges.indices, id: \.self) { i in
                                    ChallengeScoreCell(player: player, index: i)
                                }
                                
                                FinalTotalScore(player: player)
                            }
                        }
                    }
                    .frame(width: 80, height: 120)
                    .border(Color.black)
                }
            }
        }
        
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func getPlayerIndex(_ player: Player) -> Int {
        guard let player = self.players.firstIndex(of: player) else { return 0 }
        return player
    }
    
}


struct ScoreCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCardView(
            course: MockData.instance.courses[0],
            players: MockData.instance.players
        )
        .environmentObject(ScoreCardViewModel(
            course: MockData.instance.courses[0],
            players: MockData.instance.players)
        )
    }
}




fileprivate struct StandardTextCell: View {
    var title: String
    var color: Color = .white
    var textColor: Color = .black
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
        }
    }
}


fileprivate struct ChallengeCell: View {
    var challenge: Challenge
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                
            Text("\(challenge.name)")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(2)
        }
        .border(Color.black)
        .offset(y: 15)
        .frame(height: 150)
    }
}


fileprivate struct HoleParNumberCell: View {
    var hole: Hole
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.brown)
            Text("\(hole.par)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}


fileprivate struct TotalParCell: View {
    var course: Course
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.brown)
            Text("\(course.totalPar())")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}


fileprivate struct BlankCell: View {
    var num: Int
    var color: Color
    
    init(numOfCells: Int, color: Color = .gray) {
        self.num = numOfCells
        self.color = color
    }
    
    var body: some View {
        ForEach(0..<num, id: \.self) { _ in
            Rectangle()
                .fill(color)
        }
    }
}


fileprivate struct PlayerInfoCell: View {
    var player: Player
    
    var body: some View {
        VStack {
            Circle()
                .stroke(.black, lineWidth: 1)
                .overlay {
                    Image(uiImage: player.getImage())
                        .resizable()
                        .clipShape(Circle())
                        .padding(2)
                }
                .frame(width: 40, height: 40)
            Text("\(player.name)")
        }
    }
}

// Score Box Cell
fileprivate struct ScoreBoxCell: View {
    @EnvironmentObject var vm: ScoreCardViewModel
    @State private var score: String = ""
    @FocusState var focusScoreBox
    var playerIndex: Int
    var hole: Hole
    
    init(playerIndex: Int, hole: Hole) {
        self.playerIndex = playerIndex
        self.hole = hole
    }
    
    
    var body: some View {
        ZStack {
            TextField("", text: $score)
                .foregroundColor(setScoreTextColor())
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .keyboardType(.numberPad)
                .onSubmit {
                    focusScoreBox = false
                    print("onSubmit")
                    vm.update(score, playerIndex: playerIndex, holeIndex: hole.number-1)
                }
            
            strokeType()
        }
        
        .submitLabel(.return)
    }
    
    @ViewBuilder private func strokeType() -> some View {
        if let score = Int(score) {
            if score <= hole.par - 2 {
                EagleScoreView()
            } else if score == hole.par - 1 {
                BirdieScoreView()
            } else if score == hole.par + 1 {
                BogieScoreView()
            } else if score >= hole.par + 1 {
                DoubleBogieScoreView()
            }
        }
    }
    
    fileprivate func setScoreTextColor() -> Color {
        if let score = Int(score) {
            if score <= hole.par - 2 {
                return Color.green
            } else if score == hole.par - 1 {
                return Color.green
            } else if score == hole.par + 1 {
                return Color.red
            } else if score >= hole.par + 1 {
                return Color.red
            }
        }
        return Color.black
    }
}


fileprivate struct TotalScoreCell: View {
    var player: Player
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            Text("\(player.total())")
                .font(.title)
                .fontWeight(.semibold)
        }
    }
}


fileprivate struct ChallengeScoreCell: View {
    var player: Player
    var index: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            Text("\(player.challengeScores[index])")
                .font(.title)
                .fontWeight(.semibold)
        }
//        .frame(width: 120)
    }
    
}


fileprivate struct FinalTotalScore: View {
    var player: Player
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            Text("\(player.finalTotal())")
                .font(.title)
                .fontWeight(.semibold)
        }
    }
}






fileprivate struct EagleScoreView: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(.black, lineWidth: 1)
            
            Circle()
                .stroke(.black, lineWidth: 1)
                .scaleEffect(0.8)
        }.padding()
    }
}


fileprivate struct BirdieScoreView: View {
    var body: some View {
        Circle()
            .stroke(.black, lineWidth: 1)
            .padding()
    }
}


fileprivate struct BogieScoreView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .border(Color.black)
            .aspectRatio(contentMode: .fit)
            .padding()
    }
}


fileprivate struct DoubleBogieScoreView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .border(Color.black)
                .aspectRatio(contentMode: .fit)
            
            Rectangle()
                .fill(Color.clear)
                .border(Color.black)
                .scaleEffect(0.8)
                .aspectRatio(contentMode: .fit)
        }.padding()
    }
}
