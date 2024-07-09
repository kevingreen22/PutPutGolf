//
//  WinnerVictoryView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 12/23/23.
//

import SwiftUI
import Combine
import ConfettiSwiftUI
import KGViews

struct WinnerVictoryView: View {
    var winner: Player
    var course: Course?
    
    @EnvironmentObject var vm: ScoreCardView.ViewModel

    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var cancellables = Set<AnyCancellable>()
    @State private var confettiCount = 0
    
    init(winner: Player, for course: Course?) {
        self.winner = winner
        self.course = course
    }
    
    init(winner: QuickPlayer) {
        let qPlayer = Player(id: UUID().uuidString, name: winner.name)
        self.winner = qPlayer
    }
    
    
    var body: some View {
        ZStack(alignment: .center) {
            background
            
            VStack {
                winnerView
                if vm.showBracketView { bracketView }
            }.offset(y: vm.showBracketView ? 200 : 0)
            
            if vm.showBracketView { closeButton }
        }
        .onTapGesture {
            withAnimation { vm.showBracketView.toggle() }
        }
        .transition(.asymmetric(insertion: .scale, removal: .move(edge: .bottom)))
        .onAppear { timer.connect().store(in: &cancellables) }
        
    }
}

#Preview {
    let mockData = MockData.instance
    
    return WinnerVictoryView(winner: mockData.players.first!, for: mockData.courses.first!)
        .environmentObject(NavigationStore())
        .environmentObject(ScoreCardView.ViewModel(course: mockData.courses.first!, players: mockData.players))
}



// MARK: Private Helper Methods
extension WinnerVictoryView {
    
    fileprivate func getParDifference(for player: Player) -> String? {
        guard let course = course else { return nil }
        let total = player.totalScore()
        let par = course.totalPar()
        var final = 0
//        print("total: \(total) - par: \(par)")
        if total < par {
            final = total - par
        } else {
            final = par - total
        }
        
        return (final > 0 ? "+" + String(final) : String(final))
    }
    
}


// MARK: Private Components
extension WinnerVictoryView {
    
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
                    Image(uiImage: winner.getUIImage())
                        .resizable()
                        .clipShape(Circle())
                        .bordered(shape: Circle(), color: .yellow)
                        .frame(width: 100, height: 100)
                    
                    Text(winner.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                }
                .offset(y: 30)
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
            ForEach(vm.winnerBracket) { player in
                HStack {
                    Image(uiImage: player.getUIImage())
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .bordered(shape: Circle(), color: .yellow)
                        .padding(5)
                    
                    Text(player.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(uiColor: .darkGray))
                    
                    if player == winner {
                        Image(systemName: "trophy.fill")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.5)
                            .foregroundStyle(Color.yellow)
                    }
                    
                    Spacer()
                    
                    if course != nil {
                        Text("\(String(describing: getParDifference(for: player)))")
                            .fontWeight(.medium)
                            .padding(.trailing)
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
   
    @ViewBuilder fileprivate var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                CloseButton(iconName: "xmark.circle.fill", withBackground: true) {
                    withAnimation { vm.showWinnerView = false }
                }
                .padding()
            }
            Spacer()
        }
    }
    
}
