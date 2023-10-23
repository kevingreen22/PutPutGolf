//
//  CoursesMap.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/27/23.
//

import SwiftUI

struct CoursesMap: View {
    @EnvironmentObject var navVM: NavigationStore
    @EnvironmentObject var coursesVM: CoursesViewModel
    @State private var screenSize: CGSize = .zero

    
    var body: some View {
        NavigationStack(path: $navVM.path) {
            ZStack {
                MyMap()
                    .environmentObject(coursesVM)
                    .overlay(alignment: .topTrailing) {                        
                        savedGamesMenu
                    } // Saved games button/menu
                
                VStack(alignment: .leading, spacing: 0) {
                    headerBar.padding(.leading).padding(.trailing, 80)
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
            
            // Navigation
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Int.self) { navID in
                if let course = coursesVM.selectedCourse {
                    SetupPlayers(course)
                }
            }
            
            // Screen size
            .overlay(
                GeometryReader {
                    Color.clear.preference(key: SizePreferenceKey.self, value: $0.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) {
                screenSize = $0
            }
            
        }
    }
}

struct CoursesMap_Previews: PreviewProvider {
    static var previews: some View {
        CoursesMap()
            .environmentObject(CoursesViewModel(dataService: MockDataService(mockData: MockData.instance)))
            .environmentObject(NavigationStore())
    }
}





struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}


extension CoursesMap {
    
    fileprivate var headerBar: some View {
        VStack {
            Button(action: coursesVM.toggleCoursesList) {
                Text(coursesVM.selectedCourse?.address ?? "Unknown")
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
            if coursesVM.showCoursesList {
                CoursesList()
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 15)
    }
    
    fileprivate var savedGamesMenu: some View {
        Menu {
            if let current = coursesVM.currentGame {
                Section("Current Game") {
                    Button("\(current.course.address) - \(current.dateString)") {
                        navVM.path.append(current.players)
                    }
                }
            }
            Section("Previous Games") {
                ForEach(coursesVM.allSavedGames) { savedGame in
                    Button("\(savedGame.course.address) - \(savedGame.dateString)") {
                        navVM.path.append(savedGame.players)
                    }
                }
            }
        } label: {
            Image(systemName: "figure.golf")
                .font(.title)
                .frame(width: 55, height: 55)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 15)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 8, height: 5)
                        .padding(5)
                }
                .padding(.trailing)
        } primaryAction: {
            // show current-game/last played score card
            if let players = coursesVM.currentGame?.players {
                navVM.path.append(players)
            }
        }
    }
    
    fileprivate var courseInfoPanel: some View {
        ZStack {
            ForEach(coursesVM.coursesData) { course in
                if coursesVM.selectedCourse == course {
                    CourseInfoPanel(course: $coursesVM.selectedCourse)
                                .shadow(color: .black.opacity(0.3), radius: 20)
                                .padding(.horizontal)
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
        }
    }
    
}

