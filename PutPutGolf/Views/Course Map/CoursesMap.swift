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
//            ZStack {
//                Color.green.ignoresSafeArea()
//                
//                CourseMapBallAndClubIcon(screenSize: $screenSize)
//                    .environmentObject(courseVM)
//                
//                ForEach(0..<courseVM.coursesData.count, id: \.self) { index in
//                    CourseMapIcon(image: courseVM.coursesData[index].getImage(), placement: CoursesMapInfo.iconPlacement[index])
//                        .environmentObject(courseVM)
//                }
//            }
            
            ZStack {
                MyMap()
                    .environmentObject(coursesVM)
                
                VStack(spacing: 0) {
                    headerBar.padding()
                    Spacer()
                    
                }
            }
            
            .sheet(isPresented: .constant(true)) {
                CourseInfo(course: $coursesVM.selectedCourse)
                    .environmentObject(navVM)
                    .environmentObject(coursesVM)
                    .presentationDetents([
                        .height(550),
                        .height(300),
                        .height(70)
                    ], selection: .constant(.height(70)))
                    .presentationBackgroundInteraction(.enabled)
                    .presentationCornerRadius(40)
                    .interactiveDismissDisabled()
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



extension CoursesMap {
    
    private var headerBar: some View {
        VStack {
            Button(action: coursesVM.toggleCoursesList) {
                Text(coursesVM.selectedCourse?.name ?? "")
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
