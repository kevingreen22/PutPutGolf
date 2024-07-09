//
//  CoursesMap.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/27/23.
//

import SwiftUI
import MapKit
import KGViews

struct CoursesMap: View {
    let dataService: any DataServiceProtocol
    
    @EnvironmentObject var coursesVM: ViewModel
    @StateObject var navStore: NavigationStore = NavigationStore()
    
//    @AppStorage(AppStorageKeys.savedGames.description) var savedGames: [SavedGame] = []
    
    @State private var showSettings = false
    @State private var loginCredentialsValid = false
    var navID: Int = NavigationStore.DestinationID.mapView
    
    init(dataService: any DataServiceProtocol) {
        print("\(type(of: self)).\(#function)")
        self.dataService = dataService
    }
    
    
    var body: some View {
        NavigationStack(path: $navStore.path) {
            ZStack {
                mapView
                
                VStack(alignment: .leading, spacing: 0) {
                    headerBar.padding(.leading).padding(.trailing)
                    Spacer()
                    courseInfoPanel
                }
            }
            // Navigation
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .navigationDestination(for: Int.self) { navID in
                if navID == 1 {
                    SetupPlayers(coursesVM.selectedCourse)
                        .lockOrientation(to: .portrait)
                        .environmentObject(navStore)
                }
            }
            .navigationDestination(for: [Player].self) { players in
                ScoreCardView(course: coursesVM.selectedCourse, players: players)
                    .forceRotation(orientation: .landscapeRight)
                    .environmentObject(navStore)
            }
        }
        
        .sheet(isPresented: $coursesVM.showCourseInfo) {
            CourseInfo()
                .environmentObject(navStore)
                .environmentObject(coursesVM)
        }
        
        .fullScreenCover(isPresented: $showSettings) {
            Settings(dataService: dataService)
                .environmentObject(coursesVM)
                .animation(.easeInOut(duration: 1), value: showSettings)
        }
        
        .showAlert(alert: $coursesVM.errorAlert)
        
    }
    
}

#Preview {
    let dataService = MockDataService(mockData: MockData.instance)
    let coursesVM = CoursesMap.ViewModel()
    coursesVM.coursesData = dataService.mockCourses
    coursesVM.selectedCourse = dataService.mockCourses.first!
    
    return CoursesMap(dataService: dataService)
        .environmentObject(coursesVM)
        .environmentObject(NavigationStore())
}



// MARK: Private Components
extension CoursesMap {
    
    fileprivate var mapView: some View {
        Map(coordinateRegion: $coursesVM.mapRegion,
            interactionModes: [.pan, .zoom],
            annotationItems: coursesVM.coursesData,
            annotationContent: { course in
            MapAnnotation(coordinate: course.coordinates) {
                CourseAnnotationItem()
                    .scaleEffect(coursesVM.selectedCourse == course ? 1.0 : 0.7)
                    .shadow(radius: coursesVM.selectedCourse == course ? 10 : 5)
                    .grayscale(coursesVM.selectedCourse == course ? 0.0 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1), value: coursesVM.selectedCourse)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
                            coursesVM.selectedCourse = course
                        }
                    }
            }
        })
        .ignoresSafeArea()
    }
    
    fileprivate var headerBar: some View {
        VStack {
            HStack(spacing: 16) {
                CloseButton(iconName: "chevron.left")
                    .padding(.leading)
                Divider().frame(height: 36)
                Button(action: coursesVM.toggleCoursesList) {
                    Text(coursesVM.selectedCourse.address)
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .animation(.none, value: coursesVM.selectedCourse)
                        .offset(y: -6)
                        .overlay (alignment: .bottom) {
                            Image (systemName: "chevron.down")
                                .font (.headline)
                                .foregroundColor(.gray)
                                .padding()
                                .rotationEffect(Angle(degrees: coursesVM.showCoursesList ? 180 : 0))
                                .offset(y: 12)
                        }
                }
                Divider().frame(height: 36)
                SettingsButton {
                    self.showSettings.toggle()
                }
                .frame(width: 26, height: 26)
                .padding(.trailing)
            }
            if coursesVM.showCoursesList {
                CoursesList().environmentObject(coursesVM)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 15)
    }
    
    fileprivate var bottomBar: some View {
        VStack {
            HStack(spacing: 16) {
                CloseButton(iconName: "chevron.left")
                    .padding(.leading)
                Divider().frame(height: 36)
                Button(action: coursesVM.toggleCoursesList) {
                    Text(coursesVM.selectedCourse.address)
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .animation(.none, value: coursesVM.selectedCourse)
                        .offset(y: 8)
                        .overlay (alignment: .top) {
                            Image (systemName: "chevron.up")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                                .rotationEffect(Angle(degrees: coursesVM.showCoursesList ? 180 : 0))
                                .offset(y: -10)
                        }
                }
                Divider().frame(height: 36)
                SettingsButton {
                    self.showSettings.toggle()
                }
                .frame(width: 26, height: 26)
                .padding(.trailing)
            }
            if coursesVM.showCoursesList {
                CoursesList()
                    .environmentObject(coursesVM)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(40)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 15)
        
    }

    fileprivate var courseInfoPanel: some View {
        ZStack {
            ForEach(coursesVM.coursesData) { course in
                if coursesVM.selectedCourse == course {
                    CourseInfoPanel()
                        .environmentObject(navStore)
                        .environmentObject(coursesVM)
                        .shadow(color: .black.opacity(0.3), radius: 20)
                        .padding(.horizontal)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading))
                        )
                }
            }
        }
    }

//    fileprivate var savedGamesMenu: some View {
//        Menu {
//            Section("Previous Games") {
//                ForEach(savedGames) { savedGame in
//                    Button("\(savedGame.course.address) - \(savedGame.dateString) \(savedGame.isCompleted ? "✅" : "⚠️")") {
//                        coursesVM.selectedCourse = savedGame.course
//                        navStore.path.append(savedGame.players)
//                    }
//                }
//            }
//        } label: {
//            Image(systemName: "figure.golf")
//                .font(.title)
//                .frame(width: 55, height: 55)
//                .background(.thickMaterial)
//                .cornerRadius(10)
//                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 15)
//                .overlay(alignment: .bottomTrailing) {
//                    Image(systemName: "chevron.down")
//                        .resizable()
//                        .frame(width: 8, height: 5)
//                        .padding(5)
//                }
//                .padding(.trailing)
//        }
//    }
    
}
