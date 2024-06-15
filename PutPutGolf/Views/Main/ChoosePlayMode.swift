//
//  ChoosePlayMode.swift
//  PutPutGolf
//
//  Created by Kevin Green on 2/29/24.
//

import SwiftUI
import KGViews

struct ChoosePlayMode: View {
    @Binding var currentPage: PageID
    var dataService: any DataServiceProtocol
    
    @EnvironmentObject var alertContext : AlertContext
    @StateObject var coursesVM: CoursesMap.ViewModel = CoursesMap.ViewModel()
    
    @AppStorage("app_audio") var allowAudio: Bool = true
    @AppStorage("app_haptics") var allowHaptics: Bool = true
    
    @State private var showSettings = false
    @State private var showMapplayFullScreen = false
    @State private var quickPlayButtonOffset: CGSize = CGSize(width: 400, height: 0)
    @State private var mapPlayButtonOffset: CGSize = CGSize(width: -400, height: 0)
    
        
    var body: some View {
        VStack {
            logo
            quickplayButton
            mapplayButton
        }

        .overlay(alignment: currentPage != .quickPlay ? .bottomTrailing : .topTrailing) {
            SettingsButton {
                self.showSettings.toggle()
            }
            .foregroundStyle(Color.white)
            .frame(width: 40, height: 40)
            .padding(.trailing, 16)
        } // Settings button
        
        .transition(.opacity)
        
        .onAppear {
            quickPlayButtonOffset = .zero
            mapPlayButtonOffset = .zero
        }
        
        .task {
            await fetchCourses()
        }
        
        .fullScreenCover(isPresented: $showMapplayFullScreen, content: {
            CoursesMap(dataService: dataService)
                .forceRotation(orientation: .portrait)
                .environmentObject(coursesVM)
                .transition(.opacity.combined(with: .scale))
        })
        
        .fullScreenCover(isPresented: $showSettings) {
            Settings(dataService: dataService)
                .environmentObject(coursesVM)
        }
    }
}

// MARK: Preview
#Preview {
    @State var currentPage: PageID = .chooseMode
    
    return ZStack {
        Image("golf_course").resizable().ignoresSafeArea()
        ChoosePlayMode(currentPage: $currentPage, dataService: MockDataService(mockData: MockData.instance))
            .environmentObject(CoursesMap.ViewModel())
    }
}



// MARK: Helper Methods
extension ChoosePlayMode {
    
    /// Fetches courses from the database
    fileprivate func fetchCourses() async {
        do {
            if coursesVM.coursesData.isEmpty {
                coursesVM.coursesData = try await dataService.fetchCourses()
                if let first = coursesVM.coursesData.first {
                    print("setting first course as selected course")
                    coursesVM.selectedCourse = first
                }
            }
        } catch AlertType.decodeFailure {
            alertContext.ofType(.decodeFailure)
        } catch AlertType.fetchFailed {
            alertContext.ofType(.fetchFailed)
        } catch {
            alertContext.ofType(.basic(title: "Offline Mode", message: "Your using offline mode. The \"Map Play\" option is disabled until you have an internet connection."))
        }
    }
    
}


// MARK: View Components
extension ChoosePlayMode {
    
    var backgroundImage: some View {
        Image("golf_course")
            .resizable()
            .ignoresSafeArea()
    }
    
    var logo: some View {
        Image("logo_banner")
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 12)
    }
    
    var quickplayButton: some View {
        Button {
            currentPage = .numOfPlayers
        } label: {
            VStack(spacing: 0) {
                Text("Quick Play")
                    .foregroundStyle(Color.white)
                    .font(.title)
                    .fontWeight(.semibold)
                Image("fire_ball")
                    .resizable()
                    .scaledToFit()
                Text("Pick players. Then putt.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .font(.title3)
            }
            .shadow(radius: 3)
            .padding()
            .background { KGRealBlur(style: .light) }
            .addBorder(Color.white, lineWidth: 5, cornerRadius: 30)
            .offset(quickPlayButtonOffset)
            .animation(.bouncy(duration: 0.7), value: quickPlayButtonOffset)
            .transition(.move(edge: .trailing))
            .shadow(radius: 10)
            .frame(width: 270)
        }
        .forceRotation(orientation: .portrait)
        .haptic(impact: .light, trigger: currentPage) { _ in
            allowHaptics ? true : false
        }
    }
        
    var mapplayButton: some View {
        Button {
            showMapplayFullScreen.toggle()
        } label: {
            VStack(spacing: 0) {
                Text("Map Play")
                    .foregroundStyle(Color.white)
                    .font(.title)
                    .fontWeight(.semibold)
                Image("treasure_map")
                    .resizable()
                    .scaledToFit()
                Text("Tailored experience based on your location.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .font(.title3)
            }
            .shadow(radius: 3)
            .padding()
            .background {
                KGRealBlur(style: .light)
            }
            .addBorder(Color.white, lineWidth: 5, cornerRadius: 30)
            .offset(mapPlayButtonOffset)
            .animation(.bouncy(duration: 0.7) , value: mapPlayButtonOffset)
            .transition(.move(edge: .leading))
            .shadow(radius: 10)
            .frame(width: 270)
        }
        .disabled(coursesVM.coursesData.isEmpty ? true : false)
        .grayscale(coursesVM.coursesData.isEmpty ? 1 : 0)
        .haptic(impact: .rigid, trigger: showMapplayFullScreen) { _ in
            allowHaptics ? true : false
        }
    }
    
}

