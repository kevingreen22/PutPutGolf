//
//  MyMap.swift
//  PutPutGolf
//
//  Created by Kevin Green on 10/6/23.
//

import SwiftUI
import MapKit

struct MyMap: View {
    @EnvironmentObject var coursesVM: CoursesViewModel
    
    
    var body: some View {
        Map(coordinateRegion: $coursesVM.mapRegion,
            interactionModes: [.pan, .zoom],
            annotationItems: coursesVM.coursesData,
            annotationContent: { course in
            MapAnnotation(coordinate: course.coordinates) {
                CourseAnnotationItem(course: course)
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
}

struct MyMap_Previews: PreviewProvider {
    static let mockData = MockData.instance
    
    static var previews: some View {
        MyMap()
            .environmentObject(CoursesViewModel(coursesData: mockData.courses))
    }
}

