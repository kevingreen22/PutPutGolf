//
//  QuickPlaySetup.swift
//  PutPutGolf
//
//  Created by Kevin Green on 3/2/24.
//

import SwiftUI

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
    
    @State private var quickPlayers: [QuickPlayer] = []
    @State private var scrollProxy: ScrollViewProxy?
    @State private var numOfPlayers: Int?
    @State private var playerName = ""
    @State private var showWinnerView = false
    @State private var currentPage: PageID = .chooseMode
    
    @FocusState private var focusedField: FocusedField?
    @FocusState private var isFocused: Bool
    
    // PRODUCTION SERVICE
    var dataService: any DataServiceProtocol = ProductionDataService()

    // DEVELOPMENT MOCK SERVICE
    #warning("Development data service insatance.")
//    var dataService = MockDataService(mockData: MockData.instance)

   
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundImage
            GeometryReader { geo in
                ScrollViewReader { scroll in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center) {
                            ChoosePlayMode(currentPage: $currentPage, dataService: dataService)
                                .id(PageID.chooseMode)
                                .frame(width: geo.size.width)
                                .environmentObject(alertContext)
                            
                            SetPlayerCountPage(numOfPlayers: $numOfPlayers, focusedField: $focusedField)
                                .id(PageID.numOfPlayers)
                                .frame(width: geo.size.width)
                                .offset(y: 100)
                                .environmentObject(alertContext)
                            
                            SetPlayerNamesPage(numOfPlayers: $numOfPlayers, playerName: $playerName, focusedField: $focusedField)
                                .id(PageID.setPlayerNames)
                                .frame(width: geo.size.width)
                                .offset(y: 100)
                            
                            QuickPlay(quickPlayers: $quickPlayers, showWinnerView: $showWinnerView, isFocused: $isFocused)
                                .id(PageID.quickPlay)
                                .frame(width: geo.size.width)
                                .dismissKeyboardOnTap($isFocused)
                                .environmentObject(alertContext)
                            
                        }
                        .frame(height: geo.size.height)
                    }
                    .onAppear { scrollProxy = scroll }
                    
                    .onSubmit {
                        focusSubmition()
                    }
                    
                    .onChange(of: currentPage) { page in
                        moveTo(page: page, from: currentPage)
                    }
                    
                }.scrollDisabled(true)
            }
        }
        .ignoresSafeArea()
        
        .overlay(alignment: .topLeading) {
            backButton
        } // Back button
        
        .showAlert(alert: $alertContext.alert)
        
    }
}

#Preview {
    MainContent()
        .environmentObject(AlertContext())
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
                HapticManager.instance.feedback(.success)
                focusedField = .playerName
            } else {
                HapticManager.instance.feedback(.error)
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
                HapticManager.instance.feedback(.success)
            } else {
                HapticManager.instance.feedback(.error)
                focusedField = .playerName
            }
            
        default:
            print("____onSubmit: default")
            HapticManager.instance.feedback(.warning)
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

// MARK: Components
extension MainContent {
    
    var backButton: some View {
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
    
    var backgroundImage: some View {
        Image("golf_course")
            .resizable()
            .ignoresSafeArea()
            .dismissKeyboardOnTap($isFocused)
    }
    
}

