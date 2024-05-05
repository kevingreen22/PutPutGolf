//
//  ScoreCardExitMenuButton.swift
//  PutPutGolf
//
//  Created by Kevin Green on 12/31/23.
//

import SwiftUI
import Combine

struct ScoreCardExitMenuButton: View {
    var destination: NavigationStore.PutPutDestination

    @EnvironmentObject var navStore: NavigationStore
    @EnvironmentObject var vm: ScoreCardView.ViewModel
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var cancellables = Set<AnyCancellable>()
    @State private var menuScale: Double = 1
    
    
    var body: some View {
        Menu {
            winnerBracketButton
            exitToMapButton
        } label: {
            winnerBracketButtonLabel
        }
        
        .animation(
            .easeInOut(duration: 0.4)
            .repeatForever(autoreverses: true),
            value: menuScale
        )
        .onAppear {
            if vm.isGameCompleted {
                timer.connect().store(in: &cancellables)
            }
        }
        .onReceive(timer) { _ in
            menuScale = 2
        }

        .alert("Exit Score Card?", isPresented: $vm.showExitAlert) {
            Button("Exit", role: .destructive, action: { navStore.goto(destination) })
        } message: {
            Text("If you exit, your progress will be lost.")
        }
        
    }
}

#Preview {
    ScoreCardExitMenuButton(destination: .mapView)
        .environmentObject(ScoreCardView.ViewModel(course: MockData.instance.courses.first!, players: MockData.instance.players))
        .environmentObject(NavigationStore())
}



// MARK: Private Helper Methods
extension ScoreCardExitMenuButton {
    
    fileprivate func showExitAlert() {
        vm.showExitAlert.toggle()
    }
    
}


// MARK: Private Components
extension ScoreCardExitMenuButton {
    
    @ViewBuilder fileprivate var winnerBracketButton: some View {
        Button {
            withAnimation { vm.showBracketView = true; vm.showWinnerView = true }
        } label: {
            Label("Show Winner Bracket", systemImage: "trophy.fill")
        }.disabled(!vm.isGameCompleted)
    }
    
    @ViewBuilder fileprivate var winnerBracketButtonLabel: some View{
        Image(systemName: "button.programmable")
            .font(.largeTitle)
            .foregroundStyle(Color.gray.opacity(0.8))
            .background(Color.clear.blur(radius: 3.0))
            .shadow(radius: 8)
            .scaleEffect(1.3)
    }
    
    @ViewBuilder fileprivate var exitToMapButton: some View {
        Button(role: .destructive) {
            showExitAlert()
        } label: {
            Label("Exit To Map", systemImage: "xmark")
        }
    }
    
}

