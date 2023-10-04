//
//  CoursesMapView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/27/23.
//

import SwiftUI

struct CoursesMapView: View {
    @EnvironmentObject var navVM: NavigationStore
    @EnvironmentObject var courseVM: CoursesViewModel
    @State private var screenSize: CGSize = .zero
    
    var body: some View {
        NavigationStack(path: $navVM.path) {
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
            
            // Navigation destinations via a Course
//            .navigationDestination(for: Course.self) { course in
////                if $courseVM.newPlayers.isEmpty {
//                    SetupPlayersView(course)
//                        .environmentObject(navVM)
////                } else {
////                    ScoreCardView(course: course)
////                        .environmentObject(navVM)
////                }
//            }
            
            .navigationDestination(for: Int.self, destination: { navID in
                if let course = courseVM.selectedCourse {
                    switch navID {
                    case 1:
                        SetupPlayersView(course)
                    case 2:
                        ScoreCardView(course: course)
                    default:
                        CoursesMapView()
                    }
                }
            })
            
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
            .environmentObject(NavigationStore())
    }
}





struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}



struct CoursesMapInfo {
    static var iconPlacement: [(RotationDegrees, CGPoint)] = [
        (.left,iconPositions[0]),
        (.leftMid,iconPositions[1]),
        (.rightMid,iconPositions[2]),
        (.right,iconPositions[3])
    ]
    
    static private var iconPositions: [CGPoint] = [
        CGPoint(x: 70, y: 500),
        CGPoint(x: 120, y: 700),
        CGPoint(x: 300, y: 700),
        CGPoint(x: 365, y: 500)
    ]
    
    static private var degrees: [RotationDegrees] = [.none,.left,.leftMid,.rightMid,.right]
    
    public enum RotationDegrees: Double {
        case none = 0
        case left = 27
        case leftMid = 10.0
        case rightMid = -10.0
        case right = -27
    }
}
