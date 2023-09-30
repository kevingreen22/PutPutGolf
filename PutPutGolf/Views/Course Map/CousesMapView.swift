//
//  CoursesMapView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/27/23.
//

import SwiftUI

struct CoursesMapView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    @EnvironmentObject var courseVM: CoursesViewModel
    @State private var screenSize: CGSize = .zero
    
    
    var body: some View {
        NavigationStack(path: $courseVM.path) {
            ZStack {
                Color.green.ignoresSafeArea()
                
                CourseMapBallAndClubIcon(screenSize: $screenSize)
                    .environmentObject(courseVM)
                
                ForEach(0..<courseVM.coursesData.count, id: \.self) { index in
                    CourseMapIcon(image: courseVM.coursesData[index].getImage(), placement: CoursesMapInfo.iconPlacement[index])
                        .environmentObject(courseVM)
                }
            }
            
            .sheet(isPresented: $courseVM.showCourseInfo) {
                CourseInfoView(course: $courseVM.selectedCourse)
                    .environmentObject(navVM)
                    .environmentObject(courseVM)
                    .presentationDetents([
                        .height(550),
                        .height(300),
                        .height(70)
                    ], selection: .constant(.height(300)))
                    .presentationBackgroundInteraction(.enabled)
                    .presentationCornerRadius(40)
                    .interactiveDismissDisabled()
            }
            
            .navigationDestination(for: Course.self) { value in
                SetupPlayersView()
                    .environmentObject(navVM)
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

struct CoursesMapView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesMapView()
            .environmentObject(CoursesViewModel(url: nil))
            .environmentObject(NavigationViewModel())
    }
}





struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
