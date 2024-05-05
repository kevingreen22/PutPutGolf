//
//  QuickPlayWinnerView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 4/18/24.
//

import SwiftUI
import Combine
import ConfettiSwiftUI

struct QuickPlayWinnerView: View {
    var quickPlayers: [QuickPlayer]
    
    private var winner: QuickPlayer
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var cancellables = Set<AnyCancellable>()
    @State private var confettiCount = 0
    @State private var showBracketView = false
    
    init(quickPlayers: [QuickPlayer]) {
        self.quickPlayers = quickPlayers.sorted(by: { $0.totalScore() < $1.totalScore() })
        self.winner = self.quickPlayers[quickPlayers.startIndex]
    }
    
    
    var body: some View {
        ZStack(alignment: .center) {
            background
            
            VStack {
                winnerView
                if showBracketView { bracketView }
            }.offset(y: showBracketView ? 200 : 0)
            
        }
        .onTapGesture {
            withAnimation { showBracketView.toggle() }
        }
        .transition(.asymmetric(insertion: .scale, removal: .move(edge: .bottom)))
        .onAppear { timer.connect().store(in: &cancellables) }
    }
    
}

#Preview {
    QuickPlayWinnerView(quickPlayers: MockData.instance.quickPlayers)
}



// MARK: Private Components
extension QuickPlayWinnerView {
    
    fileprivate var background: some View {
        Color.black
            .opacity(0.6)
            .ignoresSafeArea()
    }
    
    fileprivate var winnerView: some View {
        TimelineView(.animation(minimumInterval: 1, paused: false)) { context in
            let seconds = Calendar.current.component(.second, from: context.date)
            ZStack {
                VStack {
                    Text(winner.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                }
                .shadow(color: .white, radius: 2)
                .scaleEffect(seconds % 4 == 0 ? 1.5 : 0.8)
                .animation(.easeInOut(duration: 4), value: seconds)
                
                ViewThatFits {
                    Text("Winner!")
                        .font(.custom("gillSans", size: 100))
                    Text("Winner!")
                        .font(.custom("gillSans", size: 50))
                }
                .fontWeight(.heavy)
                .lineLimit(1)
                .foregroundStyle(Color.yellow)
                .shadow(color: .black, radius: 10)
                .shadow(color: .white, radius: 5)
                .offset(y: -90)
                .scaleEffect(seconds % 2 == 0 ? 1.2 : 0.8)
                .animation(.easeInOut(duration: 1), value: seconds)
            }
        }
        .confettiCannon(counter: $confettiCount)
        .onReceive(timer) { _ in confettiCount += 1 }
    }
    
    fileprivate var bracketView: some View {
        ScrollView {
            ForEach(Array(quickPlayers.enumerated()), id: \.element.id) { (index, player) in
                HStack(spacing: 20) {
                    
                    Text("\(index+1)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(uiColor: .white).opacity(0.7))
                        .background {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 32, height: 32)
                        }
                        .padding(.leading, 16)
                    
                    Text(player.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(uiColor: .darkGray))
                    
                    Spacer()
                    
                    if player == winner {
                        Image(systemName: "trophy.fill")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.5)
                            .foregroundStyle(Color.yellow)
                            .shadow(radius: 2)
                            .background(Circle().fill(Color.accentColor))
                            .padding(.trailing, 8)
                    }
                }
                .frame(height: 60)
                .background { Color.white }
                .cornerRadius(20)
            }
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .padding(.horizontal)
        }
        .forceRotation(orientation: .portrait)
        .scrollIndicators(.hidden)
        .frame(minWidth: 300, maxWidth: 400)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .scale))
    }
    
}

