//
//  QuickPlay.swift
//  PutPutGolf
//
//  Created by Kevin Green on 3/4/24.
//

import SwiftUI
import KGViews

struct QuickPlay: View {
    @Binding var quickPlayers: [QuickPlayer]
    @Binding var showWinnerView: Bool
    var proxy: GeometryProxy
    @FocusState.Binding var isFocused: Bool
    
    @EnvironmentObject var alertContext: AlertContext

    @State private var holeNumber: Int = 0
    
    @AppStorage(UDKeys.audio) var allowAudio: Bool = true
    @AppStorage(UDKeys.haptics) var allowHaptics: Bool = true
    
    init(quickPlayers: Binding<[QuickPlayer]>, showWinnerView: Binding<Bool>, proxy: GeometryProxy, isFocused: FocusState<Bool>.Binding) {
        _quickPlayers = quickPlayers
        _showWinnerView = showWinnerView
        self.proxy = proxy
        _isFocused = isFocused
    }
    
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                title
                ForEach($quickPlayers, id: \.self) { quickPlayer in
                    cell(for: quickPlayer)
                        .dismissKeyboardOnTap($isFocused)
                }
                
                // Adds a blank section at the end of the list of players so the last player's entry box is not hidden behind the 3-way-toggle.
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 100)
            }
            
            .overlay(alignment: .bottom) {
                toggle3Way
            } // 3 Way Toggle
            
            if showWinnerView {
                winnerView
            }
            
        }
        .padding(.bottom, 40)
        .padding(.top, 50)
        .keyboardType(.numberPad)
        
        .onAppear {
            initPlayerScoreArray()
        }
    }
}

// MARK: Preview
#Preview {
    @FocusState var isFocused: Bool
    
    return GeometryReader { proxy in
        ZStack {
            Image("golf_course").resizable().ignoresSafeArea()
            QuickPlay(quickPlayers: .constant(MockData.instance.quickPlayers), showWinnerView: .constant(false), proxy: proxy, isFocused: $isFocused)
        }
    }
}



// MARK: Private Helper Methods
extension QuickPlay {
    
    /// This initializes each player's score array with one empty string. This represents the first hole before scores are added.
    fileprivate func initPlayerScoreArray() {
        for player in self.quickPlayers {
            player.scores = Array(repeating: "", count: 1)
        }
    }
    
    /// Increments the hole number and adds and empty score to each player for one more hole.
    fileprivate func setupForNextHole() {
        print("\(type(of: self)).\(#function)")
        holeNumber += 1
        
        // Add next empty element in scores array for each player.
        for player in quickPlayers {
            player.scores.append("")
        }
    }
    
    /// Checks that each player has a valid score for each hole currently.
    fileprivate func areAllPlayerScoresEnteredFor(hole: Int) -> Bool {
        print("\(type(of: self)).\(#function)")
        return quickPlayers.allSatisfy {
            !$0.scores.isEmpty &&
            $0.scores[holeNumber] != ""
        }
    }
}


// MARK: View Components
extension QuickPlay {
    
    fileprivate var title: some View {
        Text("Hole \(holeNumber+1)")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    fileprivate var toggle3Way: some View {
        Toggle3Way(
            sliderHandleImage: Image("golf_ball"),
            leadingSliderImage: Image(systemName: "flag.checkered.circle"),
            trailingSliderImage: Image(systemName: "flag.circle"),
            onSlideLeading: {
                // Finish game and show winner.
                // Checks that all scores are entered for the current hole for all players.
                if quickPlayers.allSatisfy({
                    ($0.scores.allSatisfy({
                        !$0.isEmpty && $0 != ""
                    }))
                }) {
                    // Prompts the user to confirm they are finished playing and to show the final scores.
                    var completion: Bool = true
                    alertContext.ofType(
                        .finishAndShowWinner(
                            action1: { showWinnerView = true },
                            action2: { finished in
                                completion = finished
                            })
                    )
                    if allowHaptics {
                        HapticManager.instance.impact(.heavy)
                    }
                    if allowAudio {
                        try? SoundManager.instance.playeffect(SoundEffect.clapping)
                    }
                    return completion
                }
                return false
            },
            onSlideTrailing: {
                // Continue to next hole
                if areAllPlayerScoresEnteredFor(hole: holeNumber) {
                    setupForNextHole()
                    if allowHaptics {
                        HapticManager.instance.impact(.soft)
                    }
                    if allowAudio {
                        try? SoundManager.instance.playeffect(SoundEffect.golfSwing)
                    }
                    return true
                }
                return false
            }
        )
        .bordered(shape: Capsule(), color: .accentColor, lineWidth: 5)
        .frame(width: proxy.size.width*0.9, height: 100)
        .background(Capsule().shadow(radius: 10))
    }
        
    fileprivate func cell(for quickPlayer: Binding<QuickPlayer>) -> some View {
        HStack {
            Text("\(quickPlayer.wrappedValue.name)")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.cellText)
                .padding(.leading, 20)
            Spacer()
            TextField("", text: quickPlayer.scores[holeNumber])
                .selectAllTextOnBeginEditing()
                .font(.custom("ChalkboardSE-Regular", size: 40))
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .frame(width: 100, height: 100)
                .background(Color.cellBackground)
                .addBorder(Color.accentColor, lineWidth: 5, cornerRadius: 20)
                .focused($isFocused)
                .submitLabel(.done)
                .padding()
        }
        .padding(.horizontal, 20)
        .background {
            KGRealBlur(style: .regular)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .shadow(radius: 8)
                .dismissKeyboardOnTap($isFocused)
        }
        .dismissKeyboardOnTap($isFocused)
    }
    
    fileprivate var winnerView: some View {
        QuickPlayWinnerView(quickPlayers: quickPlayers)
            .animation(.easeInOut, value: showWinnerView)
            .transition(.scale)
    }
    
}

