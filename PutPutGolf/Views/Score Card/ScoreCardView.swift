//
//  ScoreCardView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI
import Combine

struct ScoreCardView: View {
    @EnvironmentObject var navVM: NavigationStore
    @StateObject var vm: ScoreCardViewModel
    @FocusState var isFocused: Bool
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    init(course: Course, players: [Player], isResumingGame resuming: Bool = false) {
        _vm = StateObject(wrappedValue: ScoreCardViewModel(course: course, players: players, isResumingGame: resuming))
    }
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.white.ignoresSafeArea()
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollView(.vertical, showsIndicators: false) {
                    Grid(horizontalSpacing: -1, verticalSpacing: -1) {
                        holeNumRow
                        parRow
                        playersRowAndScores
                    }
                    .scaleEffect(currentZoom + totalZoom)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                currentZoom = value.magnitude-1
                            }
                            .onEnded { value in
                                totalZoom += currentZoom
                                currentZoom = 0
                            }
                    )
                    // iOS 17+
            //        .gesture(
            //            MagnifyGesture()
            //                .onChanged { value in
            //                    currentZoom = value.magnification - 1
            //                }
            //                .onEnded { value in
            //                    totalZoom += currentZoom
            //                    currentZoom = 0
            //                }
            //        )
                    .accessibilityZoomAction { action in
                        if action.direction == .zoomIn {
                            totalZoom += 1
                        } else {
                            totalZoom -= 1
                        }
                    }
                }
            }
            .padding(.top)
            .toolbar(.hidden, for: .navigationBar)
            .overlay(alignment: .topTrailing) {
                closeButton
                    .padding(.trailing)
                    .offset(y: -35.0)
            }
            .overlay(alignment: .bottomTrailing) { // Custom keyboard top-area button.
                if isFocused {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color(uiColor: .separator))
                            .frame(height: 0.5)
                        Rectangle()
                            .fill(Color(uiColor: .secondarySystemBackground))
                            .frame(height: 45)
                            .overlay(alignment: .trailing) {
                                Button("Done") {
                                    isFocused = false
                                }.padding()
                            }
                    }
                    .animation(.linear, value: isFocused)
                }
            }
        }
    }
}

struct ScoreCardView_Previews: PreviewProvider {
    static let data = MockData.instance
    
    static var previews: some View {
        ScoreCardView(
            course: data.courses[0],
            players: data.players,
            isResumingGame: true
        )
    }
}



extension ScoreCardView {
    
    fileprivate var holeNumRow: some View {
        // Hole-num row
        GridRow {
            // Header cell
            StandardTextCell(title: "Hole", color: .green, textColor: .white)
                .border(Color.black)
            
            // Hole number
            ForEach(vm.course.holes) { hole in
                StandardTextCell(title: "\(hole.number)", color: .green, textColor: .white)
                    .border(Color.black)
            }
            
            // TOT footer
            StandardTextCell(title: "TOT", color: .green, textColor: .white)
                .border(Color.black)
            
            // Challenges desc.
            ForEach(vm.course.challenges) { challenge in
                ChallengeCell(challenge: challenge)
            }
            
            // Final total footer
            StandardTextCell(title: "Final", color: .green, textColor: .white)
                .font(.title)
                .frame(height: 120)
                .border(Color.black)
                .offset(y: 30)
        }
        .frame(width: 80, height: 60)
    }
    
    fileprivate var parRow: some View {
        // Par row
        GridRow {
            StandardTextCell(title: "Par", color: .brown, textColor: .white)

            // Hole par cells
            ForEach(vm.course.holes) { hole in
                HoleParNumberCell(hole: hole)
            }
            
            TotalParCell(course: vm.course)
        }
        .frame(width: 80, height: 60)
        .border(Color.black)
    }
    
    fileprivate var playersRowAndScores: some View {
        // Player's row & scores
        ForEach($vm.players.indices, id: \.self) { idx in
            GridRow {
                PlayerInfoCell(player: $vm.players[idx])
                
                GridRow {
                    // Score box cells
                    ForEach(vm.course.holes) { hole in
//                        ScoreBoxCell(holeScore: $vm.players[idx].scores[hole.number-1], hole: hole, playerColor:vm.players[idx].color)
//                            .environmentObject(vm)
                        scoreBoxCell(holeScore: $vm.players[idx].scores[hole.number-1], hole: hole, playerColor:vm.players[idx].color)
                    }
                    
                    TotalScoreCell(totalScore: $vm.totals[idx])

                    // Challenge Score cells
                    ForEach(vm.course.challenges.indices, id: \.self) { i in
//                        ChallengeScoreCell(challengeScore: $vm.players[idx].challengeScores[i], playerColor: vm.players[idx].color)
//                            .environmentObject(vm)
                        challengeScoreCell(challengeScore: $vm.players[idx].challengeScores[i], playerColor: vm.players[idx].color)
                    }
                    
                    FinalTotalScore(finalTotalScore: $vm.finalTotals[idx])
                }
            }
        }
        .frame(width: 80, height: 120)
        .border(Color.black)
    }

    fileprivate var closeButton: some View {
        Button {
            navVM.path = NavigationPath()
        } label: {
            Image(systemName: "xmark")
                .font(.largeTitle)
                .foregroundStyle(Color.white)
                .padding(8)
                .background(Color.gray.opacity(0.8).blur(radius: 3.0))
                .shadow(radius: 10)
                .clipShape(Circle())
        }
    }
    
    fileprivate func scoreBoxCell(holeScore: Binding<String>, hole: Hole, playerColor: Color) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(playerColor.gradient)
                        .frame(height: 5)
                }
            
            TextField("", text: holeScore)
                .focused($isFocused)
                .foregroundColor(setScoreTextColor(holeScore: holeScore.wrappedValue, hole: hole))
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .background(Color.white)
                .keyboardType(.numberPad)
            
            strokeType(holeScore: holeScore.wrappedValue, hole: hole)
        }
    }
    
    @ViewBuilder fileprivate func strokeType(holeScore: String, hole: Hole) -> some View {
        if let score = Int(holeScore) {
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
    
    fileprivate func setScoreTextColor(holeScore: String, hole: Hole) -> Color {
        if let score = Int(holeScore) {
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
    
    fileprivate func challengeScoreCell(challengeScore: Binding<String>, playerColor: Color) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(playerColor.gradient)
                        .frame(height: 5)
                }
            
            TextField("", text: challengeScore)
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .background(Color.white)
                .keyboardType(.decimalPad)
        }
    }
}



// Custom cell Views
fileprivate struct StandardTextCell: View {
    var title: String
    var font: Font = .title
    var fontWeight: Font.Weight = .semibold
    var color: Color = .white
    var textColor: Color = .black
    
    var body: some View {
        ZStack {
            Rectangle().fill(color)
            
            Text(title)
                .font(font)
                .fontWeight(fontWeight)
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
                .border(Color.black)
                
            Text("\(challenge.name)")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(2)
        }
        .offset(y: 30)
        .frame(height: 120)
    }
}

fileprivate struct HoleParNumberCell: View {
    var hole: Hole
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.brown)
            
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
            Rectangle().fill(Color.brown)
            
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
            Rectangle().fill(color)
        }
    }
}

fileprivate struct PlayerInfoCell: View {
    @Binding var player: Player
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(player.color.gradient)
                        .frame(height: 5)
                }
            
            VStack {
                Circle()
                    .stroke(player.color, lineWidth: 2)
                    .overlay {
                        Image(uiImage: player.getImage())
                            .resizable()
                            .clipShape(Circle())
                            .padding(2)
                    }
                    .background(Color.white.clipShape(Circle()))
                    .padding([.horizontal, .top], 8)
                    
                Text("\(player.name)")
                    .font(.title2)
                    .padding(.bottom, 10)
            }
        }
    }
}

fileprivate struct ScoreBoxCell: View {
    @EnvironmentObject var vm: ScoreCardViewModel
    @Binding var holeScore: String
    var hole: Hole
    var playerColor: Color
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(playerColor.gradient)
                        .frame(height: 5)
                }
            
            TextField("", text: $holeScore)
                .focused($isFocused)
                .foregroundColor(setScoreTextColor())
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .background(Color.white)
                .keyboardType(.numberPad)
                
            strokeType()
        }
    }
    
    @ViewBuilder 
    fileprivate func strokeType() -> some View {
        if let score = Int(holeScore) {
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
        if let score = Int(holeScore) {
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
    @Binding var totalScore: Int
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray)
            
            Text("\(totalScore)")
                .font(.title)
                .fontWeight(.semibold)
        }
    }
}

fileprivate struct ChallengeScoreCell: View {
    @EnvironmentObject var vm: ScoreCardViewModel
    @Binding var challengeScore: String
    var playerColor: Color
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(playerColor.gradient)
                        .frame(height: 5)
                }
            
            TextField("", text: $challengeScore)
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .background(Color.white)
                .keyboardType(.decimalPad)
        }
    }
}

fileprivate struct FinalTotalScore: View {
    @Binding var finalTotalScore: Int
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray)
            
            Text("\(finalTotalScore)")
                .font(.title)
                .fontWeight(.semibold)
        }
    }
}

// Custom score identifier views
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
