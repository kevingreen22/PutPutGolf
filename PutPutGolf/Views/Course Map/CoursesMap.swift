//
//  CoursesMap.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/27/23.
//

import SwiftUI

struct CoursesMap: View {
    @StateObject var coursesVM: CoursesViewModel
    @EnvironmentObject var navVM: NavigationStore
    @State private var showLogin = false
    @State private var loginCredentialsValid = false
    let dataService: any DataServiceProtocol
//    @AppStorage(AppStorageKeys.savedGames.description) var savedGames: [SavedGame] = []
    var navID: Int = 0
    
    init(coursesData: [Course], dataService: any DataServiceProtocol) {
        print("\(type(of: self)).\(#function)")
        _coursesVM = StateObject(wrappedValue: CoursesViewModel(coursesData: coursesData))
        self.dataService = dataService
    }
    
    
    var body: some View {
        NavigationStack(path: $navVM.path) {
            ZStack {
                MyMap()
                    .environmentObject(coursesVM)
//                    .overlay(alignment: .topTrailing) {              
//                        savedGamesMenu
//                    } // Saved games button/menu
                
                VStack(alignment: .leading, spacing: 0) {
                    headerBar.padding(.leading).padding(.trailing/*, 80*/)
                    Spacer()
                    courseInfoPanel
                }
            }
            
            .sheet(isPresented: $coursesVM.showCourseInfo) {
                CourseInfo(course: $coursesVM.selectedCourse)
                    .environmentObject(navVM)
                    .environmentObject(coursesVM)
                    .presentationCornerRadius(20)
            }
            
            .fullScreenCover(isPresented: $showLogin) {
                if loginCredentialsValid {
                    AddCourseInfo(loginCredentialsValid: $loginCredentialsValid, dataService: self.dataService, courses: coursesVM.coursesData)

                        .animation(.easeInOut(duration: 1), value: loginCredentialsValid)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    LoginView(loginCredentialsValid: $loginCredentialsValid)
                        .animation(.easeInOut(duration: 1), value: loginCredentialsValid)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            
            // Navigation
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Int.self) { navID in
                if navID == 1 {
                    SetupPlayers(coursesVM.selectedCourse)
                }
            }
            .navigationDestination(for: [Player].self) { players in
                ScoreCardView(course: coursesVM.selectedCourse, players: players)
            }
        }
    }
}

struct CoursesMap_Previews: PreviewProvider {
    static let mockData = MockData.instance
    static let dataService = MockDataService(mockData: mockData)
    
    static var previews: some View {
        CoursesMap(coursesData: mockData.courses, dataService: dataService)
            .environmentObject(CoursesViewModel(coursesData: mockData.courses))
            .environmentObject(NavigationStore())
    }
}




extension CoursesMap {
    
    fileprivate var headerBar: some View {
        VStack {
            HStack {
                Button(action: coursesVM.toggleCoursesList) {
                    Text(coursesVM.selectedCourse.address)
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .animation(.none, value: coursesVM.selectedCourse)
                        .overlay (alignment: .leading) {
                            Image (systemName: "arrow.down")
                                .font (.headline)
                                .foregroundColor(.primary)
                                .padding()
                                .rotationEffect(Angle(degrees: coursesVM.showCoursesList ? 180 : 0))
                        }
                }
                
                Button {
                    self.showLogin.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .frame(width: 40, height: 40)
                }.padding(.trailing) // Settings Button
            }
            if coursesVM.showCoursesList {
                CoursesList().environmentObject(coursesVM)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 15)
    }
    
//    fileprivate var savedGamesMenu: some View {
//        Menu {
//            Section("Previous Games") {
//                ForEach(savedGames) { savedGame in
//                    Button("\(savedGame.course.address) - \(savedGame.dateString) \(savedGame.isCompleted ? "✅" : "⚠️")") {
//                        coursesVM.selectedCourse = savedGame.course
//                        navVM.path.append(savedGame.players)
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
    
    fileprivate var courseInfoPanel: some View {
        ZStack {
            ForEach(coursesVM.coursesData) { course in
                if coursesVM.selectedCourse == course {
                    CourseInfoPanel(course: $coursesVM.selectedCourse)
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
    
}

