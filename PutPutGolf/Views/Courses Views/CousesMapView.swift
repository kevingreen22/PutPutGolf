//
//  CoursesMapView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/27/23.
//

import SwiftUI

struct CoursesMapView: View {
    @EnvironmentObject var vm: CoursesViewModel
    @State private var screenSize: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.top)
            
            CourseMapBallAndClubIcon(screenSize: $screenSize)
                .environmentObject(vm)
            
            ForEach(0..<vm.coursesData.count, id: \.self) { index in
                CourseMapIcon(image: vm.coursesData[index].getImage(), placement: CoursesMapInfo.iconPlacement[index])
                    .environmentObject(vm)
            }
        }
        
        .sheet(isPresented: $vm.showCourseInfo) {
            CourseInfoView(course: $vm.selectedCourse)
                .presentationDetents([
                    .height(550),
                    .height(300),
                    .height(70),
                ])
                .presentationBackgroundInteraction(.enabled)
                .presentationCornerRadius(30)
        }
        
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

struct CoursesMapView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesMapView()
            .environmentObject(CoursesViewModel(url: nil))
    }
}





struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
