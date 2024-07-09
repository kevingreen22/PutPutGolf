//
//  QuickPlay.swift
//  PutPutGolf
//
//  Created by Kevin Green on 3/4/24.
//

import SwiftUI
import KGViews
import TipKit

struct QuickPlay: View {
    @Binding var quickPlayers: [QuickPlayer]
    @Binding var showWinnerView: Bool
    @Binding var holeNumber: Int
    var proxy: GeometryProxy
    @FocusState.Binding var isFocused: Bool
    
    @State private var cellAnimatables: (CGFloat, Double) = (0,1)
    
    @EnvironmentObject var alertContext: AlertContext
    
    @AppStorage(UDKeys.audio) var allowAudio: Bool = true
    @AppStorage(UDKeys.haptics) var allowHaptics: Bool = true
    
    init(quickPlayers: Binding<[QuickPlayer]>, showWinnerView: Binding<Bool>, holeNumber: Binding<Int>, proxy: GeometryProxy, isFocused: FocusState<Bool>.Binding) {
        _quickPlayers = quickPlayers
        _showWinnerView = showWinnerView
        _holeNumber = holeNumber
        self.proxy = proxy
        _isFocused = isFocused
    }
    
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                ForEach($quickPlayers, id: \.self) { quickPlayer in
                    cell(for: quickPlayer)
                        .dismissKeyboardOnTap($isFocused)
                }.offset(y: proxy.safeAreaInsets.top+58)
                
                // Adds a blank section at the end of the list of players so the last player's entry box is not hidden behind the 3-way-toggle.
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 100)
            }
            
            .overlay(alignment: .bottom) {
                toggle3Way.offset(y: -proxy.safeAreaInsets.bottom)
            } // 3 Way Toggle
            
            if showWinnerView {
                winnerView
            }
        }
        .keyboardType(.numberPad)
        .onAppear {
            initPlayerScoreArray()
        }
    }
}

// MARK: Preview
#Preview {
    @State var holeNumber: Int = 0
    @FocusState var isFocused: Bool
        
    return ZStack(alignment: .topLeading) {
        Image("golf_course").resizable().ignoresSafeArea()
        GeometryReader { geo in
            QuickPlay(quickPlayers: .constant(MockData.instance.quickPlayers), showWinnerView: .constant(false), holeNumber: $holeNumber, proxy: geo, isFocused: $isFocused)
                .frame(width: geo.size.width)
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
        withAnimation {
            holeNumber += 1
        }
        
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
                    withAnimation(.bouncy) {
                        cellAnimatables.0 = -500
                        cellAnimatables.1 = 0
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            cellAnimatables.0 = 500
                            withAnimation(.bouncy) {
                                cellAnimatables.0 = 0
                                cellAnimatables.1 = 1
                            }
                        }
                    }
                    return true
                }
                return false
            }
        )
        .bordered(shape: Capsule(), color: .accentColor, lineWidth: 5)
        .frame(width: proxy.size.width*0.9, height: 100)
        .background(Capsule().shadow(radius: 10))
//        .popoverTip(AppTips.FirstTip())
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
            RealBlur(style: .regular)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .shadow(radius: 8)
                .dismissKeyboardOnTap($isFocused)
        }
        .dismissKeyboardOnTap($isFocused)
        .offset(x: cellAnimatables.0)
        .opacity(cellAnimatables.1)
    }
    
    fileprivate var winnerView: some View {
        QuickPlayWinnerView(quickPlayers: quickPlayers)
            .animation(.easeInOut, value: showWinnerView)
            .transition(.scale)
    }
    
}

