//
//  ScoreCardView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

struct ScoreCardView: View {
    let data = MockData.shared
    let course = MockData.shared.courses.first!
    
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
                        ForEach(data.courses.first!.holes) { hole in
                            StandardTextCell(title: "\(hole.number)", color: .green, textColor: .white)
                                .border(Color.black)
                        }
                        
                        // TOT footer
                        StandardTextCell(title: "TOT", color: .green, textColor: .white)
                            .border(Color.black)
                        
                        // Challenges desc.
                        ForEach(data.courses.first!.challenges) { challenge in
                            ChallengeCell(challenge: challenge)
                        }
                        
                        // Final total footer
                        StandardTextCell(title: "Final", color: .green, textColor: .white)
                            .font(.title)
                            .frame(height: 60)
                            .border(Color.black)
                            .offset(y: 15)
                    }
                    .frame(width: 80, height: 30)
                    
                    // Par row
                    GridRow {
                        StandardTextCell(title: "Par", color: .brown, textColor: .white)

                        // Hole par cells
                        ForEach(data.courses.first!.holes) { hole in
                            HoleParNumberCell(hole: hole)
                        }
                        
                        TotalParCell(course: data.courses.first!)
                    }
                    .frame(width: 80, height: 30)
                    .border(Color.black)
                    
                    // Player's row & scores
                    ForEach(data.players, id: \.id) { player in
                        GridRow {
                            PlayerInfoCell(player: player)
                            
                            GridRow {
                                // Score box cells
                                ForEach(course.holes) { hole in
                                    ScoreBoxCell(hole: hole, player: player)
                                }
                                
                                TotalScoreCell(player: player)
                                
                                // Challenge Score cells
                                ForEach(data.courses.first!.challenges.indices, id: \.self) { i in
                                    ChallengeScoreCell(player: player, index: i)
                                }
                                
                                FinalTotalScore(player: player)
                            }
                        }
                    }
                    .frame(width: 80, height: 100)
                    .border(Color.black)
                }
            }
        }
    }
    
    
}


struct ScoreCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScoreCardView()
        }
    }
}




struct StandardTextCell: View {
    var title: String
    var color: Color = .white
    var textColor: Color = .black
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
            Text(title)
                .bold()
                .foregroundColor(textColor)
        }
    }
}


struct ChallengeCell: View {
    var challenge: Challenge
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(height: 60)
            Text("\(challenge.name)")
                .bold()
                .foregroundColor(.white)
                .padding(2)
                .lineLimit(2)
        }
        .border(Color.black)
        .offset(y: 15)
    }
}


struct HoleParNumberCell: View {
    var hole: Hole
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.brown)
            Text("\(hole.par)")
                .bold()
                .foregroundColor(.white)
        }
    }
}


struct TotalParCell: View {
    var course: Course
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.brown)
            Text("\(course.totalPar())")
                .bold()
                .foregroundColor(.white)
        }
    }
}


struct BlankCell: View {
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


struct PlayerInfoCell: View {
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


struct ScoreBoxCell: View {
    var hole: Hole
    var player: Player
    @State var showEnterScoreview: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 80, height: 100)
                .onTapGesture {
                    showEnterScoreview.toggle()
                }
            Text(player.score(for: hole) ?? "")
            scoreType()
        }
        .sheet(isPresented: $showEnterScoreview) {
            EnterScoreView(player: player)
                .presentationDetents([.height(400)])
        }
        
        
    }
    
    @ViewBuilder private func scoreType() -> some View {
        if let strScr = player.score(for: hole), let score = Int(strScr) {
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
}


struct TotalScoreCell: View {
    var player: Player
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            Text("\(player.total())")
        }
    }
}


struct ChallengeScoreCell: View {
    var player: Player
    var index: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            Text("\(player.challengeScores[index])")
        }
    }
    
}


struct FinalTotalScore: View {
    var player: Player
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            Text("\(player.finalTotal())")
        }
    }
}












struct EagleScoreView: View {
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


struct BirdieScoreView: View {
    var body: some View {
        Circle()
            .stroke(.black, lineWidth: 1)
            .padding()
    }
}


struct BogieScoreView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .border(Color.black)
            .aspectRatio(contentMode: .fit)
            .padding()
    }
}


struct DoubleBogieScoreView: View {
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
