//
//  Map.swift
//  PutPutGolf
//
//  Created by Kevin Green on 10/6/23.
//

import SwiftUI
import MapKit

struct MyMap: View {
    @EnvironmentObject var coursesVM: CoursesViewModel

    var body: some View {
//        if #available(iOS 17.0, *) {
//            Map(position: $coursesVM.mapPosition, interactionModes: []) {
//                ForEach(coursesVM.coursesData) { course in
//                    Annotation(course.name, coordinate: course.coordinates) {
//                        CourseAnnotationItem(course: course)
//                            .foregroundStyle(coursesVM.selectedCourse == course ? Color.clear : Color.gray)
//                            .scaleEffect(coursesVM.selectedCourse == course ? 1.0 : 0.6)
//                            .shadow(radius: 10)
//                            .onTapGesture {
//                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
//                                    coursesVM.selectedCourse = course
//                                }
//                            }
//                    }
//                }
//            }
//        } else {
            // Fallback on earlier versions
            Map(coordinateRegion: $coursesVM.mapRegion,
                interactionModes: [.pan, .zoom],
                annotationItems: coursesVM.coursesData,
                annotationContent: { course in
                MapAnnotation(coordinate: course.coordinates) {
                    CourseAnnotationItem(course: course)
                        .scaleEffect(coursesVM.selectedCourse == course ? 1.0 : 0.7)
                        .shadow(radius: 10)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
                                coursesVM.selectedCourse = course
                            }
                        }
                }
            })
            .ignoresSafeArea()
//        }
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        MyMap()
            .environmentObject(CoursesViewModel(url: nil))
        CourseAnnotationItem(course: MockData.instance.courses.first!)
    }
}











struct CourseAnnotationItem: View {
    var course: Course
    
    var body: some View {
        Circle()
            .stroke(.black, lineWidth: 3)
            .overlay {
                course.getImage()
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
            }
            .background { Color.white.clipShape(Circle()) }
            .frame(width: 60, height: 60)
    }
}