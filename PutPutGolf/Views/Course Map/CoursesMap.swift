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
                MyMap().environmentObject(coursesVM)
                
                VStack(spacing: 0) {
                    headerBar.padding()
                    Spacer()
                    ZStack {
                        ForEach(coursesVM.coursesData) { course in
                            if coursesVM.selectedCourse == course {
                                courseInfoPanel
                            }
                        }
                    }
                }
            }
            
            .sheet(isPresented: $coursesVM.showCourseInfo) {
                CourseInfo(course: $coursesVM.selectedCourse)
                    .environmentObject(navVM)
                    .environmentObject(coursesVM)
                    .presentationCornerRadius(20)
            }
            
            
            // Navigation
            .navigationDestination(for: Int.self) { navID in
                if let course = coursesVM.selectedCourse {
                    SetupPlayers(course)
                }
            }
            .navigationBarTitleDisplayMode(.large)
            
            // Screen size
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { value in
                screenSize = value
            }
        }
    }
}

struct CoursesMap_Previews: PreviewProvider {
    static var previews: some View {
        CoursesMap()
            .environmentObject(CoursesViewModel(dataService: MockDataService(mockData: MockData())))
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
    
    fileprivate var courseInfoPanel: some View {
        CourseInfoPanel(course: $coursesVM.selectedCourse)
                    .shadow(color: .black.opacity(0.3), radius: 20)
                    .padding(.horizontal)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
}

