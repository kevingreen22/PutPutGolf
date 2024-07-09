//
//  QuickPlaySetup.swift
//  PutPutGolf
//
//  Created by Kevin Green on 3/2/24.
//
// <a href="https://www.flaticon.com/free-icons/scorecard" title="scorecard icons">Scorecard icons created by juicy_fish - Flaticon</a>
// <a href="https://www.flaticon.com/free-icons/table" title="table icons">Table icons created by Pixel perfect - Flaticon</a>

import SwiftUI
import KGViews

/// Page ID's for quick play horizontal scrolling.
enum PageID: Hashable {
    case chooseMode
    case numOfPlayers
    case setPlayerNames
    case quickPlay
}

enum FocusedField: Hashable {
    case setPlayerCount, playerName
}


struct MainContent: View {
    @StateObject var alertContext: AlertContext = AlertContext()
    @StateObject var coursesVM: CoursesMap.ViewModel = CoursesMap.ViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    @State private var quickPlayers: [QuickPlayer] = []
    @State private var scrollProxy: ScrollViewProxy?
    @State private var numOfPlayers: Int?
    @State private var playerName = ""
    @State private var showWinnerView = false
    @State private var showScoreCard = false
    @State private var currentPage: PageID = .chooseMode
    @State private var showSettings = false
    
    @State private var scale: CGFloat = 0
    @State private var rotation: CGFloat = 0
    @State private var navBlurOffset: CGFloat = -110
    
    @State private var holeNumber: Int = 0
    
    @FocusState private var focusedField: FocusedField?
    @FocusState private var isFocused: Bool
    
    @AppStorage(UDKeys.audio) var allowAudio: Bool = true
    @AppStorage(UDKeys.haptics) var allowHaptics: Bool = true
    
    // PRODUCTION SERVICE
//    var dataService: any DataServiceProtocol = ProductionDataService()

    // DEVELOPMENT MOCK SERVICE
    #warning("Development data service insatance.")
    var dataService = MockDataService(mockData: MockData.instance)

   
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundImage
            GeometryReader { geo in
                ScrollViewReader { scroll in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ChoosePlayMode(currentPage: $currentPage, dataService: dataService, proxy: geo)
                                .id(PageID.chooseMode)
                                .frame(width: geo.size.width)
                                .environmentObject(alertContext)
                                .environmentObject(coursesVM)
                            
                            SetPlayerCountPage(numOfPlayers: $numOfPlayers, focusedField: $focusedField)
                                .id(PageID.numOfPlayers)
                                .frame(width: geo.size.width)
                                .offset(y: 100)
                                .environmentObject(alertContext)
                            
                            SetPlayerNamesPage(numOfPlayers: $numOfPlayers, playerName: $playerName, focusedField: $focusedField)
                                .id(PageID.setPlayerNames)
                                .frame(width: geo.size.width)
                                .offset(y: 100)
                            
                            QuickPlay(quickPlayers: $quickPlayers, showWinnerView: $showWinnerView, holeNumber: $holeNumber, proxy: geo, isFocused: $isFocused)
                                .id(PageID.quickPlay)
                                .frame(width: geo.size.width)
                                .dismissKeyboardOnTap($isFocused)
                                .environmentObject(alertContext)
                        }
                        .overlay(alignment: .top) {
                            customBlurNavBar(proxy: geo)
                        }
                    }
                    .ignoresSafeArea()
                    .scrollDisabled(true)
                    .onAppear { scrollProxy = scroll }
                    .onSubmit {
                        focusSubmition()
                    }
                    .onChange(of: currentPage) { page in
                        moveTo(page: page, from: currentPage)
                        if currentPage != .chooseMode {
                            navBlurOffset = 0
                        }
                    }
                    .haptic(impact: .light, trigger: currentPage) { v in
                        allowHaptics ? true : false
                    }
                }.ignoresSafeArea(edges: .bottom)
            }
            if showScoreCard {
                quickplayBackground
                ScoreCardView(quickPlayers: self.quickPlayers, isResumingGame: self.quickPlayers.allSatisfy({ $0.scores.isEmpty }))
                    .environmentObject(NavigationStore(bind: $showScoreCard))
                    .transition(.scale(scale: scale))
                    .offset(y: 60)
            }
        }
                
        .overlay(alignment: .top) {
            title.opacity(currentPage == .quickPlay ? 1 : 0)
        } // Hole number title
        
        .overlay(alignment: .topLeading) {
            backButton.opacity(showScoreCard ? 0 : 1)
        } // Back button
        
        .overlay(alignment: .topTrailing) {
            scoreCardButton
        } // Scorecard button
        
        .overlay(alignment: currentPage == .quickPlay ? .topTrailing : .bottomTrailing) {
            settingsButton
        } // Settings button
        
        .fullScreenCover(isPresented: $showSettings) {
            Settings(dataService: dataService)
                .environmentObject(coursesVM)
        }
        
        .showAlert(alert: $alertContext.alert)
    }
}

// MARK: Preview
#Preview {
    MainContent()
        .environmentObject(AlertContext())
        .environmentObject(CoursesMap.ViewModel())
}


// MARK: Helper Methods
extension MainContent {
    
    fileprivate func focusSubmition() {
        print("\(type(of: self)).\(#function)")
        switch focusedField {
        case .setPlayerCount:
            print("____onSubmit: numOfPlayers")
            if let num = numOfPlayers, num > 0 && num < 10 {
                scrollTo(page: .setPlayerNames, completion: {
                    updateCurrentPage(to: .setPlayerNames)
                })
                if allowHaptics {
                    HapticManager.instance.feedback(.success)
                }
                focusedField = .playerName
            } else {
                if allowHaptics {
                    HapticManager.instance.feedback(.error)
                }
                alertContext.ofType(.wrongPlayerAmount)
            }
            
        case .playerName:
            print("____onSubmit: playerName")
            let quickPlayer = QuickPlayer(name: playerName)
            quickPlayer.scores = [""]
            quickPlayers.append(quickPlayer)
            playerName = ""
            
            if quickPlayers.count == numOfPlayers {
                focusedField = nil
                scrollTo(page: .quickPlay, completion: {
                    updateCurrentPage(to: .quickPlay)
                })
                if allowHaptics {
                    HapticManager.instance.feedback(.success)
                }
            } else {
                if allowHaptics {
                    HapticManager.instance.feedback(.error)
                }
                focusedField = .playerName
            }
            
        default:
            print("____onSubmit: default")
            if allowHaptics {
                HapticManager.instance.feedback(.warning)
            }
            focusedField = nil
        }
    }
    
    fileprivate func moveTo(page: PageID, from current: PageID) {
        print("\(type(of: self)).\(#function)")
        switch current {
        case .chooseMode:
            break
            
        case .numOfPlayers:
            scrollTo(page: page)
            focusedField = .setPlayerCount
            
        case .setPlayerNames:
            break
            
        case .quickPlay:
            break
        }
    }
    
    fileprivate func updateCurrentPage(to page: PageID) {
        print("\(type(of: self)).\(#function)")
        currentPage = page
    }
    
    @MainActor fileprivate func scrollTo(page: PageID, completion: (()->Void)? = nil) {
        print("\(type(of: self)).\(#function)")
        withAnimation(.easeInOut(duration: 0.2)) {
            scrollProxy?.scrollTo(page, anchor: .center)
            completion?()
        }
    }
    
    fileprivate func resetSetup() {
        print("\(type(of: self)).\(#function)")
        showWinnerView = false
        quickPlayers = []
#warning("Will need to delete this or reimplement")
//        quickPlayers.forEach({ player in
//            player.scores = Array(repeating: "", count: 1)
//        }) <---- This loop is implemented in QuickPlay.initPlayerScoreArray(). Shouldn't need this any more
        numOfPlayers = nil
        playerName = ""
    }
    
}

// MARK: View Components
extension MainContent {
    
    fileprivate func customBlurNavBar(proxy: GeometryProxy) -> some View {
        RealBlur(style: .regular)
            .ignoresSafeArea()
            .frame(height: proxy.safeAreaInsets.top+46)
            .offset(y: navBlurOffset)
            .opacity(currentPage == .chooseMode ? 0 : 1)
            .animation(.easeOut.delay(0.8), value: navBlurOffset)
    }
    
    fileprivate var title: some View {
        Text("Hole \(holeNumber+1)")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    fileprivate var backButton: some View {
        CloseButton(iconName: "chevron.left") {
            guard currentPage != .quickPlay else {
                alertContext.ofType(
                    .custom(
                        title: "Exit Game?",
                        message: "Are you sure? You will loose all your current scores and have to start your game over.",
                        buttons: [
                            Button(
                                role: .destructive,
                                action: {
                                    scrollTo(page: .chooseMode, completion: {
                                            isFocused = false
                                            focusedField = nil
                                            updateCurrentPage(to: .chooseMode)
                                            resetSetup()
                                        }
                                    )
                                },
                                label: {
                                    AnyView(Text("Exit"))
                                }
                            ),
                            Button(
                                role: .cancel,
                                action: {
                                    return
                                },
                                label: {
                                    AnyView(Text("Keep Playing"))
                                }
                            )
                        ]
                    )
                )
                return
            }
            scrollTo(page: .chooseMode, completion: {
                    isFocused = false
                    focusedField = nil
                    updateCurrentPage(to: .chooseMode)
                    resetSetup()
                }
            )
        }
        .padding(.leading)
        .padding(.top, 1)
        .opacity(currentPage != .chooseMode ? 1 : 0)
        .animation(.easeIn.delay(currentPage == .chooseMode ? 0 : 1), value: currentPage)
    }
    
    fileprivate var scoreCardButton: some View {
            Button {
                // show score card
                withAnimation(.easeInOut(duration: 1.2)) {
                    showScoreCard.toggle()
                }
            } label: {
                Image("score_card_icon")
                    .resizable()
                    .foregroundStyle(Color.accentColor)
                    .background(Color.white.opacity(0.7).blur(radius: 3.0))
                    .frame(width: 30, height: 30)
            }
            .padding(.trailing)
            .padding(.top, 10)
            .opacity(currentPage != .quickPlay ? 0 : 1)
            .offset(x: currentPage == .quickPlay ? -45 : 0)
            .animation(.easeIn, value: currentPage)
    }
    
    fileprivate var settingsButton: some View {
        SettingsButton {
            self.showSettings.toggle()
        }
        .foregroundStyle(Color.accentColor)
        .background(Color.white.opacity(0.7).blur(radius: 3.0).clipShape(Circle()))
        .frame(width: 30, height: 30)
        .padding(.top, 11)
        .padding(.trailing, 16)
        .animation(.easeIn, value: currentPage)
    }
    
    fileprivate var quickplayBackground: some View {
        ZStack {
            RealBlur(style: .regular, onTap: {
                withAnimation(.easeInOut(duration: 1.2)) {
                    showScoreCard.toggle()
                }
            }).ignoresSafeArea()
            
            Color.black
                .opacity(colorScheme == .dark ? 0.4 : 0)
                .allowsHitTesting(false)
        }
    }
    
    fileprivate var backgroundImage: some View {
        Image("golf_course")
            .resizable()
            .ignoresSafeArea()
            .dismissKeyboardOnTap($isFocused)
    }
    
}

