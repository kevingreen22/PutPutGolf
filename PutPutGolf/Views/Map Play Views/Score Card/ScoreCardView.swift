//
//  ScoreCardView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI
import Combine
import SwiftData
import KGViews
import KGToolbelt

struct ScoreCardView: View {
    @StateObject var vm: ViewModel
    @FocusState var isFocused: Bool
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var navStore: NavigationStore
    
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    @State private var position: CGSize = .zero
    @State private var showStatusBar = false
    
    init(course: Course, players: [Player], isResumingGame resuming: Bool = false) {
        print("\(type(of: self)).\(#function)")
        _vm = StateObject(wrappedValue: ViewModel(course: course, players: players, isResumingGame: resuming))
    }
    
    init(quickPlayers: [QuickPlayer], isResumingGame resuming: Bool = false) {
        print("\(type(of: self)).\(#function)")
        _vm = StateObject(wrappedValue: ViewModel(course: Course(), players: quickPlayers.asPlayerType(), isResumingGame: resuming, isQuickPlayGame: true))
    }
    
    
    var body: some View {
        ZStack {
            if !vm.isQuickPlayGame {
                background
            }
            GeometryReader { _ in scorecard.padding() }
            
            if !vm.isQuickPlayGame {
                HStack {
                    VStack {
                        ScoreCardExitMenuButton(destination: .mapView)
                            .padding(20)
                            .environmentObject(navStore)
                            .environmentObject(vm)
                        Spacer()
                    }
                    Spacer()
                } // Close/View Bracket Menu button
            }
            
            if vm.showWinnerView, let winner = vm.getWinner {
                withAnimation { winnerView(winner) }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .keyboardDoneButton(isFocused: $isFocused)
        .statusBarHidden(showStatusBar)
        .onDisappear { showStatusBar = true }
        
        .sheet(item: $vm.challenge) { challenge in
            ChallengeInfoView(challenge)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .cornerRadius(30)
        }
    }
}

// MARK: Preview
#Preview {
    let mockdata = MockData.instance
    
    return VStack {
        ScoreCardView(
            course: mockdata.courses[0],
            players: mockdata.players,
            isResumingGame: false
        )
        .environmentObject(NavigationStore())
        
//        Text("Challenge Info View Preview")
//            .sheet(item: .constant(MockData.instance.courses.first!.challenges.first!)) { challenge in
//                ChallengeInfoView(challenge)
//                    .presentationDetents([.medium])
//                    .presentationDragIndicator(.visible)
//                    .cornerRadius(30)
//            }
    }
}



// MARK: View Components
extension ScoreCardView {
    
    fileprivate var background: some View {
        ZStack {
            Image("golf_course")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: vm.showWinnerView ? 5 : 0)
                .onTapGesture(count: 2) {
                    withAnimation(.easeOut) {
                        position = .zero
                        currentZoom = 0
                        totalZoom = 1
                    }
            } // Resets the zoom/position of the score card to the default.
            
            Color.black.opacity(colorScheme == .dark ? 0.4 : 0)
        }
    }
    
    fileprivate var scorecard: some View {
        Grid(horizontalSpacing: -1, verticalSpacing: -1) {
            holeNumRow
            parRow
            playersRowAndScores
        }
        .addBorder(Color.accentColor, lineWidth: 6 , cornerRadius: 25)
        .scaleEffect(currentZoom + totalZoom)
        .offset(position)
        .gesture(SmoothDrag(location: $position))
        .gesture(zoomGesture)
        .modifier(AccessibilityZoom(zoom: $totalZoom))
        .blur(radius: vm.showWinnerView ? 5 : 0)
    }
    
    fileprivate func winnerView(_ winner: Player) -> some View {
        WinnerVictoryView(winner: winner, for: vm.course)
            .transition(.scale)
            .environmentObject(navStore)
            .environmentObject(vm)
    }
    
    fileprivate var zoomGesture: some Gesture {
        if #available(iOS 17.0, *) {
            return MagnifyGesture()
                .onChanged { value in
                    currentZoom = value.magnification-1
                }
                .onEnded { value in
                    totalZoom += currentZoom
                    currentZoom = 0
                }
        } else {
            // Fallback on earlier versions
            return MagnificationGesture()
                .onChanged { value in
                    currentZoom = value.magnitude-1
                }
                .onEnded { value in
                    totalZoom += currentZoom
                    currentZoom = 0
                }
        }
    }
    
    fileprivate var holeNumRow: some View {
        // Hole-num row
        GridRow {
            // Header cell
            StandardTextCell(title: "Hole", color: .accentColor, textColor: colorScheme == .dark ? .black : .white)
                .border(Color.white, width: 2)
            
            // Hole number
            ForEach(vm.course.holes) { hole in
                StandardTextCell(title: "\(hole.number)", color: .accentColor, textColor: colorScheme == .dark ? .black : .white)
                    .border(Color.white, width: 2)
            }
            
            // TOT footer
            StandardTextCell(title: "TOT", color: .accentColor, textColor: colorScheme == .dark ? .black : .white)
                .border(Color.white, width: 2)
            
            // Challenges desc.
            if let challenges = vm.course.challenges {
                ForEach(challenges) { challenge in
                    ChallengeCell(challenge: challenge)
                        .environmentObject(vm)
                }
            }
            
            // Final total footer
            StandardTextCell(title: "Final", color: .accentColor, textColor: colorScheme == .dark ? .black : .white)
                .font(.title)
                .frame(height: 120)
                .border(Color.white, width: 2)
                .offset(y: 30)
        }
        .frame(width: 80, height: 60)
    }
    
    fileprivate var parRow: some View {
        // Par row
        GridRow {
            StandardTextCell(title: "Par", color: .brown, textColor: colorScheme == .dark ? .black : .white)
            
            // Hole par cells
            ForEach(vm.course.holes) { hole in
                HoleParNumberCell(hole: hole)
            }
            
            TotalParCell(course: vm.course)
        }
        .frame(width: 80, height: 60)
        .border(Color.white, width: 2)
    }
    
    fileprivate var playersRowAndScores: some View {   
        // Player's row & scores
        ForEach($vm.players.indices, id: \.self) { playerIndex in
            GridRow {
                PlayerInfoCell(player: $vm.players[playerIndex])
                
                GridRow {
                    // Score box cells
                    ForEach(vm.course.holes) { hole in
                        ScoreBoxCell(player: $vm.players[playerIndex], hole: hole, isFocused: _isFocused)
                    }
                    
                    TotalScoreCell(totalScore: $vm.totals[playerIndex], playerColor: vm.players[playerIndex].color)
                    
                    // Challenge Score cells
                    if let challenges = vm.course.challenges {
                        ForEach(challenges.indices, id: \.self) { i in
                            ChallengeScoreCell(player: $vm.players[playerIndex], challengeIndex: i, isFocused: _isFocused)
                        }
                    }
                    
                    FinalTotalScore(finalTotalScore: $vm.finalTotals[playerIndex], playerColor: vm.players[playerIndex].color)
                }
            }
        }
        .frame(width: 80, height: 120)
        .border(Color.accentColor, width: 2)
    }
    
}

