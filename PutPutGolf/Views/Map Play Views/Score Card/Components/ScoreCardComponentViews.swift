//
//  ScoreCardComponentViews.swift
//  PutPutGolf
//
//  Created by Kevin Green on 4/30/24.
//

import SwiftUI
import KGViews
import KGToolbelt

// MARK: Main Cell Views
struct ScoreBoxCell: View {
    @Binding var player: Player
    var hole: Hole
    
    @FocusState var isFocused: Bool
    
    @State private var scoreTextColor: Color = .white
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.cellBackground)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(player.color.gradient)
                        .frame(height: 8)
                        .blur(radius: 2)
                }
            
            TextField("", text: $player.scores[hole.number-1])
                .limitCharacterLength(limit: 1, text: $player.scores[hole.number-1])
                .selectAllTextOnBeginEditing()
                .focused($isFocused)
                .foregroundStyle(scoreTextColor)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .background(Color.clear)
                .keyboardType(.numberPad)
                .onChange(of: player.scores[hole.number-1]) { _ in
                    setScoreTextColor(holeScore: player.scores[hole.number-1], hole: hole)
                }
                .onAppear {
                    scoreTextColor = .cellBackground
                }
            
            strokeType(holeScore: player.scores[hole.number-1], hole: hole)
        }
    }
    
    @ViewBuilder fileprivate func strokeType(holeScore: String, hole: Hole) -> some View {
        if let score = Int(holeScore), score != 0 {
            if score == hole.par - 2 {
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
    
    fileprivate func setScoreTextColor(holeScore: String, hole: Hole) {
        if let score = Int(holeScore), score != 0 {
            if score == hole.par - 2 {          // double birdie
                scoreTextColor = Color.green
            } else if score == hole.par - 1 {   // birdie
                scoreTextColor = Color.green
            } else if score == hole.par + 1 {   // bogie
                scoreTextColor = Color.red
            } else if score >= hole.par + 1 {   // double bogie
                scoreTextColor = Color.red
            } else {                            // par
                scoreTextColor = Color.cellText
            }
        }
    }
    
}

struct ChallengeScoreCell: View {
    @Binding var player: Player
    var index: Int
    @FocusState var isFocused: Bool
    @State private var scoreTextColor: Color = .white
    
    init(player: Binding<Player>, challengeIndex index: Int, isFocused: FocusState<Bool>) {
        _player = player
        self.index = index
        _isFocused = isFocused
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.cellBackground)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(player.color.gradient)
                        .frame(height: 8)
                        .blur(radius: 2)
                }
            
            TextField("", text: $player.challengeScores[index])
                .limitCharacterLength(limit: 1, text: $player.challengeScores[index])
                .selectAllTextOnBeginEditing()
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .foregroundStyle(scoreTextColor)
                .fontWeight(.semibold)
                .background(.clear)//.scoreCellBackground)
                .keyboardType(.numberPad)
                .onChange(of: player.challengeScores[index]) { _ in
                    scoreTextColor = Color.cellText
                }
                .onAppear {
                    scoreTextColor = .cellBackground
                }
        }
    }
}

struct TotalScoreCell: View {
    @Binding var totalScore: String
    var playerColor: Color
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(playerColor.gradient)
                        .frame(height: 8)
                        .blur(radius: 2)
                }
            
            Text("\(totalScore)")
                .font(.title)
                .fontWeight(.semibold)
        }
    }
}

struct FinalTotalScore: View {
    @Binding var finalTotalScore: String
    var playerColor: Color
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(playerColor.gradient)
                        .frame(height: 8)
                        .blur(radius: 2)
                }
            
            Text("\(finalTotalScore)")
                .font(.title)
                .fontWeight(.semibold)
        }
    }
}

struct ChallengeInfoView: View {
    var challenge: Challenge
    
    init(_ challenge: Challenge) {
        self.challenge = challenge
    }
    
    var body: some View {
        VStackLayout {
            Spacer()
            ScrollView {
                Text(challenge.name)
                    .font(.title)
                    .fontWeight(.semibold)
                
                HStack(alignment: .bottom) {
                    challenge.difficulty.icon()
                    Text(challenge.difficulty.rawValue)
                }
                Spacer(minLength: 15)
                Text(challenge.rules)
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .closeButton().padding(.top).font(.title2)
    }
}



// MARK: Basic Cell Views
 struct StandardTextCell: View {
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

struct ChallengeCell: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: ScoreCardView.ViewModel
    var challenge: Challenge
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.accentColor)
                .border(Color.white, width: 2)
                
            Text("\(challenge.name)")
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .padding(2)
        }
        .overlay(alignment: .topTrailing) {
            Button("", systemImage: "i.circle") {
                vm.challenge = challenge
            }
            .padding(.top, 5)
            .foregroundStyle(Color.black)
        }
        .offset(y: 30)
        .frame(height: 120)
    }
}

struct HoleParNumberCell: View {
    @Environment(\.colorScheme) var colorScheme
    var hole: Hole
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.brown)
            
            Text("\(hole.par)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? .black : .white)
        }
    }
}

struct TotalParCell: View {
    @Environment(\.colorScheme) var colorScheme
    var course: Course
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.brown)
            
            Text("\(course.totalPar())")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? .black : .white)
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
            Rectangle().fill(color)
        }
    }
}

struct PlayerInfoCell: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var player: Player
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorScheme == .dark ? .black : .white)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(player.color.gradient)
                        .frame(height: 8)
                        .blur(radius: 2)
                }
            
            VStack {
                Circle()
                    .stroke(player.color, lineWidth: 2)
                    .overlay {
                        Image(uiImage: player.getUIImage())
                            .resizable()
                            .clipShape(Circle())
                            .padding(2)
                    }
                    .background(Color.white.clipShape(Circle()))
                    .padding([.horizontal, .top], 8)
                    
                Text("\(player.name)")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .font(.title2)
                    .truncationMode(.tail)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 10)
            }
        }
    }
}



// MARK: Custom Golf score "birdie/bogie" views; i.e. Golf square or circle.
struct EagleScoreView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Circle()
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
            
            Circle()
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
                .scaleEffect(0.8)
        }.padding()
    }
}

struct BirdieScoreView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Circle()
            .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
            .padding()
    }
}

struct BogieScoreView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Rectangle()
            .fill(.clear)
            .border(colorScheme == .dark ? .white : .black)
            .aspectRatio(contentMode: .fit)
            .padding()
    }
}

struct DoubleBogieScoreView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .border(colorScheme == .dark ? .white : .black)
                .aspectRatio(contentMode: .fit)
            
            Rectangle()
                .fill(.clear)
                .border(colorScheme == .dark ? .white : .black)
                .scaleEffect(0.8)
                .aspectRatio(contentMode: .fit)
        }.padding()
    }
}



//#Preview {
//
//}
